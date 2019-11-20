import 'dart:convert';

import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_api.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_model_builder.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient _mockHttpClient;
  RemoteDataSource _dataSource;

  setUp(() {
    _mockHttpClient = MockHttpClient();
    _dataSource = TmdbApi(_mockHttpClient);
  });

  final int testPage = 1;
  final String testMovieModelsJson =
      json.encode({'results': TestMovieModelBuilder().buildMultipleJson()});
  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final String testGenreModelsJson =
      json.encode({'genres': TestGenreModelBuilder().buildJsonMultiple()});
  final List<GenreModel> testGenreModels = TestGenreModelBuilder().buildMultiple();

  void _whenHttpRequestForGenresIsSuccessful(Function body) {
    group('when http request for genres is successful', () {
      setUp(() {
        when(_mockHttpClient.get(any))
            .thenAnswer((_) async => http.Response(testGenreModelsJson, 200));
      });

      body();
    });
  }

  void _whenHttpRequestForMoviesIsSuccessful(Function body) {
    group('when http request for movies is successful', () {
      setUp(() {
        when(_mockHttpClient.get(any))
            .thenAnswer((_) async => http.Response(testMovieModelsJson, 200));
      });

      body();
    });
  }

  void _whenHttpRequestIsUnsuccessful(Function body) {
    group('when http request is unsuccessful', () {
      setUp(() {
        when(_mockHttpClient.get(any))
            .thenAnswer((_) async => http.Response('Something went wrong', 404));
      });

      body();
    });
  }

  group('getMovieGenres', () {
    _whenHttpRequestForGenresIsSuccessful(() {
      test('should perform a GET request on movie genres endpoint', () async {
        _dataSource.getMovieGenres();

        verify(_mockHttpClient.get(
            '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
      });

      test('should return genre daos', () async {
        final List<GenreModel> genreModels = await _dataSource.getMovieGenres();

        expect(genreModels, testGenreModels);
      });
    });

    _whenHttpRequestIsUnsuccessful(() {
      test('should throw a server exception', () {
        final Function call = _dataSource.getMovieGenres;

        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      });
    });
  });

  group('getPopularMovies', () {
    _whenHttpRequestForMoviesIsSuccessful(() {
      test('should perform a GET request on popular movies endpoint', () async {
        _dataSource.getPopularMovies(testPage);

        verify(_mockHttpClient.get(
            '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.POPULAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
      });

      test('should return movie daos', () async {
        final List<MovieModel> movieModels = await _dataSource.getPopularMovies(testPage);

        expect(movieModels, testMovieModels);
      });
    });

    _whenHttpRequestIsUnsuccessful(() {
      test('should throw a server exception', () {
        final Function call = _dataSource.getPopularMovies;

        expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
      });
    });
  });

  group('getTopRatedMovies', () {
    _whenHttpRequestForMoviesIsSuccessful(() {
      test('should perform a GET request on top rated movies endpoint', () async {
        _dataSource.getTopRatedMovies(testPage);

        verify(_mockHttpClient.get(
            '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
      });

      test('should return movie daos', () async {
        final List<MovieModel> movieModels = await _dataSource.getTopRatedMovies(testPage);

        expect(movieModels, testMovieModels);
      });
    });

    _whenHttpRequestIsUnsuccessful(() {
      test('should throw a server exception', () {
        final Function call = _dataSource.getTopRatedMovies;

        expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
      });
    });
  });

  group('getUpcomingMovies', () {
    _whenHttpRequestForMoviesIsSuccessful(() {
      test('should perform a GET request on upcoming movies endpoint', () async {
        _dataSource.getUpcomingMovies(testPage);

        verify(_mockHttpClient.get(
            '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.UPCOMING_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$testPage'));
      });

      test('should return movie daos', () async {
        final List<MovieModel> movieModels = await _dataSource.getUpcomingMovies(testPage);

        expect(movieModels, testMovieModels);
      });
    });

    _whenHttpRequestIsUnsuccessful(() {
      test('should throw a server exception', () {
        final Function call = _dataSource.getUpcomingMovies;

        expect(() => call(testPage), throwsA(TypeMatcher<ServerException>()));
      });
    });
  });
}
