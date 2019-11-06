import 'package:dartz/dartz.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page);
}
