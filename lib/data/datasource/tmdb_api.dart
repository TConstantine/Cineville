import 'dart:convert';

import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:http/http.dart' as http;

class TmdbApi implements RemoteDataSource {
  final http.Client _httpClient;

  TmdbApi(this._httpClient);

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

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    return await _getMovies(TmdbApiConstant.POPULAR_MOVIES_ENDPOINT, page);
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies(int page) async {
    return await _getMovies(TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT, page);
  }

  Future<List<MovieModel>> _getMovies(String endpoint, int page) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}$endpoint?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> moviesJson = json.decode(response.body)['results'];
    final List<MovieModel> movieDaos = [];
    moviesJson.forEach((movieJson) => movieDaos.add(MovieModel.fromJson(movieJson)));
    return movieDaos;
  }

  Future<http.Response> _getHttpResponse(String url) async {
    final http.Response response = await _httpClient.get(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  }
}
