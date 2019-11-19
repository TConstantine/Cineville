import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetPopularMovies implements UseCase {
  final MovieRepository _movieRepository;

  GetPopularMovies(this._movieRepository);

  @override
  Future<Either<Failure, List<Movie>>> execute(int page) async {
    return await _movieRepository.getPopularMovies(page);
  }
}
