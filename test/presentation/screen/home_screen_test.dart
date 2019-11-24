import 'dart:io';

import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/screen/home_screen.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util/test_http_overrides.dart';
import '../../test_util/test_movie_builder.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  final MovieRepository mockMovieRepository = MockMovieRepository();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDown(() {
    injector.reset();
  });

  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();

  Future _pumpHomeScreen(WidgetTester tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    when(mockMovieRepository.getUpcomingMovies(any)).thenAnswer((_) async => Right(testMovies));
    when(mockMovieRepository.getTopRatedMovies(any)).thenAnswer((_) async => Right(testMovies));
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockMovieRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('should have a drawer', (tester) async {
    await _pumpHomeScreen(tester);

    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
  });

  testWidgets('should display popular movies', (tester) async {
    await _pumpHomeScreen(tester);

    expect(
        find.byWidgetPredicate((widget) =>
            widget is MoviesView &&
            widget.title == TranslatableStrings.MOST_POPULAR_MOVIES_CATEGORY),
        findsOneWidget);
  });

  testWidgets('should display upcoming movies', (tester) async {
    await _pumpHomeScreen(tester);

    expect(
        find.byWidgetPredicate((widget) =>
            widget is MoviesView && widget.title == TranslatableStrings.UPCOMING_MOVIES_CATEGORY),
        findsOneWidget);
  });

  testWidgets('should display top rated movies', (tester) async {
    await _pumpHomeScreen(tester);

    expect(
        find.byWidgetPredicate((widget) =>
            widget is MoviesView && widget.title == TranslatableStrings.TOP_RATED_MOVIES_CATEGORY),
        findsOneWidget);
  });
}
