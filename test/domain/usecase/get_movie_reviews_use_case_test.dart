import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/usecase/get_movie_reviews_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/review_domain_entity_builder.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  DomainEntityBuilder reviewDomainEntityBuilder;
  ReviewRepository mockReviewRepository;
  UseCaseWithParams<List<Review>, int> useCaseWithParams;

  setUp(() {
    reviewDomainEntityBuilder = ReviewDomainEntityBuilder();
    mockReviewRepository = MockReviewRepository();
    useCaseWithParams = GetMovieReviewsUseCase(mockReviewRepository);
  });

  test('should retrieve movie reviews for a specific movie from the review repository', () async {
    final int movieId = 1;
    final List<Review> reviewDomainEntities = reviewDomainEntityBuilder.buildList();
    when(mockReviewRepository.getMovieReviews(any))
        .thenAnswer((_) async => Right(reviewDomainEntities));

    final Either<Failure, List<Review>> result = await useCaseWithParams.execute(movieId);

    verify(mockReviewRepository.getMovieReviews(movieId));
    expect(result, Right(reviewDomainEntities));
  });
}
