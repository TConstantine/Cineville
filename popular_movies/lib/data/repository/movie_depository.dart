import 'package:dartz/dartz.dart';
import 'package:popular_movies/data/datasource/local_data_source.dart';
import 'package:popular_movies/data/datasource/local_date_source.dart';
import 'package:popular_movies/data/datasource/remote_data_source.dart';
import 'package:popular_movies/data/error/exception/cache_exception.dart';
import 'package:popular_movies/data/error/exception/server_exception.dart';
import 'package:popular_movies/data/error/failure/cache_failure.dart';
import 'package:popular_movies/data/error/failure/network_failure.dart';
import 'package:popular_movies/data/error/failure/server_failure.dart';
import 'package:popular_movies/data/mapper/movie_mapper.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/data/network/network.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';

class MovieDepository implements MovieRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final LocalDateSource _localDateSource;
  final Network _network;
  final MovieMapper _mapper;

  MovieDepository(
    this._remoteDataSource,
    this._localDataSource,
    this._localDateSource,
    this._network,
    this._mapper,
  );

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page) async {
    List<MovieModel> movieModels;
    if (await _isCacheDateOld()) {
      if (await _network.isConnected()) {
        try {
          movieModels = await _remoteDataSource.getPopularMovies(page);
        } on ServerException {
          return Left(ServerFailure());
        }
        _localDataSource.storePopularMovies(movieModels);
        _localDateSource.storeDate(_getCurrentDateInMillis());
      } else {
        return Left(NetworkFailure());
      }
    } else {
      try {
        movieModels = await _localDataSource.getPopularMovies();
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    List<GenreModel> genreModels = await _getGenreModels(movieModels);
    if (genreModels.isEmpty) {
      if (await _network.isConnected()) {
        try {
          genreModels = await _remoteDataSource.getMovieGenres();
        } on ServerException {
          return Left(ServerFailure());
        }
        _localDataSource.storeGenres(genreModels);
      } else {
        return Left(NetworkFailure());
      }
    }
    return Right(_mapper.map(movieModels, genreModels));
  }

  Future<bool> _isCacheDateOld() async {
    final int cachedDateInMillis = await _localDateSource.getDate();
    final int dayInMillis = 86400000;
    return cachedDateInMillis == 0 || _getCurrentDateInMillis() - cachedDateInMillis > dayInMillis;
  }

  int _getCurrentDateInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<List<GenreModel>> _getGenreModels(List<MovieModel> movieModels) async {
    List<int> genreIds = [];
    movieModels.forEach((movieModel) => genreIds.addAll(movieModel.genreIds));
    genreIds = genreIds.toSet().toList();
    return await _localDataSource.getGenres(genreIds);
  }
}
