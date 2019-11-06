import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_state.dart';

class Loaded extends PopularMoviesState {
  final List<Movie> movies;

  Loaded(this.movies);

  @override
  List<Object> get props => [movies];
}
