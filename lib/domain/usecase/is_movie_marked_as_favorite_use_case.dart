import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class IsMovieMarkedAsFavoriteUseCase implements UseCaseWithParams<bool, int> {
  final FavoriteRepository _favoriteRepository;

  IsMovieMarkedAsFavoriteUseCase(this._favoriteRepository);

  @override
  Future<Either<Failure, bool>> execute(int movieId) {
    return _favoriteRepository.isMovieMarkedAsFavorite(movieId);
  }
}
