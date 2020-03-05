import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_actors_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/actor_domain_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';

class MockUseCase extends Mock implements UseCaseWithParams<List<Actor>, int> {}

void main() {
  DomainEntityBuilder actorDomainEntityBuilder;
  UseCaseWithParams<List<Actor>, int> mockUseCase;
  Bloc actorsBloc;

  setUp(() {
    actorDomainEntityBuilder = ActorDomainEntityBuilder();
    mockUseCase = MockUseCase();
    actorsBloc = ActorsBloc(mockUseCase);
  });

  final int testMovieId = 100;

  test('initial state should be Empty', () {
    expect(actorsBloc.initialState, equals(EmptyState()));
  });

  group('when data is loaded successfully', () {
    setUp(() {
      final List<Actor> testActors = actorDomainEntityBuilder.buildList();
      when(mockUseCase.execute(any)).thenAnswer((_) async => Right(testActors));
    });

    test('should get data from the get movie actors use case', () async {
      actorsBloc.dispatch(LoadMovieActorsEvent(testMovieId));
      await untilCalled(mockUseCase.execute(any));

      verify(mockUseCase.execute(testMovieId));
    });

    test('should emit [Loading, Loaded] states', () async {
      final List<Actor> testActors = actorDomainEntityBuilder.buildList();
      final List<BlocState> emittedStates = [
        EmptyState(),
        LoadingState(),
        LoadedState<List<Actor>>(testActors),
      ];
      expectLater(actorsBloc.state, emitsInOrder(emittedStates));

      actorsBloc.dispatch(LoadMovieActorsEvent(testMovieId));
    });
  });

  test('should emit [Loading, Error] states when server is not responsive', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(ServerFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.SERVER_FAILURE_MESSAGE),
    ];
    expectLater(actorsBloc.state, emitsInOrder(emittedStates));

    actorsBloc.dispatch(LoadMovieActorsEvent(testMovieId));
  });

  test('should emit [Loading, Error] states when there is no internet connection', () async {
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NetworkFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    expectLater(actorsBloc.state, emitsInOrder(emittedStates));

    actorsBloc.dispatch(LoadMovieActorsEvent(testMovieId));
  });

  test('should emit [Loading, Error] states when there is no data to display', () async {
    final int testMovieId = 1;
    when(mockUseCase.execute(any)).thenAnswer((_) async => Left(NoDataFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_ACTORS),
    ];
    expectLater(actorsBloc.state, emitsInOrder(emittedStates));

    actorsBloc.dispatch(LoadMovieActorsEvent(testMovieId));
  });
}
