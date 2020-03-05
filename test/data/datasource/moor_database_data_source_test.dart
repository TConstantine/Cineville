import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/moor_database_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/actor_data_entity_builder.dart';
import '../../builder/data_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/genre_id_builder.dart';
import '../../builder/movie_data_entity_builder.dart';
import '../../builder/review_data_entity_builder.dart';
import '../../builder/video_data_entity_builder.dart';

class MockMovieDao extends Mock implements MovieDao {}

class MockGenreDao extends Mock implements GenreDao {}

class MockActorDao extends Mock implements ActorDao {}

class MockReviewDao extends Mock implements ReviewDao {}

class MockVideoDao extends Mock implements VideoDao {}

void main() {
  DataEntityBuilder movieDataEntityBuilder;
  DataEntityBuilder genreDataEntityBuilder;
  DataEntityBuilder actorDataEntityBuilder;
  DataEntityBuilder reviewDataEntityBuilder;
  DataEntityBuilder videoDataEntityBuilder;
  MovieDao mockMovieDao;
  GenreDao mockGenreDao;
  ActorDao mockActorDao;
  ReviewDao mockReviewDao;
  VideoDao mockVideoDao;
  DatabaseDataSource databaseDataSource;

  setUp(() {
    movieDataEntityBuilder = MovieDataEntityBuilder();
    genreDataEntityBuilder = GenreDataEntityBuilder();
    actorDataEntityBuilder = ActorDataEntityBuilder();
    reviewDataEntityBuilder = ReviewDataEntityBuilder();
    videoDataEntityBuilder = VideoDataEntityBuilder();
    mockMovieDao = MockMovieDao();
    mockActorDao = MockActorDao();
    mockGenreDao = MockGenreDao();
    mockReviewDao = MockReviewDao();
    mockVideoDao = MockVideoDao();
    databaseDataSource = MoorDatabaseDataSource(
      mockMovieDao,
      mockGenreDao,
      mockActorDao,
      mockReviewDao,
      mockVideoDao,
    );
  });

  group('getMovieDataEntities', () {
    int movieId;

    setUp(() {
      movieId = 1;
    });

    void getMovieDataEntities(
      String dataEntityType,
      Function expectedDaoFunctionCall,
    ) {
      test('should return $dataEntityType from $dataEntityType dao', () async {
        await databaseDataSource.getMovieDataEntities(dataEntityType, movieId);

        verify(expectedDaoFunctionCall());
      });
    }

    getMovieDataEntities(DataEntityType.ACTOR, () => mockActorDao.getMovieActors(movieId));
    getMovieDataEntities(DataEntityType.REVIEW, () => mockReviewDao.getMovieReviews(movieId));
    getMovieDataEntities(
        DataEntityType.SIMILAR_MOVIE, () => mockMovieDao.getSimilarMovies(movieId));
    getMovieDataEntities(DataEntityType.VIDEO, () => mockVideoDao.getMovieVideos(movieId));
  });

  test('should return genres from genre dao', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
    when(mockGenreDao.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);

    await databaseDataSource.getMovieGenres(genreIds);

    verify(mockGenreDao.getMovieGenres(genreIds));
  });

  test('should return movies from movie dao', () async {
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    when(mockMovieDao.getMovies(any)).thenAnswer((_) async => movieDataEntities);

    await databaseDataSource.getMovies(MovieCategory.POPULAR);

    verify(mockMovieDao.getMovies(MovieCategory.POPULAR));
  });

  test('should check if movie is marked as favorite', () async {
    final int movieId = 1;

    await databaseDataSource.isMovieMarkedAsFavorite(movieId);

    verify(mockMovieDao.isMovieMarkedAsFavorite(movieId));
  });

  test('should mark movie as favorite', () async {
    final int movieId = 1;

    await databaseDataSource.markMovieAsFavorite(movieId);

    verify(mockMovieDao.markMovieAsFavorite(movieId));
  });

  test('should remove movie from favorites', () async {
    final int movieId = 1;

    await databaseDataSource.removeMovieFromFavorites(movieId);

    verify(mockMovieDao.removeMovieFromFavorites(movieId));
  });

  test('should remove movies from the database', () {
    databaseDataSource.removeMovies(MovieCategory.POPULAR);

    verify(mockMovieDao.removeMovies(MovieCategory.POPULAR));
  });

  test('should remove similar movies from the database', () {
    final int movieId = 1;

    databaseDataSource.removeSimilarMovies(movieId);

    verify(mockMovieDao.removeSimilarMovies(movieId));
  });

  test('should store genres in database', () {
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    databaseDataSource.storeMovieGenres(genreDataEntities);

    verify(mockGenreDao.storeMovieGenres(genreDataEntities));
  });

  group('storeMovieDataEntities', () {
    int movieId;

    setUp(() {
      movieId = 1;
    });

    void storeMovieDataEntities(
      String dataEntityType,
      DataEntityBuilder dataEntityBuilder,
      Function expectedDaoFunctionCall,
    ) {
      test('should store $dataEntityType data entities in database', () async {
        final List<DataEntity> dataEntities = dataEntityBuilder.buildList();

        databaseDataSource.storeMovieDataEntities(dataEntityType, movieId, dataEntities);

        verify(expectedDaoFunctionCall());
      });
    }

    storeMovieDataEntities(
      DataEntityType.ACTOR,
      ActorDataEntityBuilder(),
      () => mockActorDao.storeMovieActors(movieId, actorDataEntityBuilder.buildList()),
    );
    storeMovieDataEntities(
      DataEntityType.REVIEW,
      ReviewDataEntityBuilder(),
      () => mockReviewDao.storeMovieReviews(movieId, reviewDataEntityBuilder.buildList()),
    );
    storeMovieDataEntities(
      DataEntityType.SIMILAR_MOVIE,
      MovieDataEntityBuilder(),
      () => mockMovieDao.storeSimilarMovies(movieId, movieDataEntityBuilder.buildList()),
    );
    storeMovieDataEntities(
      DataEntityType.VIDEO,
      VideoDataEntityBuilder(),
      () => mockVideoDao.storeMovieVideos(movieId, videoDataEntityBuilder.buildList()),
    );
  });

  test('should store movies in database', () {
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();

    databaseDataSource.storeMovies(MovieCategory.POPULAR, movieDataEntities);

    verify(mockMovieDao.storeMovies(MovieCategory.POPULAR, movieDataEntities));
  });
}
