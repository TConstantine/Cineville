import 'dart:io';

import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_http_overrides.dart';
import '../../test_util/test_movie_builder.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  final String testPosterUrl = TestMovieBuilder().build().posterUrl;

  testWidgets('should display a movie poster as a FadeInImage', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MoviePosterView(
        posterUrl: testPosterUrl,
      ),
    ));

    expect(find.byType(FadeInImage), findsOneWidget);
  });
}
