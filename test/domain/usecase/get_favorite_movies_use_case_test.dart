import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/get_favorite_movies_use_case.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  FavoriteRepository mockFavoriteRepository;
  UseCaseNoParams<List<Movie>> useCaseNoParams;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    useCaseNoParams = GetFavoriteMoviesUseCase(mockFavoriteRepository);
  });

  test('should retrieve favorite movies from the favorite repository', () async {
    await useCaseNoParams.execute();

    verify(mockFavoriteRepository.getMovies());
  });
}
