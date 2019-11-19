import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';

abstract class RemoteDataSource {
  Future<List<GenreModel>> getMovieGenres();
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<List<MovieModel>> getTopRatedMovies(int page);
}
