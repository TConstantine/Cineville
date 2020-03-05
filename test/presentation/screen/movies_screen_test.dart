import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_top_rated_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_upcoming_movies_event.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/screen/favorites_screen.dart';
import 'package:cineville/presentation/screen/movies_screen.dart';
import 'package:cineville/presentation/widget/attributions_view.dart';
import 'package:cineville/presentation/widget/categories_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/routes.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

class MockFavoriteListBloc extends Mock implements FavoriteListBloc {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  List<Movie> testPopularMovies;
  List<Movie> testFavoriteMovies;
  MoviesBloc mockMoviesBloc;
  FavoriteListBloc mockFavoriteListBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    testPopularMovies = movieDomainEntityBuilder.buildList();
    testFavoriteMovies = movieDomainEntityBuilder.buildList();
    mockMoviesBloc = MockMoviesBloc();
    mockFavoriteListBloc = MockFavoriteListBloc();
    dependencyInjector =
        Injector().withMoviesBloc(mockMoviesBloc).withFavoriteListBloc(mockFavoriteListBloc);
    widget = MoviesScreen();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display popular movies', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      LoadedState<List<Movie>>(testPopularMovies),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byType(MovieSummaryView), findsNWidgets(testFavoriteMovies.length));
  });

  testWidgets('should display error message when there is a network failure', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NETWORK_FAILURE_MESSAGE),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byIcon(Icons.signal_wifi_off), findsOneWidget);
    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });

  testWidgets('should display error message when there is a server failure', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.SERVER_FAILURE_MESSAGE),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    expect(find.text(TranslatableStrings.SERVER_FAILURE_MESSAGE), findsOneWidget);
  });

  testWidgets('should display error message when there are no movies to be displayed',
      (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_DATA_FAILURE_MESSAGE),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byIcon(Icons.local_movies), findsOneWidget);
    expect(find.text(TranslatableStrings.NO_MOVIES), findsOneWidget);
  });

  testWidgets('should display error message when there is an unexpected failure', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
    ];
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byIcon(Icons.error), findsOneWidget);
    expect(find.text(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE), findsOneWidget);
  });

  testWidgets('should have a drawer', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
  });

  testWidgets('should display favorites option when drawer is open', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await TestWidgetBuilder.openDrawer(tester);

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text(TranslatableStrings.FAVORITE), findsOneWidget);
  });

  testWidgets('should display favorites screen when favorites option is clicked in the drawer',
      (tester) async {
    final BlocState testState = LoadedState<List<Movie>>(testFavoriteMovies);
    when(mockMoviesBloc.state).thenAnswer((_) => Stream.fromIterable([testState]));
    await TestWidgetBuilder.runAsync(
      dependencyInjector,
      MaterialApp(
        initialRoute: Routes.MOVIES,
        routes: {
          Routes.MOVIES: (_) => MoviesScreen(),
          Routes.FAVORITES: (_) => FavoritesScreen(),
        },
      ),
      tester,
      wrap: false,
    );
    await TestWidgetBuilder.openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.FAVORITE).evaluate().first.widget;
    listTile.onTap();
    await tester.pumpAndSettle();

    expect(find.byType(FavoritesScreen), findsOneWidget);
  });

  testWidgets('should display movies when movies option is clicked', (tester) async {
    await TestWidgetBuilder.runAsync(
      dependencyInjector,
      MaterialApp(
        initialRoute: Routes.MOVIES,
        routes: {Routes.MOVIES: (_) => MoviesScreen()},
      ),
      tester,
    );
    await TestWidgetBuilder.openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.MOVIES).evaluate().first.widget;
    listTile.onTap();
    await tester.pumpAndSettle();

    expect(find.byType(MoviesScreen), findsOneWidget);
  });

  testWidgets('should display attributions when attributions option is clicked', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);
    await TestWidgetBuilder.openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.ATTRIBUTIONS).evaluate().first.widget;
    listTile.onTap();
    await tester.pump();

    expect(find.byType(AttributionsView), findsOneWidget);
  });

  testWidgets('should close attributions when close button is clicked', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);
    await TestWidgetBuilder.openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.ATTRIBUTIONS).evaluate().first.widget;
    listTile.onTap();
    await tester.pump();

    await tester.tap(find.text(TranslatableStrings.CLOSE));
    await tester.pump();

    expect(find.byType(AttributionsView), findsNothing);
  });

  testWidgets('should display categories navigation bar', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(CategoriesNavigationBarView), findsOneWidget);
  });

  testWidgets('should display popular movies by default', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(
      find.byWidgetPredicate(
          (widget) => widget is MoviesView && widget.event.runtimeType == LoadPopularMoviesEvent),
      findsOneWidget,
    );
  });

  testWidgets('should display upcoming movies when upcoming category is selected', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_UPCOMING));
    await tester.pump();

    expect(
      find.byWidgetPredicate(
          (widget) => widget is MoviesView && widget.event.runtimeType == LoadUpcomingMoviesEvent),
      findsOneWidget,
    );
  });

  testWidgets('should display top rated movies when top rated category is selected',
      (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_TOP_RATED));
    await tester.pump();

    expect(
      find.byWidgetPredicate(
          (widget) => widget is MoviesView && widget.event.runtimeType == LoadTopRatedMoviesEvent),
      findsOneWidget,
    );
  });
}
