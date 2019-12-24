import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_movie_builder.dart';

class MockRepository extends Mock implements MovieRepository {}

void main() {
  MockRepository mockRepository;
  UseCase<Movie> useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = GetTopRatedMovies(mockRepository);
  });

  final List<Movie> testMovies = TestMovieBuilder().buildMultiple();
  final int testPage = 1;

  test('should retrieve top rated movies from the movie repository', () async {
    when(mockRepository.getTopRatedMovies(any)).thenAnswer((_) async => Right(testMovies));

    final Either<Failure, List<Movie>> result = await useCase.execute(testPage);

    expect(result, Right(testMovies));
    verify(mockRepository.getTopRatedMovies(testPage));
    verifyNoMoreInteractions(mockRepository);
  });
}
