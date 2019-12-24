import 'dart:io';

import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  setUp(() async {
    mockRepository = MockRepository();
    SharedPreferences.setMockInitialValues({});
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMoviesView(WidgetTester tester) async {
    final BlocEvent testEvent = LoadPopularMoviesEvent(1);
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          builder: (_) => injector<MoviesBloc>(),
          child: MoviesView(
            event: testEvent,
          ),
        ),
      ));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('should display a list of movies', (tester) async {
    final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
    when(mockRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    await _pumpMoviesView(tester);

    expect(find.byType(MovieSummaryView, skipOffstage: false), findsNWidgets(testMovies.length));
  });

  testWidgets('should display an error message when movies fail to load', (tester) async {
    when(mockRepository.getPopularMovies(any)).thenAnswer((_) async => Left(NetworkFailure()));
    await _pumpMoviesView(tester);

    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });
}
