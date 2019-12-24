import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future _pumpDrawerView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DrawerView(),
    ));
  }

  testWidgets('should display movies option', (tester) async {
    await _pumpDrawerView(tester);

    expect(find.text(TranslatableStrings.MOVIES), findsOneWidget);
  });

  testWidgets('should display tv shows option', (tester) async {
    await _pumpDrawerView(tester);

    expect(find.text(TranslatableStrings.TV_SHOWS), findsOneWidget);
  });

  testWidgets('should display favorite option', (tester) async {
    await _pumpDrawerView(tester);

    expect(find.text(TranslatableStrings.FAVORITE), findsOneWidget);
  });

  testWidgets('should display watched option', (tester) async {
    await _pumpDrawerView(tester);

    expect(find.text(TranslatableStrings.WATCHED), findsOneWidget);
  });

  testWidgets('should display attributions option', (tester) async {
    await _pumpDrawerView(tester);

    expect(find.text(TranslatableStrings.ATTRIBUTIONS), findsOneWidget);
  });
}
