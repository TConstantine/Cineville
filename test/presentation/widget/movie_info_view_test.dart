import 'dart:io';

import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/widget/movie_backdrop_view.dart';
import 'package:cineville/presentation/widget/movie_genres_view.dart';
import 'package:cineville/presentation/widget/movie_info_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    mockRepository = MockRepository();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMovieInfoView(WidgetTester tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: MovieInfoView(movie: testMovie),
      ));
    });
  }

  testWidgets('should display backdrop', (tester) async {
    await _pumpMovieInfoView(tester);

    expect(find.byType(MovieBackdropView), findsOneWidget);
  });

  testWidgets('should display poster', (tester) async {
    await _pumpMovieInfoView(tester);

    expect(find.byType(MoviePosterView), findsOneWidget);
  });

  testWidgets('should display title', (tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await _pumpMovieInfoView(tester);

    expect(find.text('${testMovie.title} ${testMovie.releaseYear}'), findsOneWidget);
  });

  testWidgets('should display genres', (tester) async {
    await _pumpMovieInfoView(tester);

    expect(find.byType(MovieGenresView), findsOneWidget);
  });

  testWidgets('should display plot synopsis', (tester) async {
    final Movie testMovie = TestMovieBuilder().build();
    await _pumpMovieInfoView(tester);

    expect(find.text(testMovie.plotSynopsis), findsOneWidget);
  });
}
