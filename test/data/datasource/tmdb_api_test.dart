import 'dart:convert';

import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_api.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_actor_model_builder.dart';
import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_model_builder.dart';
import '../../test_util/test_review_model_builder.dart';
import '../../test_util/test_video_model_builder.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  RemoteDataSource remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = TmdbApi(mockHttpClient);
  });

  final int testPage = 1;
  final int testMovieId = 100;
  final String testMovieModelsJson =
      json.encode({'results': TestMovieModelBuilder().buildMultipleJson()});
  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final String testGenreModelsJson =
      json.encode({'genres': TestGenreModelBuilder().buildMultipleJson()});
  final List<GenreModel> testGenreModels = TestGenreModelBuilder().buildMultiple();
  final List<ActorModel> testActorModels = TestActorModelBuilder().buildMultiple();
  final List<ReviewModel> testReviewModels = TestReviewModelBuilder().buildMultiple();
  final List<VideoModel> testVideoModels = TestVideoModelBuilder().buildMultiple();
  final String testActorModelsJson =
      json.encode({'cast': TestActorModelBuilder().buildMultipleJson()});
  final String testReviewModelsJson =
      json.encode({'results': TestReviewModelBuilder().buildMultipleJson()});
  final String testVideoModelsJson =
      json.encode({'results': TestVideoModelBuilder().buildMultipleJson()});

  group('getMovieGenres', () {
    test('should perform GET request on movie genres endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testGenreModelsJson, 200));

      remoteDataSource.getMovieGenres();

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
    });

    test('should return genre daos', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testGenreModelsJson, 200));

      final List<GenreModel> genreModels = await remoteDataSource.getMovieGenres();

      expect(genreModels, testGenreModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getMovieGenres;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getMovieActors', () {
    test('should perform GET request on actors endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testActorModelsJson, 200));

      remoteDataSource.getMovieActors(testMovieId);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$testMovieId${TmdbApiConstant.ACTORS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
    });

    test('should return actor models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testActorModelsJson, 200));

      final List<ActorModel> models = await remoteDataSource.getMovieActors(testMovieId);

      expect(models, testActorModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getMovieActors;

      expect(() => call(testMovieId), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getMovieReviews', () {
    test('should perform GET request on reviews endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testReviewModelsJson, 200));

      remoteDataSource.getMovieReviews(testMovieId);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$testMovieId${TmdbApiConstant.REVIEWS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
    });

    test('should return review models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testReviewModelsJson, 200));

      final List<ReviewModel> models = await remoteDataSource.getMovieReviews(testMovieId);

      expect(models, testReviewModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getMovieReviews;

      expect(() => call(testMovieId), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getMovieVideos', () {
    test('should perform GET request on videos endpoint', () {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testVideoModelsJson, 200));

      remoteDataSource.getMovieVideos(testMovieId);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$testMovieId${TmdbApiConstant.VIDEOS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
      verifyNoMoreInteractions(mockHttpClient);
    });

    test('should return video models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testVideoModelsJson, 200));

      final List<VideoModel> videoModels = await remoteDataSource.getMovieVideos(testMovieId);

      expect(videoModels, testVideoModels);
    });
  });

  group('getPopularMovies', () {
    test('should perform GET request on popular movies endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      remoteDataSource.getPopularMovies(testPage);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.POPULAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
    });

    test('should return movie models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      final List<MovieModel> models = await remoteDataSource.getPopularMovies(testPage);

      expect(models, testMovieModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getPopularMovies;

      expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getSimilarMovies', () {
    test('should perform GET request on similar movies endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      await remoteDataSource.getSimilarMovies(testMovieId);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$testMovieId${TmdbApiConstant.SIMILAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
    });

    test('should return movie models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      final List<MovieModel> models = await remoteDataSource.getSimilarMovies(testMovieId);

      expect(models, testMovieModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getSimilarMovies;

      expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getTopRatedMovies', () {
    test('should perform GET request on top rated movies endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      await remoteDataSource.getTopRatedMovies(testPage);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
    });

    test('should return movie models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      final List<MovieModel> models = await remoteDataSource.getTopRatedMovies(testPage);

      expect(models, testMovieModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getTopRatedMovies;

      expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getUpcomingMovies', () {
    test('should perform GET request on upcoming movies endpoint', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      remoteDataSource.getUpcomingMovies(testPage);

      verify(mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.UPCOMING_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
    });

    test('should return movie models', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      final List<MovieModel> models = await remoteDataSource.getUpcomingMovies(testPage);

      expect(models, testMovieModels);
    });

    test('should throw server exception', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      final Function call = remoteDataSource.getUpcomingMovies;

      expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
