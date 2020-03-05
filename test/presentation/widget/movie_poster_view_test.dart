import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/domain_entity_builder.dart';
import '../../test_util/mock_http_overrides.dart';
import '../../builder/movie_domain_entity_builder.dart';

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('should display a movie poster as a CachedNetworkImage', (tester) async {
    final String testPosterUrl = movieDomainEntityBuilder.build().posterUrl;
    await tester.pumpWidget(MaterialApp(
      home: MoviePosterView(
        posterUrl: testPosterUrl,
      ),
    ));

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}
