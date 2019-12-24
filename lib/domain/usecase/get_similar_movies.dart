import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetSimilarMovies implements UseCase<Movie> {
  final MovieRepository repository;

  GetSimilarMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> execute(int movieId) {
    return repository.getSimilarMovies(movieId);
  }
}