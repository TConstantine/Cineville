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
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/genre_id_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockPreferencesDateSource extends Mock implements PreferencesDataSource {}

class MockNetwork extends Mock implements Network {}

class MockMovieDomainEntityMapper extends Mock implements MovieDomainEntityMapper {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  DataEntityBuilder movieDataEntityBuilder;
  DataEntityBuilder genreDataEntityBuilder;
  RemoteDataSource mockRemoteDataSource;
  DatabaseDataSource mockDatabaseDataSource;
  PreferencesDataSource mockPreferencesDateSource;
  Network mockNetwork;
  MovieDomainEntityMapper mockMovieDomainEntityMapper;
  MovieRepository movieDepository;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    movieDataEntityBuilder = MovieDataEntityBuilder();
    genreDataEntityBuilder = GenreDataEntityBuilder();
    mockRemoteDataSource = MockRemoteDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockPreferencesDateSource = MockPreferencesDateSource();
    mockNetwork = MockNetwork();
    mockMovieDomainEntityMapper = MockMovieDomainEntityMapper();
    movieDepository = MovieDepository(
      mockRemoteDataSource,
      mockDatabaseDataSource,
      mockPreferencesDateSource,
      mockNetwork,
      mockMovieDomainEntityMapper,
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;

    void getMoviesFromDatabaseDataSource(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return cached movies from database data source', () async {
        final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
        final List<Movie> movieDomainEntities = movieDomainEntityBuilder.buildList();
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => todayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);
        when(mockMovieDomainEntityMapper.map(any, any)).thenReturn(movieDomainEntities);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        verify(databaseDataSourceMovieRequest());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(movieDomainEntities)));
      });
    }

    getMoviesFromDatabaseDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getMoviesFromDatabaseDataSource(
      () => mockDatabaseDataSource.getMovieDataEntities(DataEntityType.SIMILAR_MOVIE, movieId),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getMoviesFromDatabaseDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getMoviesFromDatabaseDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;

    void getMoviesFromRemoteDataSource(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return movies from remote data source', () async {
        final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
        final int yesterdayInMillis = todayInMillis - 86400000;
        final List<Movie> movieDomainEntities = movieDomainEntityBuilder.buildList();
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);
        when(mockMovieDomainEntityMapper.map(any, any)).thenReturn(movieDomainEntities);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        verify(remoteDataSourceMovieRequest());
        expect(result, equals(Right(movieDomainEntities)));
      });
    }

    getMoviesFromRemoteDataSource(
      () => mockRemoteDataSource.getMovies(MovieCategory.POPULAR, page),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getMoviesFromRemoteDataSource(
      () => mockRemoteDataSource.getMovieDataEntities(DataEntityType.SIMILAR_MOVIE, movieId),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getMoviesFromRemoteDataSource(
      () => mockRemoteDataSource.getMovies(MovieCategory.TOP_RATED, page),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getMoviesFromRemoteDataSource(
      () => mockRemoteDataSource.getMovies(MovieCategory.UPCOMING, page),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();

    void storeMoviesLocally(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() databaseDataSourceStoreMovies,
    ) {
      test('should store movies locally when they are acquired from remote data source', () async {
        final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
        final int yesterdayInMillis = todayInMillis - 86400000;
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);

        await repositoryMovieRequest();

        verify(databaseDataSourceStoreMovies());
      });
    }

    storeMoviesLocally(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.POPULAR, movieDataEntities),
    );
    storeMoviesLocally(
      () => mockRemoteDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
      () => mockDatabaseDataSource.storeMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE, movieId, movieDataEntities),
    );
    storeMoviesLocally(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.TOP_RATED, movieDataEntities),
    );
    storeMoviesLocally(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.UPCOMING, movieDataEntities),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void getServerFailure(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return server failure when server throws an exception', () async {
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenThrow(ServerException());

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(ServerFailure())));
      });
    }

    getServerFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getServerFailure(
      () => mockRemoteDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getServerFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getServerFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void getNetworkFailure(Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest) {
      test('should return network failure when device is offline', () async {
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => false);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NetworkFailure())));
      });
    }

    getNetworkFailure(() => movieDepository.getMovies(MovieCategory.POPULAR, page));
    getNetworkFailure(() => movieDepository.getSimilarMovies(movieId));
    getNetworkFailure(() => movieDepository.getMovies(MovieCategory.TOP_RATED, page));
    getNetworkFailure(() => movieDepository.getMovies(MovieCategory.UPCOMING, page));
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void updateDateInPreferences(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() databaseDataSourceStoreMovies,
      Future Function() preferencesDataSourceStoreDate,
    ) {
      test('should update date in preferences after storing movies locally', () async {
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);

        await repositoryMovieRequest();

        verifyInOrder([
          databaseDataSourceStoreMovies(),
          preferencesDataSourceStoreDate(),
        ]);
      });
    }

    updateDateInPreferences(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.POPULAR, movieDataEntities),
      () => mockPreferencesDateSource.storeDate(PreferenceKey.POPULAR_MOVIES, any),
    );
    updateDateInPreferences(
      () => mockRemoteDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
      () => mockDatabaseDataSource.storeMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE, movieId, movieDataEntities),
      () => mockPreferencesDateSource.storeDate('${PreferenceKey.SIMILAR_MOVIES}-$movieId', any),
    );
    updateDateInPreferences(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.TOP_RATED, movieDataEntities),
      () => mockPreferencesDateSource.storeDate(PreferenceKey.TOP_RATED_MOVIES, any),
    );
    updateDateInPreferences(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.UPCOMING, movieDataEntities),
      () => mockPreferencesDateSource.storeDate(PreferenceKey.UPCOMING_MOVIES, any),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void getNoDataFailure(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() localDataSourceStoreMovies,
      Future Function() localDataSourceStoreDate,
    ) {
      test('should return no data failure when server responds with no results', () async {
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => []);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NoDataFailure())));
      });
    }

    getNoDataFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
      () => mockDatabaseDataSource.storeMovies(any, any),
      () => mockPreferencesDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      () => mockRemoteDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
      () => mockDatabaseDataSource.storeMovieDataEntities(any, any, any),
      () => mockPreferencesDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
      () => mockDatabaseDataSource.storeMovies(any, any),
      () => mockPreferencesDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
      () => mockDatabaseDataSource.storeMovies(any, any),
      () => mockPreferencesDateSource.storeDate(any, any),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void removeMoviesFromCache(
      Future<List<DataEntity>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() databaseDataSourceRemoveMovies,
      Future Function() databaseDataSourceStoreMovies,
    ) {
      test('should remove movies from cache before storing new ones', () async {
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);

        await repositoryMovieRequest();

        verifyInOrder([databaseDataSourceRemoveMovies(), databaseDataSourceStoreMovies()]);
      });
    }

    removeMoviesFromCache(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
      () => mockDatabaseDataSource.removeMovies(MovieCategory.POPULAR),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.POPULAR, movieDataEntities),
    );
    removeMoviesFromCache(
      () => mockRemoteDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
      () => mockDatabaseDataSource.removeSimilarMovies(movieId),
      () => mockDatabaseDataSource.storeMovieDataEntities(
          DataEntityType.SIMILAR_MOVIE, movieId, movieDataEntities),
    );
    removeMoviesFromCache(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
      () => mockDatabaseDataSource.removeMovies(MovieCategory.TOP_RATED),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.TOP_RATED, movieDataEntities),
    );
    removeMoviesFromCache(
      () => mockRemoteDataSource.getMovies(any, any),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
      () => mockDatabaseDataSource.removeMovies(MovieCategory.UPCOMING),
      () => mockDatabaseDataSource.storeMovies(MovieCategory.UPCOMING, movieDataEntities),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;

    void getGenresFromCache(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return genres from database data source', () async {
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        final List<int> genreIds = GenreIdBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => todayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);

        await repositoryMovieRequest();

        verify(mockDatabaseDataSource.getMovieGenres(genreIds));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    }

    getGenresFromCache(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getGenresFromCache(
      () => mockDatabaseDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getGenresFromCache(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getGenresFromCache(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;

    void getGenresFromRemoteDataSource(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should request genres from remote data source', () async {
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => todayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);

        await repositoryMovieRequest();

        verify(mockRemoteDataSource.getMovieGenres());
      });
    }

    getGenresFromRemoteDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getGenresFromRemoteDataSource(
      () => mockDatabaseDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getGenresFromRemoteDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getGenresFromRemoteDataSource(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;

    void storeGenres(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should store genres', () async {
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => todayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => genreDataEntities);

        await repositoryMovieRequest();

        verify(mockDatabaseDataSource.storeMovieGenres(genreDataEntities));
      });
    }

    storeGenres(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    storeGenres(
      () => mockDatabaseDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    storeGenres(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    storeGenres(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;

    void getNetworkFailure(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return network failure after requesting genres from remote data source',
          () async {
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => false);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NetworkFailure())));
      });
    }

    getNetworkFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getNetworkFailure(
      () => mockDatabaseDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getNetworkFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getNetworkFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });

  group('getMovies', () {
    final int page = 1;
    final int movieId = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;

    void getServerFailure(
      Future<List<DataEntity>> Function() databaseDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('should return server failure after requesting genres from remote data source',
          () async {
        final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
        when(mockPreferencesDateSource.getDate(any)).thenAnswer((_) async => todayInMillis);
        when(databaseDataSourceMovieRequest()).thenAnswer((_) async => movieDataEntities);
        when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getMovieGenres()).thenThrow(ServerException());

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(ServerFailure())));
      });
    }

    getServerFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.POPULAR),
      () => movieDepository.getMovies(MovieCategory.POPULAR, page),
    );
    getServerFailure(
      () => mockDatabaseDataSource.getMovieDataEntities(any, any),
      () => movieDepository.getSimilarMovies(movieId),
    );
    getServerFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.TOP_RATED),
      () => movieDepository.getMovies(MovieCategory.TOP_RATED, page),
    );
    getServerFailure(
      () => mockDatabaseDataSource.getMovies(MovieCategory.UPCOMING),
      () => movieDepository.getMovies(MovieCategory.UPCOMING, page),
    );
  });
}
