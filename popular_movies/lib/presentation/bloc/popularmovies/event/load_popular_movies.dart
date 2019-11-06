import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_event.dart';

class LoadPopularMovies extends PopularMoviesEvent {
  final int page;

  LoadPopularMovies(this.page);

  @override
  List<Object> get props => [page];
}
