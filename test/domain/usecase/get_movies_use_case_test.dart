import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_movies_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:cineville/util/pair.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  MovieRepository mockMovieRepository;
  UseCaseWithParams<List<Movie>, Pair<String, int>> useCaseWithParams;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCaseWithParams = GetMoviesUseCase(mockMovieRepository);
  });

  test('should return movies from movie repository', () {
    final int page = 1;
    final Pair<String, int> useCaseParams = Pair(MovieCategory.POPULAR, page);

    useCaseWithParams.execute(useCaseParams);

    verify(mockMovieRepository.getMovies(MovieCategory.POPULAR, page));
  });
}
