import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/moor_database.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_actor_model_builder.dart';
import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_model_builder.dart';
import '../../test_util/test_review_model_builder.dart';
import '../../test_util/test_video_model_builder.dart';

class MockMovieDao extends Mock implements MovieDao {}

class MockGenreDao extends Mock implements GenreDao {}

class MockActorDao extends Mock implements ActorDao {}

class MockReviewDao extends Mock implements ReviewDao {}

class MockVideoDao extends Mock implements VideoDao {}

void main() {
  MovieDao mockMovieDao;
  GenreDao mockGenreDao;
  ActorDao mockActorDao;
  ReviewDao mockReviewDao;
  VideoDao mockVideoDao;
  LocalDataSource localDataSource;

  setUp(() {
    mockMovieDao = MockMovieDao();
    mockActorDao = MockActorDao();
    mockGenreDao = MockGenreDao();
    mockReviewDao = MockReviewDao();
    mockVideoDao = MockVideoDao();
    localDataSource = MoorDatabase(
      mockMovieDao,
      mockGenreDao,
      mockActorDao,
      mockReviewDao,
      mockVideoDao,
    );
  });

  final int testMovieId = 100;
  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final List<GenreModel> testGenreModels = TestGenreModelBuilder().buildMultiple();
  final List<ActorModel> testActorModels = TestActorModelBuilder().buildMultiple();
  final List<ReviewModel> testReviewModels = TestReviewModelBuilder().buildMultiple();
  final List<VideoModel> testVideoModels = TestVideoModelBuilder().buildMultiple();
  final List<int> testGenreIds = [1, 2, 3];

  group('getMovieActors', () {
    test('should return a list of actor models from the database', () async {
      when(mockActorDao.getMovieActors(any)).thenAnswer((_) async => testActorModels);

      final List<ActorModel> actorModels = await localDataSource.getMovieActors(testMovieId);

      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockActorDao.getMovieActors(testMovieId));
      verifyNoMoreInteractions(mockActorDao);
      expect(actorModels, equals(testActorModels));
    });
  });

  group('getMovieGenres', () {
    test('should return a list of genre models from the database', () async {
      when(mockGenreDao.getMovieGenres(any)).thenAnswer((_) async => testGenreModels);

      final List<GenreModel> genreModels = await localDataSource.getMovieGenres(testGenreIds);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockGenreDao.getMovieGenres(testGenreIds));
      verifyNoMoreInteractions(mockGenreDao);
      expect(genreModels, equals(testGenreModels));
    });
  });

  group('getMovieReviews', () {
    test('should return a list of review models from the database', () async {
      when(mockReviewDao.getMovieReviews(any)).thenAnswer((_) async => testReviewModels);

      final List<ReviewModel> models = await localDataSource.getMovieReviews(testMovieId);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockReviewDao.getMovieReviews(testMovieId));
      verifyNoMoreInteractions(mockReviewDao);
      expect(models, equals(testReviewModels));
    });
  });

  group('getMovieVideos', () {
    test('should return a list of video models from the database', () async {
      when(mockVideoDao.getMovieVideos(any)).thenAnswer((_) async => testVideoModels);

      final List<VideoModel> videoModels = await localDataSource.getMovieVideos(testMovieId);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verify(mockVideoDao.getMovieVideos(testMovieId));
      verifyNoMoreInteractions(mockVideoDao);
      expect(videoModels, equals(testVideoModels));
    });
  });

  group('getPopularMovies', () {
    test('should return a list of movie models from the database', () async {
      when(mockMovieDao.getPopularMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await localDataSource.getPopularMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.getPopularMovies());
      verifyNoMoreInteractions(mockMovieDao);
      expect(movieModels, equals(testMovieModels));
    });
  });

  group('getSimilarMovies', () {
    test('should return a list of movie models from the database', () async {
      when(mockMovieDao.getSimilarMovies(any)).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> models = await localDataSource.getSimilarMovies(testMovieId);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.getSimilarMovies(testMovieId));
      verifyNoMoreInteractions(mockMovieDao);
      expect(models, equals(testMovieModels));
    });
  });

  group('getTopRatedMovies', () {
    test('should return a list of movie models from the database', () async {
      when(mockMovieDao.getTopRatedMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await localDataSource.getTopRatedMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.getTopRatedMovies());
      verifyNoMoreInteractions(mockMovieDao);
      expect(movieModels, equals(testMovieModels));
    });
  });

  group('getUpcomingMovies', () {
    test('should return a list of movie models from the database', () async {
      when(mockMovieDao.getUpcomingMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await localDataSource.getUpcomingMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.getUpcomingMovies());
      verifyNoMoreInteractions(mockMovieDao);
      expect(movieModels, equals(testMovieModels));
    });
  });

  group('removePopularMovies', () {
    test('should clear popular movies from the database', () {
      localDataSource.removePopularMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.removePopularMovies());
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('removeSimilarMovies', () {
    test('should clear similar movies from the database', () {
      localDataSource.removeSimilarMovies(testMovieId);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.removeSimilarMovies(testMovieId));
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('removeTopRatedMovies', () {
    test('should clear top rated movies from the database', () {
      localDataSource.removeTopRatedMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.removeTopRatedMovies());
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('removeUpcomingMovies', () {
    test('should clear upcoming movies from the database', () {
      localDataSource.removeUpcomingMovies();

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.removeUpcomingMovies());
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('storeMovieGenres', () {
    test('should store genres in database', () {
      localDataSource.storeMovieGenres(testGenreModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockGenreDao.storeMovieGenres(testGenreModels));
      verifyNoMoreInteractions(mockGenreDao);
    });
  });

  group('storeMovieActors', () {
    test('should store movie actors in database', () {
      localDataSource.storeMovieActors(testMovieId, testActorModels);

      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockActorDao.storeMovieActors(testMovieId, testActorModels));
      verifyNoMoreInteractions(mockActorDao);
    });
  });

  group('storeMovieReviews', () {
    test('should store movie reviews in database', () {
      localDataSource.storeMovieReviews(testMovieId, testReviewModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockReviewDao.storeMovieReviews(testMovieId, testReviewModels));
      verifyNoMoreInteractions(mockReviewDao);
    });
  });

  group('storeMovieVideos', () {
    test('should store movie videos in database', () {
      localDataSource.storeMovieVideos(testMovieId, testVideoModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockMovieDao);
      verifyZeroInteractions(mockReviewDao);
      verify(mockVideoDao.storeMovieVideos(testMovieId, testVideoModels));
      verifyNoMoreInteractions(mockVideoDao);
    });
  });

  group('storePopularMovies', () {
    test('should store popular movies in database', () {
      localDataSource.storePopularMovies(testMovieModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.storePopularMovies(testMovieModels));
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('storeSimilarMovies', () {
    test('should store similar movies in database', () {
      localDataSource.storeSimilarMovies(testMovieId, testMovieModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.storeSimilarMovies(testMovieId, testMovieModels));
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('storeTopRatedMovies', () {
    test('should store top rated movies in database', () {
      localDataSource.storeTopRatedMovies(testMovieModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.storeTopRatedMovies(testMovieModels));
      verifyNoMoreInteractions(mockMovieDao);
    });
  });

  group('storeUpcomingMovies', () {
    test('should store upcoming movies in database', () {
      localDataSource.storeUpcomingMovies(testMovieModels);

      verifyZeroInteractions(mockActorDao);
      verifyZeroInteractions(mockGenreDao);
      verifyZeroInteractions(mockReviewDao);
      verifyZeroInteractions(mockVideoDao);
      verify(mockMovieDao.storeUpcomingMovies(testMovieModels));
      verifyNoMoreInteractions(mockMovieDao);
    });
  });
}
