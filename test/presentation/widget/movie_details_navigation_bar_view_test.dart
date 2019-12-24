import 'package:cineville/presentation/widget/movie_details_navigation_bar_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final int testCurrentIndex = 0;
  final Function(int) testOnTap = (index) {};

  Future _pumpMovieDetailsNavigationBarView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MovieDetailsNavigationBarView(
        currentIndex: testCurrentIndex,
        onTap: testOnTap,
      ),
    ));
  }

  testWidgets('should display info category', (tester) async {
    await _pumpMovieDetailsNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_INFO), findsOneWidget);
  });

  testWidgets('should display actors category', (tester) async {
    await _pumpMovieDetailsNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_ACTORS), findsOneWidget);
  });

  testWidgets('should display reviews category', (tester) async {
    await _pumpMovieDetailsNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_REVIEWS), findsOneWidget);
  });
}
