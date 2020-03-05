import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:dartz/dartz.dart';

class GetUpcomingMoviesUseCase implements UseCaseWithParams<List<Movie>, int> {
  final MovieRepository _movieRepository;

  GetUpcomingMoviesUseCase(this._movieRepository);

  @override
  Future<Either<Failure, List<Movie>>> execute(int page) {
    return _movieRepository.getMovies(MovieCategory.UPCOMING, page);
  }
}
