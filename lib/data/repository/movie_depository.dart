import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:dartz/dartz.dart';

class MovieDepository implements MovieRepository {
  final RemoteDataSource _remoteDataSource;
  final DatabaseDataSource _databaseDataSource;
  final PreferencesDataSource _preferencesDataSource;
  final Network _network;
  final MovieDomainEntityMapper _movieDomainEntityMapper;

  MovieDepository(
    this._remoteDataSource,
    this._databaseDataSource,
    this._preferencesDataSource,
    this._network,
    this._movieDomainEntityMapper,
  );

  @override
  Future<Either<Failure, List<Movie>>> getMovies(String movieCategory, int page) {
    List<DataEntity> movieDataEntities;
    String preferenceKey;
    if (movieCategory == MovieCategory.POPULAR) {
      preferenceKey = PreferenceKey.POPULAR_MOVIES;
    } else if (movieCategory == MovieCategory.TOP_RATED) {
      preferenceKey = PreferenceKey.TOP_RATED_MOVIES;
    } else {
      preferenceKey = PreferenceKey.UPCOMING_MOVIES;
    }
    return _getMovies(
      preferenceKey,
      () async {
        movieDataEntities = await _databaseDataSource.getMovies(movieCategory);
        return movieDataEntities;
      },
      () async {
        movieDataEntities = await _remoteDataSource.getMovies(movieCategory, page);
        return movieDataEntities;
      },
      () {
        _databaseDataSource.removeMovies(movieCategory);
        _databaseDataSource.storeMovies(movieCategory, movieDataEntities);
        return _preferencesDataSource.storeDate(preferenceKey, _getCurrentDateInMillis());
      },
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId) {
    List<DataEntity> movieDataEntities;
    final String preferenceKey = '${PreferenceKey.SIMILAR_MOVIES}-$movieId';
    return _getMovies(
      preferenceKey,
      () async {
        movieDataEntities = await _databaseDataSource.getMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE,
          movieId,
        );
        return movieDataEntities;
      },
      () async {
        movieDataEntities = await _remoteDataSource.getMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE,
          movieId,
        );
        return movieDataEntities;
      },
      () {
        _databaseDataSource.removeSimilarMovies(movieId);
        _databaseDataSource.storeMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE,
          movieId,
          movieDataEntities,
        );
        return _preferencesDataSource.storeDate(preferenceKey, _getCurrentDateInMillis());
      },
    );
  }

  Future<bool> _isCacheDateOld(String key) async {
    final int cachedDateInMillis = await _preferencesDataSource.getDate(key);
    final int dayInMillis = 86400000;
    return cachedDateInMillis == 0 || _getCurrentDateInMillis() - cachedDateInMillis > dayInMillis;
  }

  int _getCurrentDateInMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future<Either<Failure, List<Movie>>> _getMovies(
    String preferenceKey,
    Future<List<DataEntity>> Function() getMovieDataEntitiesLocally,
    Future<List<DataEntity>> Function() getMovieDataEntitiesRemotely,
    Future Function() storeMoviesLocally,
  ) async {
    List<DataEntity> movieDataEntities = [];
    if (!await _isCacheDateOld(preferenceKey)) {
      movieDataEntities = await getMovieDataEntitiesLocally();
    } else if (await _network.isConnected()) {
      try {
        movieDataEntities = await getMovieDataEntitiesRemotely();
      } on ServerException {
        return Left(ServerFailure());
      }
      if (movieDataEntities.isEmpty) {
        return Left(NoDataFailure());
      }
      await storeMoviesLocally();
    } else {
      return Left(NetworkFailure());
    }
    return (await _getGenreDataEntities(movieDataEntities)).fold((failure) {
      return Left(failure);
    }, (genreDataEntities) {
      return Right(_movieDomainEntityMapper.map(movieDataEntities, genreDataEntities));
    });
  }

  Future<Either<Failure, List<DataEntity>>> _getGenreDataEntities(
      List<DataEntity> movieDataEntities) async {
    List<DataEntity> genreDataEntities = [];
    final List<int> genreIds = [];
    List<MovieDataEntity>.from(movieDataEntities).forEach((movieDataEntity) {
      genreIds.addAll(movieDataEntity.genreIds);
    });
    genreDataEntities = await _databaseDataSource.getMovieGenres(genreIds.toSet().toList());
    if (genreDataEntities.isEmpty) {
      if (await _network.isConnected()) {
        try {
          genreDataEntities = await _remoteDataSource.getMovieGenres();
        } on ServerException {
          return Left(ServerFailure());
        }
        _databaseDataSource.storeMovieGenres(genreDataEntities);
      } else {
        return Left(NetworkFailure());
      }
    }
    return Right(genreDataEntities);
  }
}
