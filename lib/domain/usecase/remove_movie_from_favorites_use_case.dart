import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class RemoveMovieFromFavoritesUseCase extends UseCaseWithParams<int, int> {
  final FavoriteRepository _favoriteRepository;

  RemoveMovieFromFavoritesUseCase(this._favoriteRepository);

  @override
  Future<Either<Failure, int>> execute(int movieId) {
    return _favoriteRepository.removeMovieFromFavorites(movieId);
  }
}
