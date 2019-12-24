import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadMovieReviewsEvent extends BlocEvent {
  final int movieId;

  LoadMovieReviewsEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
