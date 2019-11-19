import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_movie_builder.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  MockMovieRepository _mockMovieRepository;
  UseCase _useCase;

  setUp(() {
    _mockMovieRepository = MockMovieRepository();
    _useCase = GetTopRatedMovies(_mockMovieRepository);
  });

  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
  final int testPage = 1;

  test('should retrieve top rated movies from the repository', () async {
    when(_mockMovieRepository.getTopRatedMovies(any)).thenAnswer((_) async => Right(testMovies));

    final Either<Failure, List<Movie>> movies = await _useCase.execute(testPage);

    expect(movies, Right(testMovies));
    verify(_mockMovieRepository.getTopRatedMovies(testPage));
    verifyNoMoreInteractions(_mockMovieRepository);
  });
}
