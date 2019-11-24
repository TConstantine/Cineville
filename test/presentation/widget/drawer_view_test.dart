import 'package:cineville/presentation/widget/attributions_view.dart';
import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future _pumpDrawerView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DrawerView(),
    ));
  }

  testWidgets('should display attributions option', (tester) async {
    await _pumpDrawerView(tester);

    expect(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.descendant(
          of: find.byType(ListTile),
          matching: find.text(TranslatableStrings.ATTRIBUTIONS),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should display attributions when attributions option is clicked', (tester) async {
    await _pumpDrawerView(tester);

    await tester.tap(find.byKey(Key(UntranslatableStrings.ATTRIBUTIONS_OPTION_KEY)));
    await tester.pump();

    expect(find.byType(AttributionsView), findsOneWidget);
  });

  testWidgets('should close attributions when close button is clicked', (tester) async {
    await _pumpDrawerView(tester);

    await tester.tap(find.byKey(Key(UntranslatableStrings.ATTRIBUTIONS_OPTION_KEY)));
    await tester.pump();

    await tester.tap(find.text(TranslatableStrings.CLOSE));
    await tester.pump();

    expect(find.byType(AttributionsView), findsNothing);
  });
}
