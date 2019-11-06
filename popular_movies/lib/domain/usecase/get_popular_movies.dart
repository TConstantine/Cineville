import 'package:dartz/dartz.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository _movieRepository;

  GetPopularMovies(this._movieRepository);

  Future<Either<Failure, List<Movie>>> execute(int page) async {
    return await _movieRepository.getPopularMovies(page);
  }
}
