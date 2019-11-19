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
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
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

  final int testPage = 1;
  final int testTodayInMillis = DateTime.now().millisecondsSinceEpoch;
  final int testYesterdayInMillis = testTodayInMillis - 86400000;
  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final List<int> testGenreIds = testMovieModels.first.genreIds;
  final List<GenreModel> testGenreModels =
      List.generate(3, (index) => TestGenreModelBuilder().withId(testGenreIds[index]).build());
  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();

  void _whenCachedDateIsLessThanADayOld(Function body) {
    group('when cached date exists and is less than a day old', () {
      setUp(() {
        when(_mockLocalDateSource.getDate()).thenAnswer((_) async => testTodayInMillis);
      });

      body();
    });
  }

  void _whenCachedDateIsOlderThanADay(Function body) {
    group('when cached date exists and is older than a day', () {
      setUp(() {
        when(_mockLocalDateSource.getDate()).thenAnswer((_) async => testYesterdayInMillis);
      });

      body();
    });
  }

  void _whenCachedDateDoesNotExist(Function body) {
    group('when cached date does not exist', () {
      setUp(() {
        when(_mockLocalDateSource.getDate()).thenAnswer((_) async => 0);
      });

      body();
    });
  }

  void _whenPopularMovieCacheIsNotEmpty(Function body) {
    group('when popular movie cache is not empty', () {
      setUp(() {
        when(_mockLocalDataSource.getPopularMovies()).thenAnswer((_) async => testMovieModels);
      });

      body();
    });
  }

  void _whenTopRatedMovieCacheIsNotEmpty(Function body) {
    group('when top rated movie cache is not empty', () {
      setUp(() {
        when(_mockLocalDataSource.getTopRatedMovies()).thenAnswer((_) async => testMovieModels);
      });

      body();
    });
  }

  void _whenPopularMovieCacheIsEmpty(Function body) {
    group('when popular movie cache is empty', () {
      setUp(() {
        when(_mockLocalDataSource.getPopularMovies()).thenAnswer((_) async => []);
      });

      body();
    });
  }

  void _whenTopRatedMovieCacheIsEmpty(Function body) {
    group('when top rated movie cache is empty', () {
      setUp(() {
        when(_mockLocalDataSource.getTopRatedMovies()).thenAnswer((_) async => []);
      });

      body();
    });
  }

  void _whenGenreCacheIsEmpty(Function body) {
    group('when genre cache is empty', () {
      setUp(() {
        when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => []);
      });

      body();
    });
  }

  void _whenDeviceIsOnline(Function body) {
    group('when device is online', () {
      setUp(() {
        when(_mockNetwork.isConnected()).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void _whenDeviceIsOffline(Function body) {
    group('when device is offline', () {
      setUp(() {
        when(_mockNetwork.isConnected()).thenAnswer((_) async => false);
      });

      body();
    });
  }

  void _whenRemoteRequestForPopularMoviesIsSuccessful(Function body) {
    group('when remote request for popular movies is successful', () {
      setUp(() {
        when(_mockRemoteDataSource.getPopularMovies(any)).thenAnswer((_) async => testMovieModels);
      });

      body();
    });
  }

  void _whenRemoteRequestForPopularMoviesIsUnsuccessful(Function body) {
    group('when remote request for popular movies is unsuccessful', () {
      setUp(() {
        when(_mockRemoteDataSource.getPopularMovies(any)).thenThrow(ServerException());
      });

      body();
    });
  }

  void _whenRemoteRequestForTopRatedMoviesIsSuccessful(Function body) {
    group('when remote request for top rated movies is successful', () {
      setUp(() {
        when(_mockRemoteDataSource.getTopRatedMovies(any)).thenAnswer((_) async => testMovieModels);
      });

      body();
    });
  }

  void _whenRemoteRequestForTopRatedMoviesIsUnsuccessful(Function body) {
    group('when remote request for top rated movies is unsuccessful', () {
      setUp(() {
        when(_mockRemoteDataSource.getTopRatedMovies(any)).thenThrow(ServerException());
      });

      body();
    });
  }

  void _whenRemoteRequestForGenresIsSuccessful(Function body) {
    group('when remote request for genres is successful', () {
      setUp(() {
        when(_mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);
      });

      body();
    });
  }

  void _whenRemoteRequestForGenresIsUnsuccessful(Function body) {
    group('when remote request for genres is unsuccessful', () {
      setUp(() {
        when(_mockRemoteDataSource.getMovieGenres()).thenThrow(ServerException());
      });

      body();
    });
  }

  group('getPopularMovies', () {
    _whenCachedDateDoesNotExist(() {
      _whenDeviceIsOnline(() {
        _whenRemoteRequestForPopularMoviesIsSuccessful(() {
          test('should store movies locally', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            verify(_mockLocalDataSource.storePopularMovies(testMovieModels));
          });

          test('should store the date', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            verify(_mockLocalDateSource.storeDate(any));
          });
        });

        _whenRemoteRequestForPopularMoviesIsUnsuccessful(() {
          test('should return server failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            expect(result, equals(Left(ServerFailure())));
          });
        });
      });

      _whenDeviceIsOffline(() {
        test('should return network failure', () async {
          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    _whenCachedDateIsOlderThanADay(() {
      _whenDeviceIsOnline(() {
        _whenRemoteRequestForPopularMoviesIsSuccessful(() {
          test('should store movies locally', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            verify(_mockLocalDataSource.storePopularMovies(testMovieModels));
          });

          test('should store the date', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            verify(_mockLocalDateSource.storeDate(any));
          });
        });

        _whenRemoteRequestForPopularMoviesIsUnsuccessful(() {
          test('should return server failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getPopularMovies(testPage);

            verify(_mockRemoteDataSource.getPopularMovies(testPage));
            expect(result, equals(Left(ServerFailure())));
          });
        });
      });

      _whenDeviceIsOffline(() {
        test('should return network failure', () async {
          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    _whenCachedDateIsLessThanADayOld(() {
      _whenPopularMovieCacheIsNotEmpty(() {
        test('should return cached movies', () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);
          when(_mockMovieMapper.map(any, any)).thenReturn(testMovies);

          final Either<Failure, List<Movie>> result = await _repository.getPopularMovies(testPage);

          verifyZeroInteractions(_mockNetwork);
          verifyZeroInteractions(_mockRemoteDataSource);
          expect(result, equals(Right(testMovies)));
        });
      });

      _whenPopularMovieCacheIsEmpty(() {
        _whenDeviceIsOnline(() {
          _whenRemoteRequestForPopularMoviesIsSuccessful(() {
            test('should store movies locally', () async {
              when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

              await _repository.getPopularMovies(testPage);

              verify(_mockRemoteDataSource.getPopularMovies(testPage));
              verify(_mockLocalDataSource.storePopularMovies(testMovieModels));
            });

            test('should store the date', () async {
              when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

              await _repository.getPopularMovies(testPage);

              verify(_mockRemoteDataSource.getPopularMovies(testPage));
              verify(_mockLocalDateSource.storeDate(any));
            });
          });

          _whenRemoteRequestForPopularMoviesIsUnsuccessful(() {
            test('should return server failure', () async {
              final Either<Failure, List<Movie>> result =
                  await _repository.getPopularMovies(testPage);

              verify(_mockRemoteDataSource.getPopularMovies(testPage));
              expect(result, equals(Left(ServerFailure())));
            });
          });
        });

        _whenDeviceIsOffline(() {
          test('should return network failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getPopularMovies(testPage);

            expect(result, equals(Left(NetworkFailure())));
          });
        });
      });
    });

    _whenCachedDateIsLessThanADayOld(() {
      _whenPopularMovieCacheIsNotEmpty(() {
        _whenGenreCacheIsEmpty(() {
          _whenDeviceIsOnline(() {
            test('should request genres from remote data source', () async {
              when(_mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);

              await _repository.getPopularMovies(testPage);

              verify(_mockRemoteDataSource.getMovieGenres());
            });

            _whenRemoteRequestForGenresIsSuccessful(() {
              test('should store genres locally', () async {
                await _repository.getPopularMovies(testPage);

                verify(_mockRemoteDataSource.getMovieGenres());
                verify(_mockLocalDataSource.storeGenres(testGenreModels));
              });
            });

            _whenRemoteRequestForGenresIsUnsuccessful(() {
              test('should return server failure', () async {
                final Either<Failure, List<Movie>> result =
                    await _repository.getPopularMovies(testPage);

                verify(_mockRemoteDataSource.getMovieGenres());
                expect(result, equals(Left(ServerFailure())));
              });
            });
          });

          _whenDeviceIsOffline(() {
            test('should return network failure', () async {
              final Either<Failure, List<Movie>> result =
                  await _repository.getPopularMovies(testPage);

              expect(result, equals(Left(NetworkFailure())));
            });
          });
        });
      });
    });
  });

  group('getTopRatedMovies', () {
    _whenCachedDateDoesNotExist(() {
      _whenDeviceIsOnline(() {
        _whenRemoteRequestForTopRatedMoviesIsSuccessful(() {
          test('should store movies locally', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            verify(_mockLocalDataSource.storeTopRatedMovies(testMovieModels));
          });

          test('should store the date', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            verify(_mockLocalDateSource.storeDate(any));
          });
        });

        _whenRemoteRequestForTopRatedMoviesIsUnsuccessful(() {
          test('should return server failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            expect(result, equals(Left(ServerFailure())));
          });
        });
      });

      _whenDeviceIsOffline(() {
        test('should return network failure', () async {
          final Either<Failure, List<Movie>> result = await _repository.getTopRatedMovies(testPage);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    _whenCachedDateIsOlderThanADay(() {
      _whenDeviceIsOnline(() {
        _whenRemoteRequestForTopRatedMoviesIsSuccessful(() {
          test('should store movies locally', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            verify(_mockLocalDataSource.storeTopRatedMovies(testMovieModels));
          });

          test('should store the date', () async {
            when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

            await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            verify(_mockLocalDateSource.storeDate(any));
          });
        });

        _whenRemoteRequestForTopRatedMoviesIsUnsuccessful(() {
          test('should return server failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getTopRatedMovies(testPage);

            verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
            expect(result, equals(Left(ServerFailure())));
          });
        });
      });

      _whenDeviceIsOffline(() {
        test('should return network failure', () async {
          final Either<Failure, List<Movie>> result = await _repository.getTopRatedMovies(testPage);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    _whenCachedDateIsLessThanADayOld(() {
      _whenTopRatedMovieCacheIsNotEmpty(() {
        test('should return cached movies', () async {
          when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);
          when(_mockMovieMapper.map(any, any)).thenReturn(testMovies);

          final Either<Failure, List<Movie>> result = await _repository.getTopRatedMovies(testPage);

          verifyZeroInteractions(_mockNetwork);
          verifyZeroInteractions(_mockRemoteDataSource);
          expect(result, equals(Right(testMovies)));
        });
      });

      _whenTopRatedMovieCacheIsEmpty(() {
        _whenDeviceIsOnline(() {
          _whenRemoteRequestForTopRatedMoviesIsSuccessful(() {
            test('should store movies locally', () async {
              when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

              await _repository.getTopRatedMovies(testPage);

              verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
              verify(_mockLocalDataSource.storeTopRatedMovies(testMovieModels));
            });

            test('should store the date', () async {
              when(_mockLocalDataSource.getGenres(any)).thenAnswer((_) async => testGenreModels);

              await _repository.getTopRatedMovies(testPage);

              verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
              verify(_mockLocalDateSource.storeDate(any));
            });
          });

          _whenRemoteRequestForTopRatedMoviesIsUnsuccessful(() {
            test('should return server failure', () async {
              final Either<Failure, List<Movie>> result =
                  await _repository.getTopRatedMovies(testPage);

              verify(_mockRemoteDataSource.getTopRatedMovies(testPage));
              expect(result, equals(Left(ServerFailure())));
            });
          });
        });

        _whenDeviceIsOffline(() {
          test('should return network failure', () async {
            final Either<Failure, List<Movie>> result =
                await _repository.getTopRatedMovies(testPage);

            expect(result, equals(Left(NetworkFailure())));
          });
        });
      });
    });

    _whenCachedDateIsLessThanADayOld(() {
      _whenTopRatedMovieCacheIsNotEmpty(() {
        _whenGenreCacheIsEmpty(() {
          _whenDeviceIsOnline(() {
            test('should request genres from remote data source', () async {
              when(_mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => testGenreModels);

              await _repository.getTopRatedMovies(testPage);

              verify(_mockRemoteDataSource.getMovieGenres());
            });

            _whenRemoteRequestForGenresIsSuccessful(() {
              test('should store genres locally', () async {
                await _repository.getTopRatedMovies(testPage);

                verify(_mockRemoteDataSource.getMovieGenres());
                verify(_mockLocalDataSource.storeGenres(testGenreModels));
              });
            });

            _whenRemoteRequestForGenresIsUnsuccessful(() {
              test('should return server failure', () async {
                final Either<Failure, List<Movie>> result =
                    await _repository.getTopRatedMovies(testPage);

                verify(_mockRemoteDataSource.getMovieGenres());
                expect(result, equals(Left(ServerFailure())));
              });
            });
          });

          _whenDeviceIsOffline(() {
            test('should return network failure', () async {
              final Either<Failure, List<Movie>> result =
                  await _repository.getTopRatedMovies(testPage);

              expect(result, equals(Left(NetworkFailure())));
            });
          });
        });
      });
    });
  });
}
