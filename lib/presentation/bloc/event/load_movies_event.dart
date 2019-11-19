import 'package:cineville/presentation/bloc/movies_event.dart';

class LoadMoviesEvent extends MoviesEvent {
  final int page;

  LoadMoviesEvent(this.page);

  @override
  List<Object> get props => [page];
}
