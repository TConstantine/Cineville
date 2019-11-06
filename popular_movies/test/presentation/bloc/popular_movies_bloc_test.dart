import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/data/error/failure/cache_failure.dart';
import 'package:popular_movies/data/error/failure/network_failure.dart';
import 'package:popular_movies/data/error/failure/server_failure.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/usecase/get_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/event/load_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_bloc.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_state.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/empty.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/error.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loaded.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loading.dart';

import '../../builder/movie_builder.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  GetPopularMovies _mockGetPopularMovies;
  Bloc _bloc;

  setUp(() {
    _mockGetPopularMovies = MockGetPopularMovies();
    _bloc = PopularMoviesBloc(_mockGetPopularMovies);
  });

  test('initial state should be Empty', () {
    expect(_bloc.initialState, equals(Empty()));
  });

  group('GetPopularMovies', () {
    final int testPage = 1;
    final List<Movie> testMovies = [
      MovieBuilder().build(),
      MovieBuilder().build(),
      MovieBuilder().build(),
    ];

    group('when data is loaded successfully', () {
      setUp(() {
        when(_mockGetPopularMovies.execute(any)).thenAnswer((_) async => Right(testMovies));
      });

      test('should get data from the get popular movies use case', () async {
        _bloc.dispatch(LoadPopularMovies(testPage));
        await untilCalled(_mockGetPopularMovies.execute(any));

        verify(_mockGetPopularMovies.execute(testPage));
      });

      test('should emit [Loading, Loaded] states', () async {
        final List<PopularMoviesState> emittedStates = [
          Empty(),
          Loading(),
          Loaded(testMovies),
        ];
        expectLater(_bloc.state, emitsInOrder(emittedStates));

        _bloc.dispatch(LoadPopularMovies(testPage));
      });
    });

    test('should emit [Loading, Error] states when server is not responsive', () async {
      when(_mockGetPopularMovies.execute(any)).thenAnswer((_) async => Left(ServerFailure()));

      final List<PopularMoviesState> emittedStates = [
        Empty(),
        Loading(),
        Error(Error.SERVER_FAILURE_MESSAGE),
      ];
      expectLater(_bloc.state, emitsInOrder(emittedStates));

      _bloc.dispatch(LoadPopularMovies(testPage));
    });

    test('should emit [Loading, Error] states when there is no internet connection', () async {
      when(_mockGetPopularMovies.execute(any)).thenAnswer((_) async => Left(NetworkFailure()));

      final List<PopularMoviesState> emittedStates = [
        Empty(),
        Loading(),
        Error(Error.NETWORK_FAILURE_MESSAGE),
      ];
      expectLater(_bloc.state, emitsInOrder(emittedStates));

      _bloc.dispatch(LoadPopularMovies(testPage));
    });

    test('should emit [Loading, Error] states when there is a cache problem', () async {
      when(_mockGetPopularMovies.execute(any)).thenAnswer((_) async => Left(CacheFailure()));

      final List<PopularMoviesState> emittedStates = [
        Empty(),
        Loading(),
        Error(Error.CACHE_FAILURE_MESSAGE),
      ];
      expectLater(_bloc.state, emitsInOrder(emittedStates));

      _bloc.dispatch(LoadPopularMovies(testPage));
    });
  });
}
