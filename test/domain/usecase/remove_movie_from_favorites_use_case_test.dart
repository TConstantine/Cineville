import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/remove_movie_from_favorites_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  FavoriteRepository mockFavoriteRepository;
  UseCaseWithParams<void, int> useCaseWithParams;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    useCaseWithParams = RemoveMovieFromFavoritesUseCase(mockFavoriteRepository);
  });

  test('should remove movie from favorites', () async {
    final int movieId = 1;

    await useCaseWithParams.execute(movieId);

    verify(mockFavoriteRepository.removeMovieFromFavorites(movieId));
  });
}
