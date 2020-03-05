import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class GetMovieReviewsUseCase implements UseCaseWithParams<List<Review>, int> {
  final ReviewRepository _reviewRepository;

  GetMovieReviewsUseCase(this._reviewRepository);

  @override
  Future<Either<Failure, List<Review>>> execute(int movieId) {
    return _reviewRepository.getMovieReviews(movieId);
  }
}
