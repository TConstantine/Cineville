import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies(String movieCategory, int page);
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId);
}
