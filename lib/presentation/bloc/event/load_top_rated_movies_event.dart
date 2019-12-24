import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadTopRatedMoviesEvent extends BlocEvent {
  final int page;

  LoadTopRatedMoviesEvent(this.page);

  @override
  List<Object> get props => [page];
}
