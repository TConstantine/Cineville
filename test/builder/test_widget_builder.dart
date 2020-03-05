import 'package:cineville/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidgetBuilder {
  static Future openDrawer(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
  }

  static Future pumpWidget(Widget widget, WidgetTester tester, {wrap = true}) async {
    if (wrap) {
      await tester.pumpWidget(MaterialApp(home: widget));
    } else {
      await tester.pumpWidget(widget);
    }
  }

  static Future runAsync(
    Injector injector,
    Widget widget,
    WidgetTester tester, {
    pumpAndSettle = false,
    wrap = true,
  }) async {
    await tester.runAsync(() async {
      await injector.inject();
      await pumpWidget(widget, tester, wrap: wrap);
      if (pumpAndSettle) {
        await tester.pumpAndSettle();
      }
    });
  }
}
