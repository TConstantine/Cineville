import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:popular_movies/data/datasource/remote_data_source.dart';
import 'package:popular_movies/data/error/exception/server_exception.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/data/network/tmdb_api_constant.dart';
import 'package:popular_movies/data/network/tmdb_api_key.dart';

class TmdbApi implements RemoteDataSource {
  final http.Client _httpClient;

  TmdbApi(this._httpClient);

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.POPULAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> moviesJson = json.decode(response.body)['results'];
    final List<MovieModel> movieDaos = [];
    moviesJson.forEach((movieJson) => movieDaos.add(MovieModel.fromJson(movieJson)));
    return movieDaos;
  }

  @override
  Future<List<GenreModel>> getMovieGenres() async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> genresJson = json.decode(response.body)['genres'];
    final List<GenreModel> genreDaos = [];
    genresJson.forEach((genreJson) => genreDaos.add(GenreModel.fromJson(genreJson)));
    return genreDaos;
  }

  Future<http.Response> _getHttpResponse(String url) async {
    final http.Response response = await _httpClient.get(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  }
}
