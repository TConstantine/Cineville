import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/usecase/get_movie_actors.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_actor_builder.dart';

class MockRepository extends Mock implements ActorRepository {}

void main() {
  ActorRepository mockRepository;
  UseCase<Actor> useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = GetMovieActors(mockRepository);
  });

  final List<Actor> testActors = TestActorBuilder().buildMultiple();
  final int testMovieId = 100;

  test('should retrieve movie actors for a specific movie from the actor repository', () async {
    when(mockRepository.getMovieActors(any)).thenAnswer((_) async => Right(testActors));

    final Either<Failure, List<Actor>> result = await useCase.execute(testMovieId);

    expect(result, Right(testActors));
    verify(mockRepository.getMovieActors(testMovieId));
    verifyNoMoreInteractions(mockRepository);
  });
}
