import 'package:cineville/presentation/widget/categories_navigation_bar_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final int testCurrentIndex = 0;
  final Function(int) testOnTap = (index) {};

  Future _pumpCategoriesNavigationBarView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoriesNavigationBarView(
        currentIndex: testCurrentIndex,
        onTap: testOnTap,
      ),
    ));
  }

  testWidgets('should display popular category', (tester) async {
    await _pumpCategoriesNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_POPULAR), findsOneWidget);
  });

  testWidgets('should display upcoming category', (tester) async {
    await _pumpCategoriesNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_UPCOMING), findsOneWidget);
  });

  testWidgets('should display top rated category', (tester) async {
    await _pumpCategoriesNavigationBarView(tester);

    expect(find.text(TranslatableStrings.CATEGORY_TOP_RATED), findsOneWidget);
  });
}
