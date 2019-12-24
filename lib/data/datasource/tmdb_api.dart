import 'dart:convert';

import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:http/http.dart' as http;

class TmdbApi implements RemoteDataSource {
  final http.Client httpClient;

  TmdbApi(this.httpClient);

  @override
  Future<List<GenreModel>> getMovieGenres() async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> genresJson = json.decode(response.body)['genres'];
    final List<GenreModel> genreModels = [];
    genresJson.forEach((genreJson) => genreModels.add(GenreModel.fromJson(genreJson)));
    return genreModels;
  }

  @override
  Future<List<ActorModel>> getMovieActors(int movieId) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.ACTORS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> actorsJson = json.decode(response.body)['cast'];
    final List<ActorModel> actorModels = [];
    actorsJson.forEach((actorJson) => actorModels.add(ActorModel.fromJson(actorJson)));
    return actorModels;
  }

  @override
  Future<List<ReviewModel>> getMovieReviews(int movieId) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.REVIEWS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> reviewsJson = json.decode(response.body)['results'];
    final List<ReviewModel> reviewModels = [];
    reviewsJson.forEach((reviewJson) => reviewModels.add(ReviewModel.fromJson(reviewJson)));
    return reviewModels;
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.VIDEOS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> videosJson = json.decode(response.body)['results'];
    final List<VideoModel> videoModels = [];
    videosJson.forEach((videoJson) => videoModels.add(VideoModel.fromJson(videoJson)));
    return videoModels;
  }

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    return await _getMovies(TmdbApiConstant.POPULAR_MOVIES_ENDPOINT, page);
  }

  @override
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    return await _getMovies(
        '${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.SIMILAR_MOVIES_ENDPOINT}', 1);
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies(int page) async {
    return await _getMovies(TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT, page);
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies(int page) async {
    return await _getMovies(TmdbApiConstant.UPCOMING_MOVIES_ENDPOINT, page);
  }

  Future<List<MovieModel>> _getMovies(String endpoint, int page) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}$endpoint?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> moviesJson = json.decode(response.body)['results'];
    final List<MovieModel> movieModels = [];
    moviesJson.forEach((movieJson) => movieModels.add(MovieModel.fromJson(movieJson)));
    return movieModels;
  }

  Future<http.Response> _getHttpResponse(String url) async {
    final http.Response response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  }
}
