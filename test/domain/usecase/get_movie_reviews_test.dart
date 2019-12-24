import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/usecase/get_movie_reviews.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_review_builder.dart';

class MockRepository extends Mock implements ReviewRepository {}

void main() {
  ReviewRepository mockRepository;
  UseCase<Review> useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = GetMovieReviews(mockRepository);
  });

  final List<Review> testReviews = TestReviewBuilder().buildMultiple();
  final int testMovieId = 100;

  test('should retrieve movie reviews for a specific movie from the review repository', () async {
    when(mockRepository.getMovieReviews(any)).thenAnswer((_) async => Right(testReviews));

    final Either<Failure, List<Review>> result = await useCase.execute(testMovieId);

    expect(result, Right(testReviews));
    verify(mockRepository.getMovieReviews(testMovieId));
    verifyNoMoreInteractions(mockRepository);
  });
}
