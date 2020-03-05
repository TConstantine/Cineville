import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  MoviesBloc mockMoviesBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() async {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockMoviesBloc = MockMoviesBloc();
    dependencyInjector = Injector().withMoviesBloc(mockMoviesBloc);
    final BlocEvent testEvent = LoadPopularMoviesEvent(1);
    widget = MaterialApp(
      home: BlocProvider(
        builder: (_) => injector<MoviesBloc>(),
        child: MoviesView(
          event: testEvent,
        ),
      ),
    );
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display a list of movies', (tester) async {
    final List<Movie> testMovies = movieDomainEntityBuilder.buildList();
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      LoadedState<List<Movie>>(testMovies),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byType(MovieSummaryView, skipOffstage: false), findsNWidgets(testMovies.length));
  });

  testWidgets('should display an error message when movies fail to load', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });
}
