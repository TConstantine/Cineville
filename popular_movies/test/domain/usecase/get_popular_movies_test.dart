import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';
import 'package:popular_movies/domain/usecase/get_popular_movies.dart';

import '../../builder/movie_builder.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  MockMovieRepository _mockMovieRepository;
  GetPopularMovies _useCase;

  setUp(() {
    _mockMovieRepository = MockMovieRepository();
    _useCase = GetPopularMovies(_mockMovieRepository);
  });

  final List<Movie> testMovies = [
    MovieBuilder().build(),
    MovieBuilder().build(),
    MovieBuilder().build(),
  ];
  final int testPage = 1;

  test('should retrieve the most popular movies from the repository', () async {
    when(_mockMovieRepository.getPopularMovies(any)).thenAnswer((_) async => Right(testMovies));

    final Either<Failure, List<Movie>> movies = await _useCase.execute(testPage);

    expect(movies, Right(testMovies));
    verify(_mockMovieRepository.getPopularMovies(testPage));
    verifyNoMoreInteractions(_mockMovieRepository);
  });
}
