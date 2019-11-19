import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/movie_mapper.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:dartz/dartz.dart';

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
    return await _getMovies(
      () async {
        movieModels = await _remoteDataSource.getPopularMovies(page);
        return movieModels;
      },
      () async {
        movieModels = await _localDataSource.getPopularMovies();
        return movieModels;
      },
      () => _localDataSource.storePopularMovies(movieModels),
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies(int page) async {
    List<MovieModel> movieModels;
    return await _getMovies(
      () async {
        movieModels = await _remoteDataSource.getTopRatedMovies(page);
        return movieModels;
      },
      () async {
        movieModels = await _localDataSource.getTopRatedMovies();
        return movieModels;
      },
      () => _localDataSource.storeTopRatedMovies(movieModels),
    );
  }

  Future<Either<Failure, List<Movie>>> _getMovies(
    Future<List<MovieModel>> Function() getMoviesRemotely,
    Future<List<MovieModel>> Function() getMoviesLocally,
    Future Function() storeMoviesLocally,
  ) async {
    List<MovieModel> movieModels;
    if (await _isCacheDateOld()) {
      Failure failure;
      (await _getMoviesRemotely(getMoviesRemotely, storeMoviesLocally)).fold(
        (remoteFailure) => failure = remoteFailure,
        (remoteMovieModels) => movieModels = remoteMovieModels,
      );
      if (failure != null) {
        return Left(failure);
      }
    } else {
      movieModels = await getMoviesLocally();
      if (movieModels.isEmpty) {
        Failure failure;
        (await _getMoviesRemotely(getMoviesRemotely, storeMoviesLocally)).fold(
          (remoteFailure) => failure = remoteFailure,
          (remoteMovieModels) => movieModels = remoteMovieModels,
        );
        if (failure != null) {
          return Left(failure);
        }
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

  Future<Either<Failure, List<MovieModel>>> _getMoviesRemotely(
    Future<List<MovieModel>> Function() getMoviesRemotely,
    Future Function() storeMoviesLocally,
  ) async {
    List<MovieModel> movieModels;
    if (await _network.isConnected()) {
      try {
        movieModels = await getMoviesRemotely();
      } on ServerException {
        return Left(ServerFailure());
      }
      storeMoviesLocally();
      _localDateSource.storeDate(_getCurrentDateInMillis());
      return Right(movieModels);
    } else {
      return Left(NetworkFailure());
    }
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
