import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';

abstract class RemoteDataSource {
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<List<GenreModel>> getMovieGenres();
}
