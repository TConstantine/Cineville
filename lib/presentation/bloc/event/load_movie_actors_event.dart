import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadMovieActorsEvent extends BlocEvent {
  final int movieId;

  LoadMovieActorsEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
