import 'package:bloc/bloc.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_reviews_event.dart';
import 'package:cineville/presentation/bloc/reviews_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_review_builder.dart';

class MockUseCase extends Mock implements UseCase<Review> {}

void main() {
  UseCase<Review> mockUseCase;
  Bloc bloc;

  setUpAll(() {
    mockUseCase = MockUseCase();
  });

  setUp(() {
    bloc = ReviewsBloc(mockUseCase);
  });

  final int testMovieId = 100;
  final List<Review> testReviews = TestReviewBuilder().buildMultiple();

  test('initial state should be Empty', () {
    expect(bloc.initialState, equals(EmptyState()));
  });

  group('when data is loaded successfully', () {
    setUp(() {
      when(mockUseCase.execute(any)).thenAnswer((_) async => Right(testReviews));
    });

    test('should get data from the get movie reviews use case', () async {
      bloc.dispatch(LoadMovieReviewsEvent(testMovieId));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testMovieId));
    });

    test('should emit [Loading, Loaded] states', () async {
      final List<BlocState> emittedStates = [
        EmptyState(),
        LoadingState(),
        LoadedState<Review>(testReviews),
      ];
      expectLater(bloc.state, emitsInOrder(emittedStates));

      bloc.dispatch(LoadMovieReviewsEvent(testMovieId));
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

    bloc.dispatch(LoadMovieReviewsEvent(testMovieId));
  });

  test('should emit [Loading, Error] states when there is no internet connection', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NetworkFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    expectLater(bloc.state, emitsInOrder(emittedStates));

    bloc.dispatch(LoadMovieReviewsEvent(testMovieId));
  });

  test('should emit [Loading, Error] states when there is no data to display', () async {
    final int testMovieId = 1;
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NoDataFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_REVIEWS),
    ];
    expectLater(bloc.state, emitsInOrder(emittedStates));

    bloc.dispatch(LoadMovieReviewsEvent(testMovieId));
  });
}
