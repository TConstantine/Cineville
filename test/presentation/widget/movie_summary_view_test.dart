import 'dart:io';

import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/screen/movie_details_screen.dart';
import 'package:cineville/presentation/widget/movie_genre_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/movie_rating_view.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/resources/widget_key.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util/test_actor_builder.dart';
import '../../test_util/test_http_overrides.dart';
import '../../test_util/test_movie_builder.dart';

class MockActorRepository extends Mock implements ActorRepository {}

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  ActorRepository mockActorRepository;
  MovieRepository mockMovieRepository;

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
    final List<Actor> testActors = TestActorBuilder().buildMultiple();
    final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
    mockActorRepository = MockActorRepository();
    mockMovieRepository = MockMovieRepository();
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = TestHttpOverrides();
    when(mockActorRepository.getMovieActors(any)).thenAnswer((_) async => Right(testActors));
    when(mockMovieRepository.getSimilarMovies(any)).thenAnswer((_) async => Right(testMovies));
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMovieSummaryView(WidgetTester tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await tester.runAsync(() async {
      await Injector()
          .withActorRepository(mockActorRepository)
          .withMovieRepository(mockMovieRepository)
          .inject();
      await tester.pumpWidget(MaterialApp(
        home: MovieSummaryView(
          movie: testMovie,
        ),
      ));
    });
  }

  testWidgets('should display movie poster', (tester) async {
    await _pumpMovieSummaryView(tester);

    expect(find.byType(MoviePosterView), findsOneWidget);
  });

  testWidgets('should display movie rating', (tester) async {
    await _pumpMovieSummaryView(tester);

    expect(find.byType(MovieRatingView), findsOneWidget);
  });

  testWidgets('should display movie title', (tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await _pumpMovieSummaryView(tester);

    expect(find.text('${testMovie.title} ${testMovie.releaseYear}'), findsOneWidget);
  });

  testWidgets('should display movie genres', (tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await _pumpMovieSummaryView(tester);

    expect(
      find.byType(MovieGenreView, skipOffstage: false),
      findsNWidgets(testMovie.genres.length),
    );
  });

  testWidgets('should display movie details when details button is clicked', (tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await _pumpMovieSummaryView(tester);

    await tester.tap(find.byKey(Key('${WidgetKey.DETAILS_BUTTON}_${testMovie.id}')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MovieDetailsScreen), findsOneWidget);
  });
}
