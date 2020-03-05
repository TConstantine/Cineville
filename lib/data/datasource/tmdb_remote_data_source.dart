import 'dart:convert';

import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:http/http.dart' as http;

class TmdbRemoteDataSource implements RemoteDataSource {
  final http.Client _httpClient;

  TmdbRemoteDataSource(this._httpClient);

  @override
  Future<List<DataEntity>> getMovieDataEntities(String dataEntityType, int movieId) async {
    if (dataEntityType == DataEntityType.ACTOR) {
      return _getMovieActors(movieId);
    } else if (dataEntityType == DataEntityType.REVIEW) {
      return _getMovieReviews(movieId);
    } else if (dataEntityType == DataEntityType.SIMILAR_MOVIE) {
      return await _getMovies(
          '${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.SIMILAR_MOVIES_ENDPOINT}', 1);
    } else {
      return _getMovieVideos(movieId);
    }
  }

  @override
  Future<List<DataEntity>> getMovieGenres() async {
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> genreDataEntitiesAsJson = json.decode(response.body)['genres'];
    final List<DataEntity> genreDataEntities = [];
    genreDataEntitiesAsJson.forEach((genreDataEntityAsJson) {
      genreDataEntities.add(GenreDataEntity.fromJson(genreDataEntityAsJson));
    });
    return genreDataEntities;
  }

  @override
  Future<List<DataEntity>> getMovies(String movieCategory, int page) {
    String endpoint;
    if (movieCategory == MovieCategory.POPULAR) {
      endpoint = TmdbApiConstant.POPULAR_MOVIES_ENDPOINT;
    } else if (movieCategory == MovieCategory.TOP_RATED) {
      endpoint = TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT;
    } else {
      endpoint = TmdbApiConstant.UPCOMING_MOVIES_ENDPOINT;
    }
    return _getMovies(endpoint, page);
  }

  Future<http.Response> _getHttpResponse(String url) async {
    final http.Response response = await _httpClient.get(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return response;
  }

  Future<List<DataEntity>> _getMovieActors(int movieId) async {
    final List<DataEntity> actorDataEntities = [];
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.ACTORS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> actorDataEntitiesAsJson = json.decode(response.body)['cast'];
    actorDataEntitiesAsJson.forEach((actorDataEntityAsJson) {
      actorDataEntities.add(ActorDataEntity.fromJson(actorDataEntityAsJson));
    });
    return actorDataEntities;
  }

  Future<List<DataEntity>> _getMovieReviews(int movieId) async {
    final List<DataEntity> reviewDataEntities = [];
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.REVIEWS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> reviewDataEntitiesAsJson = json.decode(response.body)['results'];
    reviewDataEntitiesAsJson.forEach((reviewDataEntityAsJson) {
      reviewDataEntities.add(ReviewDataEntity.fromJson(reviewDataEntityAsJson));
    });
    return reviewDataEntities;
  }

  Future<List<DataEntity>> _getMovies(String endpoint, int page) async {
    final String url =
        '${TmdbApiConstant.BASE_URL}$endpoint?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> movieDataEntitiesAsJson = json.decode(response.body)['results'];
    final List<DataEntity> movieDataEntities = [];
    movieDataEntitiesAsJson.forEach((movieDataEntityAsJson) {
      movieDataEntities.add(MovieDataEntity.fromJson(movieDataEntityAsJson));
    });
    return movieDataEntities;
  }

  Future<List<DataEntity>> _getMovieVideos(int movieId) async {
    final List<DataEntity> videoDataEntities = [];
    final String url =
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.VIDEOS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY';
    final http.Response response = await _getHttpResponse(url);
    final List<dynamic> videoDataEntitiesAsJson = json.decode(response.body)['results'];
    videoDataEntitiesAsJson.forEach((videoDataEntityAsJson) {
      videoDataEntities.add(VideoDataEntity.fromJson(videoDataEntityAsJson));
    });
    return videoDataEntities;
  }
}
