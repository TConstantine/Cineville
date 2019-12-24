import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/movie_mapper.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:dartz/dartz.dart';

class MovieDepository implements MovieRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final LocalDateSource localDateSource;
  final Network network;
  final MovieMapper mapper;

  MovieDepository(
    this.remoteDataSource,
    this.localDataSource,
    this.localDateSource,
    this.network,
    this.mapper,
  );

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page) {
    List<MovieModel> movieModels;
    return _getMovies(
      PreferenceKey.POPULAR_MOVIES,
      () async {
        movieModels = await localDataSource.getPopularMovies();
        return movieModels;
      },
      () async {
        movieModels = await remoteDataSource.getPopularMovies(page);
        return movieModels;
      },
      () {
        localDataSource.removePopularMovies();
        localDataSource.storePopularMovies(movieModels);
        return localDateSource.storeDate(PreferenceKey.POPULAR_MOVIES, _getCurrentDateInMillis());
      },
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId) {
    List<MovieModel> movieModels;
    final String preferenceKey = '${PreferenceKey.SIMILAR_MOVIES}-$movieId';
    return _getMovies(
      preferenceKey,
      () async {
        movieModels = await localDataSource.getSimilarMovies(movieId);
        return movieModels;
      },
      () async {
        movieModels = await remoteDataSource.getSimilarMovies(movieId);
        return movieModels;
      },
      () {
        localDataSource.removeSimilarMovies(movieId);
        localDataSource.storeSimilarMovies(movieId, movieModels);
        return localDateSource.storeDate(preferenceKey, _getCurrentDateInMillis());
      },
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies(int page) {
    List<MovieModel> movieModels;
    return _getMovies(
      PreferenceKey.TOP_RATED_MOVIES,
      () async {
        movieModels = await localDataSource.getTopRatedMovies();
        return movieModels;
      },
      () async {
        movieModels = await remoteDataSource.getTopRatedMovies(page);
        return movieModels;
      },
      () {
        localDataSource.removeTopRatedMovies();
        localDataSource.storeTopRatedMovies(movieModels);
        return localDateSource.storeDate(PreferenceKey.TOP_RATED_MOVIES, _getCurrentDateInMillis());
      },
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies(int page) {
    List<MovieModel> movieModels;
    return _getMovies(
      PreferenceKey.UPCOMING_MOVIES,
      () async {
        movieModels = await localDataSource.getUpcomingMovies();
        return movieModels;
      },
      () async {
        movieModels = await remoteDataSource.getUpcomingMovies(page);
        return movieModels;
      },
      () {
        localDataSource.removeUpcomingMovies();
        localDataSource.storeUpcomingMovies(movieModels);
        return localDateSource.storeDate(PreferenceKey.UPCOMING_MOVIES, _getCurrentDateInMillis());
      },
    );
  }

  Future<bool> _isCacheDateOld(String key) async {
    final int cachedDateInMillis = await localDateSource.getDate(key);
    final int dayInMillis = 86400000;
    return cachedDateInMillis == 0 || _getCurrentDateInMillis() - cachedDateInMillis > dayInMillis;
  }

  int _getCurrentDateInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<Either<Failure, List<Movie>>> _getMovies(
    String preferenceKey,
    Future<List<MovieModel>> Function() getLocalMovieModels,
    Future<List<MovieModel>> Function() getRemoteMovieModels,
    Future Function() storeMoviesLocally,
  ) async {
    List<MovieModel> movieModels = [];
    if (!await _isCacheDateOld(preferenceKey)) {
      movieModels = await getLocalMovieModels();
    } else if (await network.isConnected()) {
      try {
        movieModels = await getRemoteMovieModels();
      } on ServerException {
        return Left(ServerFailure());
      }
      if (movieModels.isEmpty) {
        return Left(NoDataFailure());
      }
      await storeMoviesLocally();
    } else {
      return Left(NetworkFailure());
    }
    return (await _getGenreModels(movieModels)).fold((failure) {
      return Left(failure);
    }, (genreModels) {
      return Right(mapper.map(movieModels, genreModels));
    });
  }

  Future<Either<Failure, List<GenreModel>>> _getGenreModels(List<MovieModel> models) async {
    List<GenreModel> genreModels = [];
    final List<int> genreIds = [];
    models.forEach((model) => genreIds.addAll(model.genreIds));
    genreModels = await localDataSource.getMovieGenres(genreIds.toSet().toList());
    if (genreModels.isEmpty) {
      if (await network.isConnected()) {
        try {
          genreModels = await remoteDataSource.getMovieGenres();
        } on ServerException {
          return Left(ServerFailure());
        }
        localDataSource.storeMovieGenres(genreModels);
      } else {
        return Left(NetworkFailure());
      }
    }
    return Right(genreModels);
  }
}
