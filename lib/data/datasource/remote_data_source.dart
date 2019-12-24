import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';

abstract class RemoteDataSource {
  Future<List<GenreModel>> getMovieGenres();
  Future<List<ActorModel>> getMovieActors(int movieId);
  Future<List<ReviewModel>> getMovieReviews(int movieId);
  Future<List<VideoModel>> getMovieVideos(int movieId);
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<List<MovieModel>> getSimilarMovies(int movieId);
  Future<List<MovieModel>> getTopRatedMovies(int page);
  Future<List<MovieModel>> getUpcomingMovies(int page);
}
