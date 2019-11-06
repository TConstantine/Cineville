import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
import 'package:popular_movies/data/repository/movie_depository.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';

import '../../builder/genre_model_builder.dart';
import '../../builder/movie_builder.dart';
import '../../builder/movie_model_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockLocalDateSource extends Mock implements LocalDateSource {}

class MockNetwork extends Mock implements Network {}

class MockMovieMapper extends Mock implements MovieMapper {}

void main() {
  RemoteDataSource _mockRemoteDataSource;
  LocalDataSource _mockLocalDataSource;
  LocalDateSource _mockLocalDateSource;
  Network _mockNetwork;
  MovieMapper _mockMovieMapper;
  MovieRepository _repository;

  setUp(() {
    _mockRemoteDataSource = MockRemoteDataSource();
    _mockLocalDataSource = MockLocalDataSource();
    _mockLocalDateSource = MockLocalDateSource();
    _mockNetwork = MockNetwork();
    _mockMovieMapper = MockMovieMapper();
    _repository = MovieDepository(
      _mockRemoteDataSource,
      _mockLocalDataSource,
      _mockLocalDateSource,
      _mockNetwork,
      _mockMovieMapper,
    );
  });

  group('getPopularMovies', () {
    final int testPage = 1;
    final int testTodayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int testYesterdayInMillis = testTodayInMillis - 86400000;
    final List<MovieModel> testMovieModels = List.generate(3, (_) => MovieModelBuilder().build());
    final List<int> testGenreIds = testMovieModels.first.genreIds;
    final List<GenreModel> testGenreModels =
        List.generate(3, (index) => GenreModelBuilder().withId(testGenreIds[index]).build());
    final List<Movie> testMovies = List.generate(3, (_) => MovieBuilder().build());

    group('when cached date exists and is less than a day old', () {
      setUp(() {
        when(_mockLocalDateSource.getDate()).thenAnswer((_) async => testTodayInMillis);
      });

      group('and when movie cache is not empty', () {
        setUp(() {
          when(_mockLocalDataSource.getPopularMovies()).thenAnswer((_) async => testMovieModels);
        });

        test('should return cached movies', () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);
          when(_mockMovieMapper.map(any, any)).thenReturn(testMovies);

          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          verifyZeroInteractions(_mockNetwork);
          verifyZeroInteractions(_mockRemoteDataSource);
          expect(result, equals(Right(testMovies)));
        });

        test('and when genres are not cached should request genres from remote data source',
            () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => []);
          when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
          when(_mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);

          await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getMovieGenres());
        });

        test('should store genres when the remote data source request for genres is successful',
            () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => []);
          when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
          when(_mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);

          await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getMovieGenres());
          verify(_mockLocalDataSource.storeGenres(testGenreModels));
        });

        test(
            'should return server failure when the remote data source request for genres is unsuccessful',
            () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => []);
          when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
          when(_mockRemoteDataSource.getMovieGenres()).thenThrow(ServerException());

          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getMovieGenres());
          verifyZeroInteractions(_mockMovieMapper);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('and when movie cache is empty', () {
        setUp(() {
          when(_mockLocalDataSource.getPopularMovies()).thenThrow(CacheException());
        });

        test('should return cache failure', () async {
          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          expect(result, equals(Left(CacheFailure())));
        });
      });
    });

    group('when cahed date exists and is older than a day', () {
      setUp(() {
        when(_mockLocalDateSource.getDate()).thenAnswer((_) async => testYesterdayInMillis);
      });

      group('and when the device is online', () {
        setUp(() {
          when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
        });

        test('should return movies from remote data source', () async {
          when(_mockRemoteDataSource.getPopularMovies(any))
              .thenAnswer((_) async => testMovieModels);
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);
          when(_mockMovieMapper.map(any, any)).thenReturn(testMovies);

          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getPopularMovies(testPage));
          expect(result, equals(Right(testMovies)));
        });

        test('should store movies when the remote data source request for movies is successful',
            () async {
          when(_mockRemoteDataSource.getPopularMovies(any))
              .thenAnswer((_) async => testMovieModels);
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

          await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getPopularMovies(testPage));
          verify(_mockLocalDataSource.storePopularMovies(testMovieModels));
        });

        test(
            'should store the date when movies are stored after a successful remote date source request',
            () async {
          when(_mockRemoteDataSource.getPopularMovies(any))
              .thenAnswer((_) async => testMovieModels);
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

          await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getPopularMovies(testPage));
          verify(_mockLocalDateSource.storeDate(any));
        });

        test(
            'should return server failure when the remote data source request for movies is unsuccessful',
            () async {
          when(_mockRemoteDataSource.getPopularMovies(any)).thenThrow(ServerException());

          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          verify(_mockRemoteDataSource.getPopularMovies(testPage));
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('and when the device is offline', () {
        setUp(() {
          when(_mockNetwork.isConnected()).thenAnswer((_) async => false);
        });

        test('should return network failure when requesting movies remotely', () async {
          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    test('when cached date does not exist should return movies from remote data source', () async {
      when(_mockLocalDateSource.getDate()).thenAnswer((_) async => 0);
      when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
      when(_mockRemoteDataSource.getPopularMovies(any)).thenAnswer((_) async => testMovieModels);
      when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);
      when(_mockMovieMapper.map(any, any)).thenReturn(testMovies);

      final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

      verifyInOrder([
        _mockLocalDateSource.getDate(),
        _mockNetwork.isConnected(),
        _mockRemoteDataSource.getPopularMovies(testPage),
        _mockLocalDataSource.getGenres(testGenreIds),
        _mockMovieMapper.map(testMovieModels, testGenreModels),
      ]);
      expect(result, equals(Right(testMovies)));
    });
  });
}
