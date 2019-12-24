import 'dart:io';

import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_top_rated_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_upcoming_movies_event.dart';
import 'package:cineville/presentation/screen/movies_screen.dart';
import 'package:cineville/presentation/screen/tv_shows_screen.dart';
import 'package:cineville/presentation/widget/attributions_view.dart';
import 'package:cineville/presentation/widget/categories_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/routes.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util/test_http_overrides.dart';
import '../../test_util/test_movie_builder.dart';

class MockRepository extends Mock implements MovieRepository {}

void main() {
  MovieRepository mockRepository;

  setUpAll(() async {
    final Directory directory = await Directory.systemTemp.createTemp();
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return directory.path;
      }
      return null;
    });
    const MethodChannel('com.tekartik.sqflite')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getDatabasesPath') {
        return directory.path;
      }
      return null;
    });
  });

  setUp(() {
    final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
    mockRepository = MockRepository();
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = TestHttpOverrides();
    when(mockRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    when(mockRepository.getUpcomingMovies(any)).thenAnswer((_) async => Right(testMovies));
    when(mockRepository.getTopRatedMovies(any)).thenAnswer((_) async => Right(testMovies));
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMoviesScreen(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockRepository).inject();
      await tester.pumpWidget(MaterialApp(
        initialRoute: Routes.MOVIES,
        routes: {
          Routes.MOVIES: (_) => MoviesScreen(),
          Routes.TV_SHOWS: (_) => TvShowsScreen(),
        },
      ));
      await tester.pumpAndSettle();
    });
  }

  Future _openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
  }

  testWidgets('should have a drawer', (tester) async {
    await _pumpMoviesScreen(tester);

    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
  });

  testWidgets('should display movies when movies option is clicked', (tester) async {
    await _pumpMoviesScreen(tester);
    await _openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.MOVIES).evaluate().first.widget;
    listTile.onTap();
    await tester.pumpAndSettle();

    expect(find.byType(MoviesScreen), findsOneWidget);
  });

  testWidgets('should display tv shows when tv shows option is clicked', (tester) async {
    await _pumpMoviesScreen(tester);
    await _openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.TV_SHOWS).evaluate().first.widget;
    listTile.onTap();
    await tester.pumpAndSettle();

    expect(find.byType(TvShowsScreen), findsOneWidget);
  });

  testWidgets('should display attributions when attributions option is clicked', (tester) async {
    await _pumpMoviesScreen(tester);
    await _openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.ATTRIBUTIONS).evaluate().first.widget;
    listTile.onTap();
    await tester.pump();

    expect(find.byType(AttributionsView), findsOneWidget);
  });

  testWidgets('should close attributions when close button is clicked', (tester) async {
    await _pumpMoviesScreen(tester);
    await _openDrawer(tester);

    final ListTile listTile =
        find.widgetWithText(ListTile, TranslatableStrings.ATTRIBUTIONS).evaluate().first.widget;
    listTile.onTap();
    await tester.pump();

    await tester.tap(find.text(TranslatableStrings.CLOSE));
    await tester.pump();

    expect(find.byType(AttributionsView), findsNothing);
  });

  testWidgets('should display categories navigation bar', (tester) async {
    await _pumpMoviesScreen(tester);

    expect(find.byType(CategoriesNavigationBarView), findsOneWidget);
  });

  testWidgets('should display popular movies by default', (tester) async {
    await _pumpMoviesScreen(tester);

    expect(
        find.byWidgetPredicate(
            (widget) => widget is MoviesView && widget.event.runtimeType == LoadPopularMoviesEvent),
        findsOneWidget);
  });

  testWidgets('should display upcoming movies when upcoming category is selected', (tester) async {
    await _pumpMoviesScreen(tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_UPCOMING));
    await tester.pump();

    expect(
        find.byWidgetPredicate((widget) =>
            widget is MoviesView && widget.event.runtimeType == LoadUpcomingMoviesEvent),
        findsOneWidget);
  });

  testWidgets('should display top rated movies when top rated category is selected',
      (tester) async {
    await _pumpMoviesScreen(tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_TOP_RATED));
    await tester.pump();

    expect(
        find.byWidgetPredicate((widget) =>
            widget is MoviesView && widget.event.runtimeType == LoadTopRatedMoviesEvent),
        findsOneWidget);
  });
}
