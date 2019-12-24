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
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_builder.dart';
import '../../test_util/test_movie_model_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockLocalDateSource extends Mock implements LocalDateSource {}

class MockNetwork extends Mock implements Network {}

class MockMapper extends Mock implements MovieMapper {}

void main() {
  RemoteDataSource mockRemoteDataSource;
  LocalDataSource mockLocalDataSource;
  LocalDateSource mockLocalDateSource;
  Network mockNetwork;
  MovieMapper mockMapper;
  MovieRepository repository;

  final int testPage = 1;
  final int testMovieId = 100;
  final int testTodayInMillis = DateTime.now().millisecondsSinceEpoch;
  final int testYesterdayInMillis = testTodayInMillis - 86400000;
  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final List<int> testGenreIds = testMovieModels.first.genreIds;
  final List<GenreModel> testGenreModels =
      List.generate(3, (index) => TestGenreModelBuilder().withId(testGenreIds[index]).build());
  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockLocalDateSource = MockLocalDateSource();
    mockNetwork = MockNetwork();
    mockMapper = MockMapper();
    repository = MovieDepository(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockLocalDateSource,
      mockNetwork,
      mockMapper,
    );
  });

  group('should return cached movies', () {
    void getCachedMovies(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);
        when(mockMapper.map(any, any)).thenReturn(testMovies);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        verify(localDataSourceMovieRequest());
        expect(result, equals(Right(testMovies)));
      });
    }

    getCachedMovies(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    getCachedMovies(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(testMovieId),
      () => repository.getSimilarMovies(testMovieId),
    );
    getCachedMovies(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    getCachedMovies(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should return movies from remote source', () {
    void getMoviesFromRemoteSource(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);
        when(mockMapper.map(any, any)).thenReturn(testMovies);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        verify(remoteDataSourceMovieRequest());
        expect(result, equals(Right(testMovies)));
      });
    }

    getMoviesFromRemoteSource(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(testPage),
      () => repository.getPopularMovies(testPage),
    );
    getMoviesFromRemoteSource(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(testMovieId),
      () => repository.getSimilarMovies(testMovieId),
    );
    getMoviesFromRemoteSource(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(testPage),
      () => repository.getTopRatedMovies(testPage),
    );
    getMoviesFromRemoteSource(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(testPage),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should return network failure', () {
    void getNetworkFailure(
      String title,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => false);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NetworkFailure())));
      });
    }

    getNetworkFailure('getPopularMovies', () => repository.getPopularMovies(testPage));
    getNetworkFailure('getSimilarMovies', () => repository.getSimilarMovies(testMovieId));
    getNetworkFailure('getTopRatedMovies', () => repository.getTopRatedMovies(testPage));
    getNetworkFailure('getUpcomingMovies', () => repository.getUpcomingMovies(testPage));
  });

  group('should return server failure', () {
    void getServerFailure(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenThrow(ServerException());

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(ServerFailure())));
      });
    }

    getServerFailure(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(any),
      () => repository.getPopularMovies(testPage),
    );
    getServerFailure(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    getServerFailure(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(any),
      () => repository.getTopRatedMovies(testPage),
    );
    getServerFailure(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(any),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should store movies locally', () {
    void storeMoviesLocally(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() localDataSourceStoreMovies,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);

        await repositoryMovieRequest();

        verify(localDataSourceStoreMovies());
      });
    }

    storeMoviesLocally(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(any),
      () => repository.getPopularMovies(testPage),
      () => mockLocalDataSource.storePopularMovies(testMovieModels),
    );
    storeMoviesLocally(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
      () => mockLocalDataSource.storeSimilarMovies(testMovieId, testMovieModels),
    );
    storeMoviesLocally(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(any),
      () => repository.getTopRatedMovies(testPage),
      () => mockLocalDataSource.storeTopRatedMovies(testMovieModels),
    );
    storeMoviesLocally(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(any),
      () => repository.getUpcomingMovies(testPage),
      () => mockLocalDataSource.storeUpcomingMovies(testMovieModels),
    );
  });

  group('should update cache date after storing movies locally', () {
    void updateCacheDate(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() localDataSourceStoreMovies,
      Future Function() localDataSourceStoreDate,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);

        await repositoryMovieRequest();

        verifyInOrder([
          localDataSourceStoreMovies(),
          localDataSourceStoreDate(),
        ]);
      });
    }

    updateCacheDate(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(any),
      () => repository.getPopularMovies(testPage),
      () => mockLocalDataSource.storePopularMovies(testMovieModels),
      () => mockLocalDateSource.storeDate(PreferenceKey.POPULAR_MOVIES, any),
    );
    updateCacheDate(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
      () => mockLocalDataSource.storeSimilarMovies(testMovieId, testMovieModels),
      () => mockLocalDateSource.storeDate('${PreferenceKey.SIMILAR_MOVIES}-$testMovieId', any),
    );
    updateCacheDate(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(any),
      () => repository.getTopRatedMovies(testPage),
      () => mockLocalDataSource.storeTopRatedMovies(testMovieModels),
      () => mockLocalDateSource.storeDate(PreferenceKey.TOP_RATED_MOVIES, any),
    );
    updateCacheDate(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(any),
      () => repository.getUpcomingMovies(testPage),
      () => mockLocalDataSource.storeUpcomingMovies(testMovieModels),
      () => mockLocalDateSource.storeDate(PreferenceKey.UPCOMING_MOVIES, any),
    );
  });

  group('should return no data failure', () {
    void getNoDataFailure(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() localDataSourceStoreMovies,
      Future Function() localDataSourceStoreDate,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => []);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NoDataFailure())));
        verifyNever(localDataSourceStoreMovies());
        verifyNever(localDataSourceStoreDate());
      });
    }

    getNoDataFailure(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(any),
      () => repository.getPopularMovies(testPage),
      () => mockLocalDataSource.storePopularMovies(any),
      () => mockLocalDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
      () => mockLocalDataSource.storeSimilarMovies(any, any),
      () => mockLocalDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(any),
      () => repository.getTopRatedMovies(testPage),
      () => mockLocalDataSource.storeTopRatedMovies(any),
      () => mockLocalDateSource.storeDate(any, any),
    );
    getNoDataFailure(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(any),
      () => repository.getUpcomingMovies(testPage),
      () => mockLocalDataSource.storeUpcomingMovies(any),
      () => mockLocalDateSource.storeDate(any, any),
    );
  });

  group('should remove movies from cache before storing new ones', () {
    void removeMoviesFromCache(
      String title,
      Future<List<MovieModel>> Function() remoteDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
      Future Function() localDataSourceRemoveMovies,
      Future Function() localDataSourceStoreMovies,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testYesterdayInMillis);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(remoteDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);

        await repositoryMovieRequest();

        verifyInOrder([localDataSourceRemoveMovies(), localDataSourceStoreMovies()]);
      });
    }

    removeMoviesFromCache(
      'getPopularMovies',
      () => mockRemoteDataSource.getPopularMovies(any),
      () => repository.getPopularMovies(testPage),
      () => mockLocalDataSource.removePopularMovies(),
      () => mockLocalDataSource.storePopularMovies(testMovieModels),
    );
    removeMoviesFromCache(
      'getSimilarMovies',
      () => mockRemoteDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
      () => mockLocalDataSource.removeSimilarMovies(testMovieId),
      () => mockLocalDataSource.storeSimilarMovies(testMovieId, testMovieModels),
    );
    removeMoviesFromCache(
      'getTopRatedMovies',
      () => mockRemoteDataSource.getTopRatedMovies(any),
      () => repository.getTopRatedMovies(testPage),
      () => mockLocalDataSource.removeTopRatedMovies(),
      () => mockLocalDataSource.storeTopRatedMovies(testMovieModels),
    );
    removeMoviesFromCache(
      'getUpcomingMovies',
      () => mockRemoteDataSource.getUpcomingMovies(any),
      () => repository.getUpcomingMovies(testPage),
      () => mockLocalDataSource.removeUpcomingMovies(),
      () => mockLocalDataSource.storeUpcomingMovies(testMovieModels),
    );
  });

  group('should return genres from cache', () {
    void getGenresFromCache(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);

        await repositoryMovieRequest();

        verify(mockLocalDataSource.getMovieGenres(testGenreIds));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    }

    getGenresFromCache(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    getGenresFromCache(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    getGenresFromCache(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    getGenresFromCache(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should request genres from remote data source', () {
    void getGenresFromRemoteDataSource(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);

        await repositoryMovieRequest();

        verify(mockRemoteDataSource.getMovieGenres());
      });
    }

    getGenresFromRemoteDataSource(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    getGenresFromRemoteDataSource(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    getGenresFromRemoteDataSource(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    getGenresFromRemoteDataSource(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should store genres', () {
    void storeGenres(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);

        await repositoryMovieRequest();

        verify(mockLocalDataSource.storeMovieGenres(testGenreModels));
      });
    }

    storeGenres(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    storeGenres(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    storeGenres(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    storeGenres(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should return network failure after requesting genres from remote data source', () {
    void getNetworkFailure(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => false);

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(NetworkFailure())));
      });
    }

    getNetworkFailure(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    getNetworkFailure(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    getNetworkFailure(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    getNetworkFailure(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });

  group('should return server failure after requesting genres from remote data source', () {
    void getServerFailure(
      String title,
      Future<List<MovieModel>> Function() localDataSourceMovieRequest,
      Future<Either<Failure, List<Movie>>> Function() repositoryMovieRequest,
    ) {
      test('from $title', () async {
        when(mockLocalDateSource.getDate(any)).thenAnswer((_) async => testTodayInMillis);
        when(localDataSourceMovieRequest()).thenAnswer((_) async => testMovieModels);
        when(mockLocalDataSource.getMovieGenres(any)).thenAnswer((_) async => []);
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getMovieGenres()).thenThrow(ServerException());

        final Either<Failure, List<Movie>> result = await repositoryMovieRequest();

        expect(result, equals(Left(ServerFailure())));
      });
    }

    getServerFailure(
      'getPopularMovies',
      () => mockLocalDataSource.getPopularMovies(),
      () => repository.getPopularMovies(testPage),
    );
    getServerFailure(
      'getSimilarMovies',
      () => mockLocalDataSource.getSimilarMovies(any),
      () => repository.getSimilarMovies(testMovieId),
    );
    getServerFailure(
      'getTopRatedMovies',
      () => mockLocalDataSource.getTopRatedMovies(),
      () => repository.getTopRatedMovies(testPage),
    );
    getServerFailure(
      'getUpcomingMovies',
      () => mockLocalDataSource.getUpcomingMovies(),
      () => repository.getUpcomingMovies(testPage),
    );
  });
}
