import 'package:bloc/bloc.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_state.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_movie_builder.dart';

class MockGetMoviesUseCase extends Mock implements UseCase {}

void main() {
  UseCase _mockGetMoviesUseCase;
  Bloc _bloc;

  setUp(() {
    _mockGetMoviesUseCase = MockGetMoviesUseCase();
    _bloc = MoviesBloc(_mockGetMoviesUseCase);
  });

  test('initial state should be Empty', () {
    expect(_bloc.initialState, equals(EmptyState()));
  });

  group('GetPopularMovies', () {
    final int testPage = 1;
    final List<Movie> testMovies = TestMovieBuilder().buildMultiple();

    group('when data is loaded successfully', () {
      setUp(() {
        when(_mockGetMoviesUseCase.execute(any)).thenAnswer((_) async => Right(testMovies));
      });

      test('should get data from the get popular movies use case', () async {
        _bloc.dispatch(LoadMoviesEvent(testPage));
        await untilCalled(_mockGetMoviesUseCase.execute(any));

        verify(_mockGetMoviesUseCase.execute(testPage));
      });

      test('should emit [Loading, Loaded] states', () async {
        final List<MoviesState> emittedStates = [
          EmptyState(),
          LoadingState(),
          LoadedState(testMovies),
        ];
        expectLater(_bloc.state, emitsInOrder(emittedStates));

        _bloc.dispatch(LoadMoviesEvent(testPage));
      });
    });

    test('should emit [Loading, Error] states when server is not responsive', () async {
      when(_mockGetMoviesUseCase.execute(any)).thenAnswer((_) async => Left(ServerFailure()));

      final List<MoviesState> emittedStates = [
        EmptyState(),
        LoadingState(),
        ErrorState(TranslatableStrings.SERVER_FAILURE_MESSAGE),
      ];
      expectLater(_bloc.state, emitsInOrder(emittedStates));

      _bloc.dispatch(LoadMoviesEvent(testPage));
    });

    test('should emit [Loading, Error] states when there is no internet connection', () async {
      when(_mockGetMoviesUseCase.execute(any)).thenAnswer((_) async => Left(NetworkFailure()));

      final List<MoviesState> emittedStates = [
        EmptyState(),
        LoadingState(),
        ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
      ];
      expectLater(_bloc.state, emitsInOrder(emittedStates));

      _bloc.dispatch(LoadMoviesEvent(testPage));
    });
  });
}
