import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/video_mapper.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/video_depository.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_video_builder.dart';
import '../../test_util/test_video_model_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetwork extends Mock implements Network {}

class MockMapper extends Mock implements VideoMapper {}

void main() {
  RemoteDataSource mockRemoteDataSource;
  LocalDataSource mockLocalDataSource;
  Network mockNetwork;
  VideoMapper mockMapper;
  VideoRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetwork = MockNetwork();
    mockMapper = MockMapper();
    repository = VideoDepository(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetwork,
      mockMapper,
    );
  });

  final List<VideoModel> testVideoModels = TestVideoModelBuilder().buildMultiple();
  final List<Video> testVideos = TestVideoBuilder().buildMultiple();
  final int testMovieId = 5;

  test('should return cached videos', () async {
    when(mockLocalDataSource.getMovieVideos(any)).thenAnswer((_) async => testVideoModels);
    when(mockMapper.map(any)).thenReturn(testVideos);

    final Either<Failure, List<Video>> result = await repository.getMovieVideos(testMovieId);

    verifyZeroInteractions(mockNetwork);
    verifyZeroInteractions(mockRemoteDataSource);
    verifyInOrder([
      mockLocalDataSource.getMovieVideos(testMovieId),
      mockMapper.map(testVideoModels),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockMapper);
    expect(result, equals(Right(testVideos)));
  });

  test('should store videos locally', () async {
    when(mockLocalDataSource.getMovieVideos(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieVideos(any)).thenAnswer((_) async => testVideoModels);

    await repository.getMovieVideos(testMovieId);

    verifyInOrder([
      mockLocalDataSource.getMovieVideos(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieVideos(testMovieId),
      mockLocalDataSource.storeMovieVideos(testMovieId, testVideoModels),
      mockMapper.map(testVideoModels),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockRemoteDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockMapper);
  });

  test('should return server failure', () async {
    when(mockLocalDataSource.getMovieVideos(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieVideos(any)).thenThrow(ServerException());

    final Either<Failure, List<Video>> result = await repository.getMovieVideos(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyInOrder([
      mockLocalDataSource.getMovieVideos(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieVideos(testMovieId),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockRemoteDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockMapper);
    expect(result, equals(Left(ServerFailure())));
  });

  test('should return network failure', () async {
    when(mockLocalDataSource.getMovieVideos(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => false);

    final Either<Failure, List<Video>> result = await repository.getMovieVideos(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyZeroInteractions(mockRemoteDataSource);
    verifyInOrder([
      mockLocalDataSource.getMovieVideos(testMovieId),
      mockNetwork.isConnected(),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockNetwork);
    expect(result, equals(Left(NetworkFailure())));
  });

  test('should return no data failure', () async {
    when(mockLocalDataSource.getMovieVideos(any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieVideos(any)).thenAnswer((_) async => []);

    final Either<Failure, List<Video>> result = await repository.getMovieVideos(testMovieId);

    verifyZeroInteractions(mockMapper);
    verifyInOrder([
      mockLocalDataSource.getMovieVideos(testMovieId),
      mockNetwork.isConnected(),
      mockRemoteDataSource.getMovieVideos(testMovieId),
    ]);
    verifyNoMoreInteractions(mockLocalDataSource);
    verifyNoMoreInteractions(mockNetwork);
    verifyNoMoreInteractions(mockRemoteDataSource);
    expect(result, equals(Left(NoDataFailure())));
  });
}
