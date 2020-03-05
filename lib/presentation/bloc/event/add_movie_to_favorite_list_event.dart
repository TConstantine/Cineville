import 'package:cineville/presentation/bloc/bloc_event.dart';

class AddMovieToFavoriteListEvent extends BlocEvent {
  final int movieId;

  AddMovieToFavoriteListEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
