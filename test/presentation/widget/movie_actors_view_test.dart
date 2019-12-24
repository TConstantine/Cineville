import 'dart:io';

import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/widget/movie_actor_view.dart';
import 'package:cineville/presentation/widget/movie_actors_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util/test_actor_builder.dart';

class MockRepository extends Mock implements ActorRepository {}

void main() {
  ActorRepository mockRepository;

  setUpAll(() async {
    final Directory directory = await Directory.systemTemp.createTemp();
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return directory.path;
      }
      return null;
    });
    const MethodChannel('com.tekartik.sqflite')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getDatabasesPath') {
        return directory.path;
      }
      return null;
    });
  });

  setUp(() {
    mockRepository = MockRepository();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  Future _pumpMovieActorsView(WidgetTester tester) async {
    final int testMovieId = 100;
    await tester.runAsync(() async {
      await Injector().withActorRepository(mockRepository).inject();
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider(
          builder: (_) => injector<ActorsBloc>(),
          child: MovieActorsView(movieId: testMovieId),
        ),
      ));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('should display movie actors when actors load successfully', (tester) async {
    final List<Actor> testActors = TestActorBuilder().buildMultiple();
    when(mockRepository.getMovieActors(any)).thenAnswer((_) async => Right(testActors));

    await _pumpMovieActorsView(tester);

    expect(find.byType(MovieActorView, skipOffstage: false), findsNWidgets(testActors.length));
  });

  testWidgets('should display an error message when actors fail to load', (tester) async {
    when(mockRepository.getMovieActors(any)).thenAnswer((_) async => Left(NetworkFailure()));

    await _pumpMovieActorsView(tester);

    expect(find.text(TranslatableStrings.NETWORK_FAILURE_MESSAGE), findsOneWidget);
  });
}
