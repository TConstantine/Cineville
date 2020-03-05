import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/data/repository/favorite_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockMovieDomainEntityMapper extends Mock implements MovieDomainEntityMapper {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  DataEntityBuilder movieDataEntityBuilder;
  DataEntityBuilder genreDataEntityBuilder;
  DatabaseDataSource mockDatabaseDataSource;
  MovieDomainEntityMapper mockMovieDomainEntityMapper;
  FavoriteRepository favoriteRepository;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    movieDataEntityBuilder = MovieDataEntityBuilder();
    genreDataEntityBuilder = GenreDataEntityBuilder();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockMovieDomainEntityMapper = MockMovieDomainEntityMapper();
    favoriteRepository = FavoriteDepository(mockDatabaseDataSource, mockMovieDomainEntityMapper);
  });

  test('should return favorite movies from database data source', () async {
    final List<DataEntity> testFavoriteMovieModels = movieDataEntityBuilder.buildList();
    final List<DataEntity> testGenreModels = genreDataEntityBuilder.buildList();
    final List<Movie> testFavoriteMovies = movieDomainEntityBuilder.buildList();
    when(mockDatabaseDataSource.getMovies(any)).thenAnswer((_) async => testFavoriteMovieModels);
    when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);
    when(mockMovieDomainEntityMapper.map(any, any)).thenReturn(testFavoriteMovies);

    final Either<Failure, List<Movie>> result = await favoriteRepository.getMovies();

    verify(mockDatabaseDataSource.getMovies(MovieCategory.FAVORITE));
    expect(result.isRight(), true);
    expect(result.getOrElse(null), testFavoriteMovies);
  });

  test('should return no data failure when database data source has no favorite movies', () async {
    when(mockDatabaseDataSource.getMovies(any)).thenAnswer((_) async => <MovieDataEntity>[]);

    final Either<Failure, List<Movie>> result = await favoriteRepository.getMovies();

    expect(result, Left(NoDataFailure()));
  });

  test('should check database data source if movie is marked as favorite', () async {
    final movieId = 1;

    await favoriteRepository.isMovieMarkedAsFavorite(movieId);

    verify(mockDatabaseDataSource.isMovieMarkedAsFavorite(movieId));
  });

  test('should mark movie as favorite', () async {
    final int movieId = 1;

    await favoriteRepository.markMovieAsFavorite(movieId);

    verify(mockDatabaseDataSource.markMovieAsFavorite(movieId));
  });

  test('should remove movie from favorites', () async {
    final movieId = 1;

    await favoriteRepository.removeMovieFromFavorites(movieId);

    verify(mockDatabaseDataSource.removeMovieFromFavorites(movieId));
  });
}
