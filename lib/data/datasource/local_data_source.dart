import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';

abstract class LocalDataSource {
  Future<List<ActorModel>> getMovieActors(int movieId);
  Future<List<GenreModel>> getMovieGenres(List<int> genreIds);
  Future<List<ReviewModel>> getMovieReviews(int movieId);
  Future<List<VideoModel>> getMovieVideos(int movieId);
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getSimilarMovies(int movieId);
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getUpcomingMovies();
  Future removePopularMovies();
  Future removeSimilarMovies(int movieId);
  Future removeTopRatedMovies();
  Future removeUpcomingMovies();
  Future storeMovieGenres(List<GenreModel> models);
  Future storeMovieActors(int movieId, List<ActorModel> actorModels);
  Future storeMovieReviews(int movieId, List<ReviewModel> reviewModels);
  Future storeMovieVideos(int movieId, List<VideoModel> videoModels);
  Future storePopularMovies(List<MovieModel> movieModels);
  Future storeSimilarMovies(int movieId, List<MovieModel> movieModels);
  Future storeTopRatedMovies(List<MovieModel> movieModels);
  Future storeUpcomingMovies(List<MovieModel> movieModels);
}
