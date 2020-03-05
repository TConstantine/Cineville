import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadMoviesEvent extends BlocEvent {
  final String movieCategory;
  final int page;

  LoadMoviesEvent(this.movieCategory, this.page);

  @override
  List<Object> get props => [movieCategory, page];
}
