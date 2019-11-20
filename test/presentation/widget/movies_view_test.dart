import 'dart:io';

import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/widget/movie_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final String testTitle = 'Movies Category';

  Future _pumpMoviesView(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Injector().withMovieRepository(mockMovieRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          builder: (_) =>
              injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_POPULAR_MOVIES_USE_CASE_KEY)
                  as MoviesBloc,
          child: MoviesView(title: testTitle),
        ),
      ));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('should display the title of the movies category', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    await _pumpMoviesView(tester);

    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('should display a list of movies', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
    await _pumpMoviesView(tester);

    expect(find.byType(MovieView, skipOffstage: false), findsNWidgets(testMovies.length));
  });

  testWidgets('should display an error message when movies fail to load', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Left(NetworkFailure()));
    await _pumpMoviesView(tester);

    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });

  testWidgets('should display a refresh button when movies fail to load', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Left(ServerFailure()));
    await _pumpMoviesView(tester);

    expect(find.text(TranslatableStrings.SERVER_FAILURE_MESSAGE), findsOneWidget);
    expect(find.byKey(Key(UntranslatableStrings.REFRESH_BUTTON_KEY)), findsOneWidget);
  });

  testWidgets('should display a list of movies when refresh button is clicked', (tester) async {
    when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Left(ServerFailure()));
    await _pumpMoviesView(tester);

    await tester.runAsync(() async {
      when(mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));
      await tester.tap(find.byKey(Key(UntranslatableStrings.REFRESH_BUTTON_KEY)));
      await tester.pumpAndSettle();
    });

    expect(find.byType(MovieView, skipOffstage: false), findsNWidgets(testMovies.length));
  });
}
