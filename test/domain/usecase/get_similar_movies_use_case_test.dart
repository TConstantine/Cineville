import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_similar_movies_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  MovieRepository mockMovieRepository;
  UseCaseWithParams<List<Movie>, int> useCaseWithParams;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockMovieRepository = MockMovieRepository();
    useCaseWithParams = GetSimilarMoviesUseCase(mockMovieRepository);
  });

  test('should retrieve similar movies for a specific movie from the movie repository', () async {
    final int movieId = 1;
    final List<Movie> movieDomainEntities = movieDomainEntityBuilder.buildList();
    when(mockMovieRepository.getSimilarMovies(any))
        .thenAnswer((_) async => Right(movieDomainEntities));

    final Either<Failure, List<Movie>> result = await useCaseWithParams.execute(movieId);

    verify(mockMovieRepository.getSimilarMovies(movieId));
    expect(result, Right(movieDomainEntities));
  });
}
