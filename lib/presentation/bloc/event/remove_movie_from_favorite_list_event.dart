import 'package:cineville/presentation/bloc/bloc_event.dart';

class RemoveMovieFromFavoriteListEvent extends BlocEvent {
  final int movieId;

  RemoveMovieFromFavoriteListEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
