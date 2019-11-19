import 'dart:io';

import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/movie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_http_overrides.dart';
import '../../test_util/test_movie_builder.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  final Movie testMovie = TestMovieBuilder().build();

  testWidgets('should display a movie poster', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MovieView(
        movie: testMovie,
      ),
    ));

    expect(find.byType(MoviePosterView), findsOneWidget);
  });
}
