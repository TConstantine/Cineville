import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class MarkMovieAsFavoriteUseCase implements UseCaseWithParams<void, int> {
  final FavoriteRepository _favoriteRepository;

  MarkMovieAsFavoriteUseCase(this._favoriteRepository);

  @override
  Future<Either<Failure, void>> execute(int movieId) {
    return _favoriteRepository.markMovieAsFavorite(movieId);
  }
}
