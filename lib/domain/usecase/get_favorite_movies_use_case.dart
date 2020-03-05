import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:dartz/dartz.dart';

class GetFavoriteMoviesUseCase implements UseCaseNoParams<List<Movie>> {
  final FavoriteRepository _favoriteRepository;

  GetFavoriteMoviesUseCase(this._favoriteRepository);

  @override
  Future<Either<Failure, List<Movie>>> execute() {
    return _favoriteRepository.getMovies();
  }
}
