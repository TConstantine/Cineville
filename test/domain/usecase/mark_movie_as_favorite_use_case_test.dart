import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/mark_movie_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  FavoriteRepository mockFavoriteRepository;
  UseCaseWithParams<void, int> useCaseWithParams;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    useCaseWithParams = MarkMovieAsFavoriteUseCase(mockFavoriteRepository);
  });

  test('should add movie to favorites', () async {
    final int movieId = 1;

    await useCaseWithParams.execute(movieId);

    verify(mockFavoriteRepository.markMovieAsFavorite(movieId));
  });
}
