import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/usecase/get_movie_actors_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/actor_domain_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';

class MockActorRepository extends Mock implements ActorRepository {}

void main() {
  DomainEntityBuilder actorDomainEntityBuilder;
  ActorRepository mockActorRepository;
  UseCaseWithParams<List<Actor>, int> useCaseWithParams;

  setUp(() {
    actorDomainEntityBuilder = ActorDomainEntityBuilder();
    mockActorRepository = MockActorRepository();
    useCaseWithParams = GetMovieActorsUseCase(mockActorRepository);
  });

  test('should retrieve movie actors for a specific movie from actor repository', () async {
    final int movieId = 1;
    final List<Actor> actorDomainEntities = actorDomainEntityBuilder.buildList();
    when(mockActorRepository.getMovieActors(any))
        .thenAnswer((_) async => Right(actorDomainEntities));

    final Either<Failure, List<Actor>> result = await useCaseWithParams.execute(movieId);

    verify(mockActorRepository.getMovieActors(movieId));
    expect(result, Right(actorDomainEntities));
  });
}
