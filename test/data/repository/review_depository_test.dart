import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/review_mapper.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/review_depository.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_review_builder.dart';
import '../../test_util/test_review_model_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetwork extends Mock implements Network {}

class MockMapper extends Mock implements ReviewMapper {}

void main() {
  RemoteDataSource mockRemoteDataSource;
  LocalDataSource mockLocalDataSource;
  Network mockNetwork;
  ReviewMapper mockMapper;
  ReviewRepository repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetwork = MockNetwork();
    mockMapper = MockMapper();
    repository = ReviewDepository(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetwork,
      mockMapper,
    );
  });

  final int testMovieId = 200;
  final List<ReviewModel> testReviewModels = TestReviewModelBuilder().buildMultiple();
  final List<Review> testReviews = TestReviewBuilder().buildMultiple();

  void _whenReviewCacheIsNotEmpty(Function body) {
    group('when review cache is not empty', () {
      setUp(() {
        when(mockLocalDataSource.getMovieReviews(any)).thenAnswer((_) async => testReviewModels);
      });

      body();
    });
  }

  void _whenReviewCacheIsEmpty(Function body) {
    group('when review cache is empty', () {
      setUp(() {
        when(mockLocalDataSource.getMovieReviews(any)).thenAnswer((_) async => []);
      });

      body();
    });
  }

  void _whenDeviceIsOnline(Function body) {
    group('when device is online', () {
      setUp(() {
        when(mockNetwork.isConnected()).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void _whenDeviceIsOffline(Function body) {
    group('when device is offline', () {
      setUp(() {
        when(mockNetwork.isConnected()).thenAnswer((_) async => false);
      });

      body();
    });
  }

  void _whenRemoteRequestForMovieReviewsIsSuccessful(Function body) {
    group('when remote request for movie reviews is successful', () {
      setUp(() {
        when(mockRemoteDataSource.getMovieReviews(any)).thenAnswer((_) async => testReviewModels);
      });

      body();
    });
  }

  void _whenRemoteRequestForMovieReviewsIsUnsuccessful(Function body) {
    group('when remote request for movie reviews is unsuccessful', () {
      setUp(() {
        when(mockRemoteDataSource.getMovieReviews(any)).thenThrow(ServerException());
      });

      body();
    });
  }

  group('getMovieReviews', () {
    _whenReviewCacheIsNotEmpty(() {
      test('should return cached reviews', () async {
        when(mockLocalDataSource.getMovieReviews(any)).thenAnswer((_) async => testReviewModels);
        when(mockMapper.map(any)).thenReturn(testReviews);

        final Either<Failure, List<Review>> result = await repository.getMovieReviews(testMovieId);

        verifyZeroInteractions(mockNetwork);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Right(testReviews)));
      });
    });

    _whenReviewCacheIsEmpty(() {
      _whenDeviceIsOnline(() {
        _whenRemoteRequestForMovieReviewsIsSuccessful(() {
          test('should store reviews locally', () async {
            await repository.getMovieReviews(testMovieId);

            verify(mockRemoteDataSource.getMovieReviews(testMovieId));
            verify(mockLocalDataSource.storeMovieReviews(testMovieId, testReviewModels));
          });
        });

        test('should not store anything when there are no reviews', () {
          when(mockRemoteDataSource.getMovieReviews(any)).thenAnswer((_) async => []);

          verifyNever(mockLocalDataSource.storeMovieReviews(any, any));
        });

        _whenRemoteRequestForMovieReviewsIsUnsuccessful(() {
          test('should return server failure', () async {
            final Either<Failure, List<Review>> result =
                await repository.getMovieReviews(testMovieId);

            verify(mockRemoteDataSource.getMovieReviews(testMovieId));
            expect(result, equals(Left(ServerFailure())));
          });
        });
      });

      _whenDeviceIsOffline(() {
        test('should return network failure', () async {
          final Either<Failure, List<Review>> result =
              await repository.getMovieReviews(testMovieId);

          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });
  });
}
