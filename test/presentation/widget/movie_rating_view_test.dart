import 'package:cineville/presentation/widget/movie_rating_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
  });

  testWidgets('should display rating', (tester) async {
    final String testRating = movieDomainEntityBuilder.build().rating;
    await tester.pumpWidget(MaterialApp(
      home: MovieRatingView(
        rating: testRating,
      ),
    ));

    expect(find.text(testRating), findsOneWidget);
  });
}
