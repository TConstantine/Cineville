import 'package:cineville/presentation/widget/movie_rating_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_movie_builder.dart';

void main() {
  final String testRating = TestMovieBuilder().build().rating;

  testWidgets('should display rating', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MovieRatingView(
        rating: testRating,
      ),
    ));

    expect(find.text(testRating), findsOneWidget);
  });
}
