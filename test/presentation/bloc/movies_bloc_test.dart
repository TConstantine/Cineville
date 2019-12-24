import 'package:bloc/bloc.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_similar_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_top_rated_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_upcoming_movies_event.dart';
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

class MockUseCase extends Mock implements UseCase<Movie> {}

void main() {
  UseCase<Movie> mockUseCase;
  Bloc bloc;

  setUp(() {
    mockUseCase = MockUseCase();
    bloc = MoviesBloc(mockUseCase, mockUseCase, mockUseCase, mockUseCase);
  });

  final int testPage = 1;
  final int testMovieId = 100;
  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();

  test('initial state should be Empty', () {
    expect(bloc.initialState, equals(EmptyState()));
  });

  group('when data is loaded successfully', () {
    setUp(() {
      when(mockUseCase.execute(any)).thenAnswer((_) async => Right(testMovies));
    });

    test('should get data from the get popular movies use case', () async {
      bloc.dispatch(LoadPopularMoviesEvent(testPage));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testPage));
    });

    test('should get data from the get upcoming movies use case', () async {
      bloc.dispatch(LoadUpcomingMoviesEvent(testPage));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testPage));
    });

    test('should get data from the get top rated movies use case', () async {
      bloc.dispatch(LoadTopRatedMoviesEvent(testPage));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testPage));
    });

    test('should get data from the get similar movies use case', () async {
      bloc.dispatch(LoadSimilarMoviesEvent(testMovieId));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testMovieId));
    });

    test('should emit [Loading, Loaded] states', () async {
      final List<BlocState> emittedStates = [
        EmptyState(),
        LoadingState(),
        LoadedState<Movie>(testMovies),
      ];
      expectLater(bloc.state, emitsInOrder(emittedStates));

      bloc.dispatch(LoadPopularMoviesEvent(testPage));
    });
  });

  test('should emit [Loading, Error] states when server is not responsive', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(ServerFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.SERVER_FAILURE_MESSAGE),
    ];
    expectLater(bloc.state, emitsInOrder(emittedStates));

    bloc.dispatch(LoadPopularMoviesEvent(testPage));
  });

  test('should emit [Loading, Error] states when there is no internet connection', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NetworkFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    expectLater(bloc.state, emitsInOrder(emittedStates));

    bloc.dispatch(LoadPopularMoviesEvent(testPage));
  });

  test('should emit [Loading, Error] states when there are no similar movies to display', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NoDataFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_DATA_FAILURE_MESSAGE),
    ];
    expectLater(bloc.state, emitsInOrder(emittedStates));

    bloc.dispatch(LoadSimilarMoviesEvent(testMovieId));
  });
}
