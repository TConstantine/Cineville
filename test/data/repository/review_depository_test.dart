import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/review_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/review_depository.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/review_domain_entity_builder.dart';
import '../../builder/review_data_entity_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockNetwork extends Mock implements Network {}

class MockReviewDomainEntityMapper extends Mock implements ReviewDomainEntityMapper {}

void main() {
  DomainEntityBuilder reviewDomainEntityBuilder;
  DataEntityBuilder reviewDataEntityBuilder;
  RemoteDataSource mockRemoteDataSource;
  DatabaseDataSource mockDatabaseDataSource;
  Network mockNetwork;
  ReviewDomainEntityMapper mockReviewDomainEntityMapper;
  ReviewRepository reviewRepository;

  setUp(() {
    reviewDomainEntityBuilder = ReviewDomainEntityBuilder();
    reviewDataEntityBuilder = ReviewDataEntityBuilder();
    mockRemoteDataSource = MockRemoteDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockNetwork = MockNetwork();
    mockReviewDomainEntityMapper = MockReviewDomainEntityMapper();
    reviewRepository = ReviewDepository(
      mockRemoteDataSource,
      mockDatabaseDataSource,
      mockNetwork,
      mockReviewDomainEntityMapper,
    );
  });

  test('should return cached reviews from database data source', () async {
    final int movieId = 1;
    final List<DataEntity> reviewDataEntities = reviewDataEntityBuilder.buildList();
    final List<Review> reviewDomainEntities = reviewDomainEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => reviewDataEntities);
    when(mockReviewDomainEntityMapper.map(any)).thenReturn(reviewDomainEntities);

    final Either<Failure, List<Review>> result = await reviewRepository.getMovieReviews(movieId);

    verify(mockDatabaseDataSource.getMovieDataEntities(DataEntityType.REVIEW, movieId));
    verifyZeroInteractions(mockRemoteDataSource);
    expect(result, equals(Right(reviewDomainEntities)));
  });

  test('should store reviews locally when they are acquired from remote data source', () async {
    final int movieId = 1;
    final List<DataEntity> reviewDataEntities = reviewDataEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any))
        .thenAnswer((_) async => reviewDataEntities);

    await reviewRepository.getMovieReviews(movieId);

    verifyInOrder([
      mockRemoteDataSource.getMovieDataEntities(DataEntityType.REVIEW, movieId),
      mockDatabaseDataSource.storeMovieDataEntities(
        DataEntityType.REVIEW,
        movieId,
        reviewDataEntities,
      ),
    ]);
  });

  test('should return server failure when server throws an exception', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenThrow(ServerException());

    final Either<Failure, List<Review>> result = await reviewRepository.getMovieReviews(movieId);

    expect(result, equals(Left(ServerFailure())));
  });

  test('should return network failure when device is offline', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => false);

    final Either<Failure, List<Review>> result = await reviewRepository.getMovieReviews(movieId);

    expect(result, equals(Left(NetworkFailure())));
  });

  test('should return no data failure when server responds with no results', () async {
    final int movieId = 1;
    when(mockDatabaseDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovieDataEntities(any, any)).thenAnswer((_) async => []);

    final Either<Failure, List<Review>> result = await reviewRepository.getMovieReviews(movieId);

    expect(result, equals(Left(NoDataFailure())));
  });
}
