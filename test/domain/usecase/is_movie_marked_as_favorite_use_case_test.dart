import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/is_movie_marked_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  FavoriteRepository mockFavoriteRepository;
  UseCaseWithParams<bool, int> useCaseWithParams;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    useCaseWithParams = IsMovieMarkedAsFavoriteUseCase(mockFavoriteRepository);
  });

  test('should ask favorite repository if movie is favorite or not', () async {
    final int movieId = 1;

    await useCaseWithParams.execute(movieId);

    verify(mockFavoriteRepository.isMovieMarkedAsFavorite(movieId));
  });
}
