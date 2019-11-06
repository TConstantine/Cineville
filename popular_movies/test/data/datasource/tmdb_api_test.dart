import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/data/datasource/remote_data_source.dart';
import 'package:popular_movies/data/datasource/tmdb_api.dart';
import 'package:popular_movies/data/error/exception/server_exception.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/data/network/tmdb_api_constant.dart';
import 'package:popular_movies/data/network/tmdb_api_key.dart';

import '../../builder/genre_model_builder.dart';
import '../../builder/movie_model_builder.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient _mockHttpClient;
  RemoteDataSource _dataSource;

  setUp(() {
    _mockHttpClient = MockHttpClient();
    _dataSource = TmdbApi(_mockHttpClient);
  });

  group('getPopularMovies', () {
    final int testPage = 1;
    final String testMovieModelsJson =
        json.encode({'results': List.generate(3, (_) => MovieModelBuilder().buildJson())});
    final List<MovieModel> testMovieModels = List.generate(3, (_) => MovieModelBuilder().build());

    test('should perform a GET request on popular movies endpoint', () async {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      _dataSource.getPopularMovies(testPage);

      verify(_mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.POPULAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
    });

    test('should return movie daos when the response code is 200 (successful)', () async {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));

      final List<MovieModel> movieModels = await _dataSource.getPopularMovies(testPage);

      expect(movieModels, testMovieModels);
    });

    test('should throw a server exception when the response code is not 200', () {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final Function call = _dataSource.getPopularMovies;

      expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getMovieGenres', () {
    final String testGenreModelsJson =
        json.encode({'genres': List.generate(3, (_) => GenreModelBuilder().buildJson())});
    final List<GenreModel> testGenreModels = List.generate(3, (_) => GenreModelBuilder().build());

    test('should perform a GET request on movie genres endpoint', () async {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testGenreModelsJson, 200));

      _dataSource.getMovieGenres();

      verify(_mockHttpClient.get(
          '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
    });

    test('should return genre daos when the response code is 200 (successful)', () async {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(testGenreModelsJson, 200));

      final List<GenreModel> genreModels = await _dataSource.getMovieGenres();

      expect(genreModels, testGenreModels);
    });

    test('should throw a server exception when the response code is not 200', () {
      when(_mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final Function call = _dataSource.getMovieGenres;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
