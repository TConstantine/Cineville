import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/actor_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/actor_depository.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/actor_domain_entity_builder.dart';
import '../../builder/actor_data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockNetwork extends Mock implements Network {}

class MockActorDomainEntityMapper extends Mock implements ActorDomainEntityMapper {}

void main() {
  DomainEntityBuilder actorDomainEntityBuilder;
  DataEntityBuilder actorDataEntityBuilder;
  RemoteDataSource mockRemoteDataSource;
  DatabaseDataSource mockDatabaseDataSource;
  Network mockNetwork;
  ActorDomainEntityMapper mockActorDomainEntityMapper;
  ActorRepository actorRepository;

  setUp(() {
    actorDomainEntityBuilder = ActorDomainEntityBuilder();
    actorDataEntityBuilder = ActorDataEntityBuilder();
    mockRemoteDataSource = MockRemoteDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockNetwork = MockNetwork();
    mockActorDomainEntityMapper = MockActorDomainEntityMapper();
    actorRepository = ActorDepository(
      mockRemoteDataSource,
      mockDatabaseDataSource,
      mockNetwork,
      mockActorDomainEntityMapper,
    );
  });

  test('should return cached actors from database data source', () async {
    final int movieId = 1;
    final List<Actor> actorDomainEntities = actorDomainEntityBuilder.buildList();
    final List<DataEntity> actorDataEntities = actorDataEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => actorDataEntities);
    when(mockActorDomainEntityMapper.map(any)).thenReturn(actorDomainEntities);

    final Either<Failure, List<Actor>> result = await actorRepository.getMovieActors(movieId);

    verify(mockDatabaseDataSource.getMovieDataEntities(DataEntityType.ACTOR, movieId));
    verifyZeroInteractions(mockRemoteDataSource);
    expect(result, equals(Right(actorDomainEntities)));
  });

  test('should store actors locally when they are acquired from remote data source', () async {
    final int movieId = 1;
    final List<DataEntity> actorDataEntities = actorDataEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => actorDataEntities);

    await actorRepository.getMovieActors(movieId);

    verifyInOrder([
      mockRemoteDataSource.getMovieDataEntities(DataEntityType.ACTOR, movieId),
      mockDatabaseDataSource.storeMovieDataEntities(
        DataEntityType.ACTOR,
        movieId,
        actorDataEntities,
      ),
    ]);
  });

  test('should return server failure when server throws an exception', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenThrow(ServerException());

    final Either<Failure, List<Actor>> result = await actorRepository.getMovieActors(movieId);

    expect(result, equals(Left(ServerFailure())));
  });

  test('should return network failure when device is offline', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => false);

    final Either<Failure, List<Actor>> result = await actorRepository.getMovieActors(movieId);

    expect(result, equals(Left(NetworkFailure())));
  });

  test('should return no data failure when server responds with no results', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);

    final Either<Failure, List<Actor>> result = await actorRepository.getMovieActors(movieId);

    expect(result, equals(Left(NoDataFailure())));
  });
}
