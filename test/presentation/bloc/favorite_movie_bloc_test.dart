import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/unexpected_failure.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/add_movie_to_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/event/is_favorite_movie_event.dart';
import 'package:cineville/presentation/bloc/event/remove_movie_from_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/favorite_movie_bloc.dart';
import 'package:cineville/presentation/bloc/state/added_state.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/removed_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockIsFavoriteMovieUseCase extends Mock implements UseCaseWithParams<bool, int> {}

class MockAddMovieToFavoriteListUseCase extends Mock implements UseCaseWithParams<void, int> {}

class MockRemoveMovieFromFavoriteListUseCase extends Mock implements UseCaseWithParams<int, int> {}

void main() {
  UseCaseWithParams<bool, int> mockIsFavoriteMovieUseCase;
  UseCaseWithParams<void, int> mockAddMovieToFavoriteListUseCase;
  UseCaseWithParams<int, int> mockRemoveMovieFromFavoriteListUseCase;
  Bloc favoriteMovieBloc;

  setUp(() {
    mockIsFavoriteMovieUseCase = MockIsFavoriteMovieUseCase();
    mockAddMovieToFavoriteListUseCase = MockAddMovieToFavoriteListUseCase();
    mockRemoveMovieFromFavoriteListUseCase = MockRemoveMovieFromFavoriteListUseCase();
    favoriteMovieBloc = FavoriteMovieBloc(
      mockIsFavoriteMovieUseCase,
      mockAddMovieToFavoriteListUseCase,
      mockRemoveMovieFromFavoriteListUseCase,
    );
  });

  test('should emit EmptyState when returning initial state', () {
    expect(favoriteMovieBloc.initialState, equals(EmptyState()));
  });

  test(
      'should emit [EmptyState, LoadedState] when an IsFavoriteMovieEvent is triggered and completed successfully',
      () async {
    final int testMovieId = 1;
    final bool testIsFavorite = true;
    when(mockIsFavoriteMovieUseCase.execute(any)).thenAnswer((_) async => Right(testIsFavorite));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadedState<bool>(testIsFavorite),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(IsFavoriteMovieEvent(testMovieId));
  });

  test(
      'should emit [EmptyState, ErrorState] when an IsFavoriteMovieEvent is triggered and completed unsuccessfully',
      () async {
    final int testMovieId = 1;
    when(mockIsFavoriteMovieUseCase.execute(any))
        .thenAnswer((_) async => Left(UnexpectedFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(IsFavoriteMovieEvent(testMovieId));
  });

  test(
      'should emit [EmptyState, AddedState] when an AddMovieToFavoriteListEvent is triggered and completed successfully',
      () async {
    final int testMovieId = 1;
    when(mockAddMovieToFavoriteListUseCase.execute(any)).thenAnswer((_) async => Right(null));

    final List<BlocState> emittedStates = [
      EmptyState(),
      AddedState(TranslatableStrings.ADDED_TO_FAVORITES),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(AddMovieToFavoriteListEvent(testMovieId));
  });

  test(
      'should emit [EmptyState, ErrorState] when an AddMovieToFavoriteListEvent is triggered and completed unsuccessfully',
      () async {
    final int testMovieId = 1;
    when(mockAddMovieToFavoriteListUseCase.execute(any))
        .thenAnswer((_) async => Left(UnexpectedFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(AddMovieToFavoriteListEvent(testMovieId));
  });

  test(
      'should emit [EmptyState, RemovedState] when a RemoveMovieFromFavoriteListEvent is triggered and completed successfully',
      () async {
    final int testMovieId = 1;
    when(mockRemoveMovieFromFavoriteListUseCase.execute(any)).thenAnswer((_) async => Right(null));

    final List<BlocState> emittedStates = [
      EmptyState(),
      RemovedState(TranslatableStrings.REMOVED_FROM_FAVORITES),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(RemoveMovieFromFavoriteListEvent(testMovieId));
  });

  test(
      'should emit [EmptyState, ErrorState] when a RemoveMovieFromFavoriteListEvent is triggered and completed unsuccessfully',
      () async {
    final int testMovieId = 1;
    when(mockRemoveMovieFromFavoriteListUseCase.execute(any))
        .thenAnswer((_) async => Left(UnexpectedFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
    ];
    expectLater(favoriteMovieBloc.state, emitsInOrder(emittedStates));

    favoriteMovieBloc.dispatch(RemoveMovieFromFavoriteListEvent(testMovieId));
  });
}
