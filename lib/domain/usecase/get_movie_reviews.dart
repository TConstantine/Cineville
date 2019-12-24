import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetMovieReviews implements UseCase<Review> {
  final ReviewRepository repository;

  GetMovieReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> execute(int movieId) {
    return repository.getMovieReviews(movieId);
  }
}
