import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/util/pair.dart';
import 'package:dartz/dartz.dart';

class GetMoviesUseCase implements UseCaseWithParams<List<Movie>, Pair<String, int>> {
  final MovieRepository _movieRepository;

  GetMoviesUseCase(this._movieRepository);

  @override
  Future<Either<Failure, List<Movie>>> execute(Pair<String, int> params) {
    return _movieRepository.getMovies(params.left, params.right);
  }
}
