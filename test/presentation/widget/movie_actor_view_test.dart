import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/presentation/widget/movie_actor_profile_view.dart';
import 'package:cineville/presentation/widget/movie_actor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_actor_builder.dart';

void main() {
  final Actor testActor = TestActorBuilder().build();

  Future _pumpMovieActorView(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MovieActorView(
        actor: testActor,
      ),
    ));
  }

  testWidgets('should display actor profile', (tester) async {
    await _pumpMovieActorView(tester);

    expect(find.byType(MovieActorProfileView), findsOneWidget);
  });

  testWidgets('should display actor name', (tester) async {
    await _pumpMovieActorView(tester);

    expect(find.text(testActor.name), findsOneWidget);
  });

  testWidgets('should display actor character', (tester) async {
    await _pumpMovieActorView(tester);

    expect(find.text(testActor.character), findsOneWidget);
  });
}
