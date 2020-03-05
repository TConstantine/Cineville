import 'package:cineville/presentation/widget/movie_title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/test_widget_builder.dart';

void main() {
  String testTitle;
  Widget widget;

  setUp(() {
    testTitle = 'Movie Title';
    widget = MovieTitleView(title: testTitle);
  });

  testWidgets('should display title', (tester) async {
    await TestWidgetBuilder.pumpWidget(widget, tester);

    expect(find.text(testTitle), findsOneWidget);
  });
}
