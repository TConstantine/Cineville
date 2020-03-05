import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/video_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/video_depository.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/video_domain_entity_builder.dart';
import '../../builder/video_data_entity_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockNetwork extends Mock implements Network {}

class MockVideoDomainEntityMapper extends Mock implements VideoDomainEntityMapper {}

void main() {
  DomainEntityBuilder videoDomainEntityBuilder;
  DataEntityBuilder videoDataEntityBuilder;
  RemoteDataSource mockRemoteDataSource;
  DatabaseDataSource mockDatabaseDataSource;
  Network mockNetwork;
  VideoDomainEntityMapper mockVideoDomainEntityMapper;
  VideoRepository videoRepository;

  setUp(() {
    videoDomainEntityBuilder = VideoDomainEntityBuilder();
    videoDataEntityBuilder = VideoDataEntityBuilder();
    mockRemoteDataSource = MockRemoteDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockNetwork = MockNetwork();
    mockVideoDomainEntityMapper = MockVideoDomainEntityMapper();
    videoRepository = VideoDepository(
      mockRemoteDataSource,
      mockDatabaseDataSource,
      mockNetwork,
      mockVideoDomainEntityMapper,
    );
  });

  test('should return cached videos from database data source', () async {
    final int movieId = 1;
    final List<DataEntity> videoDataEntities = videoDataEntityBuilder.buildList();
    final List<Video> videoDomainEntities = videoDomainEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => videoDataEntities);
    when(mockVideoDomainEntityMapper.map(any)).thenReturn(videoDomainEntities);

    final Either<Failure, List<Video>> result = await videoRepository.getMovieVideos(movieId);

    verify(mockDatabaseDataSource.getMovieDataEntities(DataEntityType.VIDEO, movieId));
    verifyZeroInteractions(mockRemoteDataSource);
    expect(result, equals(Right(videoDomainEntities)));
  });

  test('should store videos locally when they are acquired from remote data source', () async {
    final int movieId = 1;
    final List<DataEntity> videoDataEntities = videoDataEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => videoDataEntities);

    await videoRepository.getMovieVideos(movieId);

    verifyInOrder([
      mockRemoteDataSource.getMovieDataEntities(DataEntityType.VIDEO, movieId),
      mockDatabaseDataSource.storeMovieDataEntities(
        DataEntityType.VIDEO,
        movieId,
        videoDataEntities,
      ),
    ]);
  });

  test('should return server failure when server throws an exception', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenThrow(ServerException());

    final Either<Failure, List<Video>> result = await videoRepository.getMovieVideos(movieId);

    expect(result, equals(Left(ServerFailure())));
  });

  test('should return network failure when device is offline', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => false);

    final Either<Failure, List<Video>> result = await videoRepository.getMovieVideos(movieId);

    expect(result, equals(Left(NetworkFailure())));
  });

  test('should return no data failure when server responds with no results', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);

    final Either<Failure, List<Video>> result = await videoRepository.getMovieVideos(movieId);

    expect(result, equals(Left(NoDataFailure())));
  });
}
