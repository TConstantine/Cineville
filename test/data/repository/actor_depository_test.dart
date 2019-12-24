import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/actor_mapper.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/actor_depository.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_actor_builder.dart';
import '../../test_util/test_actor_model_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetwork extends Mock implements Network {}

class MockMapper extends Mock implements ActorMapper {}

void main() {
  RemoteDataSource mockRemoteDataSource;
  LocalDataSource mockLocalDataSource;
  Network mockNetwork;
  ActorMapper mockMapper;
  ActorRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetwork = MockNetwork();
    mockMapper = MockMapper();
    repository = ActorDepository(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetwork,
      mockMapper,
    );
  });

  final int testMovieId = 200;
  final List<ActorModel> testActorModels = TestActorModelBuilder().buildMultiple();
  final List<Actor> testActors = TestActorBuilder().buildMultiple();

  test('should return cached actors', () async {
    when(mockLocalDataSource.getMovieActors(any)).thenAnswer((_) async => testActorModels);
    when(mockMapper.map(any)).thenReturn(testActors);

    final Either<Failure, List<Actor>> result = await repository.getMovieActors(testMovieId);

    verifyZeroInteractions(mockNetwork);
    verifyZeroInteractions(mockRemoteDataSource);
    verifyInOrder([
      mockLocalDataSource.getMovieActors(testMovieId),
      mockMapper.map(testActorModels),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockMapper);
    expect(result, equals(Right(testActors)));
  });

  test('should store actors locally', () async {
    when(mockLocalDataSource.getMovieActors(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieActors(any)).thenAnswer((_) async => testActorModels);

    await repository.getMovieActors(testMovieId);

    verifyInOrder([
      mockLocalDataSource.getMovieActors(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieActors(testMovieId),
      mockLocalDataSource.storeMovieActors(testMovieId, testActorModels),
      mockMapper.map(testActorModels),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockRemoteDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockMapper);
  });

  test('should return server failure', () async {
    when(mockLocalDataSource.getMovieActors(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieActors(any)).thenThrow(ServerException());

    final Either<Failure, List<Actor>> result = await repository.getMovieActors(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyInOrder([
      mockLocalDataSource.getMovieActors(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieActors(testMovieId),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockRemoteDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockMapper);
    expect(result, equals(Left(ServerFailure())));
  });

  test('should return network failure', () async {
    when(mockLocalDataSource.getMovieActors(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => false);

    final Either<Failure, List<Actor>> result = await repository.getMovieActors(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyZeroInteractions(mockRemoteDataSource);
    verifyInOrder([
      mockLocalDataSource.getMovieActors(testMovieId),
      mockNetwork.isConnected(),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockNetwork);
    expect(result, equals(Left(NetworkFailure())));
  });

  test('should return no data failure', () async {
    when(mockLocalDataSource.getMovieActors(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieActors(any)).thenAnswer((_) async => []);

    final Either<Failure, List<Actor>> result = await repository.getMovieActors(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyInOrder([
      mockLocalDataSource.getMovieActors(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieActors(testMovieId),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockRemoteDataSource);
    expect(result, equals(Left(NoDataFailure())));
  });
}
