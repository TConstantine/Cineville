import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadMovieVideosEvent extends BlocEvent {
  final int movieId;

  LoadMovieVideosEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
