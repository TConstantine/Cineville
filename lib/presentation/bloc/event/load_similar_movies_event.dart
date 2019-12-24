import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadSimilarMoviesEvent extends BlocEvent {
  final int movieId;

  LoadSimilarMoviesEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
