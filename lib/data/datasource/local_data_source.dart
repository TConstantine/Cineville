import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';

abstract class LocalDataSource {
  Future<List<GenreModel>> getGenres(List<int> genreIds);
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getUpcomingMovies();
  Future storeGenres(List<GenreModel> genreDaos);
  Future storePopularMovies(List<MovieModel> movieDaos);
  Future storeTopRatedMovies(List<MovieModel> movieDaos);
  Future storeUpcomingMovies(List<MovieModel> movieDaos);
}
