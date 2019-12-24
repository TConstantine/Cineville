import 'dart:io';

import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/presentation/screen/movie_details_screen.dart';
import 'package:cineville/presentation/widget/movie_actors_view.dart';
import 'package:cineville/presentation/widget/movie_details_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/movie_info_view.dart';
import 'package:cineville/presentation/widget/movie_reviews_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util/test_actor_builder.dart';
import '../../test_util/test_movie_builder.dart';

class MockRepository extends Mock implements ActorRepository {}

void main() {
  ActorRepository mockRepository;

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
    mockRepository = MockRepository();
    SharedPreferences.setMockInitialValues({});
    when(mockRepository.getMovieActors(any)).thenAnswer((_) async => Right(testActors));
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMovieDetailsScreen(WidgetTester tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await tester.runAsync(() async {
      await Injector().withActorRepository(mockRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: MovieDetailsScreen(
          movie: testMovie,
        ),
      ));
    });
  }

  testWidgets('should display movie details navigation bar', (tester) async {
    await _pumpMovieDetailsScreen(tester);

    expect(find.byType(MovieDetailsNavigationBarView), findsOneWidget);
  });

  testWidgets('should display movie info by default', (tester) async {
    await _pumpMovieDetailsScreen(tester);

    expect(find.byType(MovieInfoView), findsOneWidget);
  });

  testWidgets('should display movie actors when actors category is selected', (tester) async {
    await _pumpMovieDetailsScreen(tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_ACTORS));
    await tester.pump();

    expect(find.byType(MovieActorsView), findsOneWidget);
  });

  testWidgets('should display movie reviews when reviews category is selected', (tester) async {
    await _pumpMovieDetailsScreen(tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_REVIEWS));
    await tester.pump();

    expect(find.byType(MovieReviewsView), findsOneWidget);
  });
}
