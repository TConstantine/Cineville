import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<Movie>>> getMovies();
  Future<Either<Failure, bool>> isMovieMarkedAsFavorite(int movieId);
  Future<Either<Failure, void>> markMovieAsFavorite(int movieId);
  Future<Either<Failure, int>> removeMovieFromFavorites(int movieId);
}
