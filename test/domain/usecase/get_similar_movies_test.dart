import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_similar_movies.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_movie_builder.dart';

class MockRepository extends Mock implements MovieRepository {}

void main() {
  MovieRepository mockRepository;
  UseCase<Movie> useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = GetSimilarMovies(mockRepository);
  });

  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
  final int testMovieId = 100;

  test('should retrieve similar movies for a specific movie from the movie repository', () async {
    when(mockRepository.getSimilarMovies(any)).thenAnswer((_) async => Right(testMovies));

    final Either<Failure, List<Movie>> result = await useCase.execute(testMovieId);

    expect(result, Right(testMovies));
    verify(mockRepository.getSimilarMovies(testMovieId));
    verifyNoMoreInteractions(mockRepository);
  });
}
