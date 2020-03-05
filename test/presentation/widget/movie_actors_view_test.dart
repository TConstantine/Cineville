import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_actor_view.dart';
import 'package:cineville/presentation/widget/movie_actors_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/actor_domain_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

class MockActorsBloc extends Mock implements ActorsBloc {}

void main() {
  DomainEntityBuilder actorDomainEntityBuilder;
  ActorsBloc mockActorsBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    actorDomainEntityBuilder = ActorDomainEntityBuilder();
    mockActorsBloc = MockActorsBloc();
    dependencyInjector = Injector().withActorsBloc(mockActorsBloc);
    final int testMovieId = 100;
    widget = MaterialApp(
      home: BlocProvider(
        builder: (_) => injector<ActorsBloc>(),
        child: MovieActorsView(movieId: testMovieId),
      ),
    );
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display movie actors when actors load successfully', (tester) async {
    final List<Actor> testActors = actorDomainEntityBuilder.buildList();
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      LoadedState<List<Actor>>(testActors),
    ];
    when(mockActorsBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byType(MovieActorView, skipOffstage: false), findsNWidgets(testActors.length));
  });

  testWidgets('should display an error message when actors fail to load', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    when(mockActorsBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });
}
