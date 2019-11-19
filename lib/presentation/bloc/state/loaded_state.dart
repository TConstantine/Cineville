import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/movies_state.dart';

class LoadedState extends MoviesState {
  final List<Movie> movies;

  LoadedState(this.movies);

  @override
  List<Object> get props => [movies];
}
