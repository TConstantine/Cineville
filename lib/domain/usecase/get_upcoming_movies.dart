import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetUpcomingMovies implements UseCase {
  final MovieRepository _movieRepository;

  GetUpcomingMovies(this._movieRepository);

  @override
  Future<Either<Failure, List<Movie>>> execute(int page) {
    return _movieRepository.getUpcomingMovies(page);
  }
}
