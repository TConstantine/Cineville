import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/data/error/failure/network_failure.dart';
import 'package:popular_movies/di/injector.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/error.dart';
import 'package:popular_movies/presentation/screen/home_screen.dart';
import 'package:popular_movies/presentation/widget/popular_movie_preview.dart';
import 'package:popular_movies/presentation/widget/popular_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/movie_builder.dart';
import '../../network/test_http_overrides.dart';

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

  final List<Movie> testMovies = List.generate(3, (_) => MovieBuilder().build());

  Future _pumpHomeScreen(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockMovieRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('should display a list of popular movies', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    await _pumpHomeScreen(tester);

    expect(find.byType(PopularMovies), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PopularMovies),
        matching: find.byType(PopularMoviePreview, skipOffstage: false),
      ),
      findsNWidgets(testMovies.length),
    );
    expect(
      find.descendant(
        of: find.byType(PopularMoviePreview),
        matching: find.byType(FadeInImage),
      ),
      findsNWidgets(testMovies.length),
    );
  });

  testWidgets('should display an error message when popular movies could not be loaded',
      (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Left(NetworkFailure()));
    await _pumpHomeScreen(tester);

    expect(find.byType(PopularMovies), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PopularMovies),
        matching: find.byType(PopularMoviePreview, skipOffstage: false),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(PopularMovies),
        matching: find.text(Error.NETWORK_FAILURE_MESSAGE),
      ),
      findsOneWidget,
    );
  });
}
