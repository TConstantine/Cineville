import 'package:cineville/presentation/bloc/bloc_event.dart';

class IsFavoriteMovieEvent extends BlocEvent {
  final int movieId;

  IsFavoriteMovieEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
