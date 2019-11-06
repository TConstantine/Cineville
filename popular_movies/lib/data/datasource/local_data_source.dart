import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';

abstract class LocalDataSource {
  Future<List<MovieModel>> getPopularMovies();

  Future storePopularMovies(List<MovieModel> movieDaos);

  Future<List<GenreModel>> getGenres(List<int> genreIds);

  Future storeGenres(List<GenreModel> genreDaos);
}
