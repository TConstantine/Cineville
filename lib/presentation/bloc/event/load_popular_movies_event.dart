import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadPopularMoviesEvent extends BlocEvent {
  final int page;

  LoadPopularMoviesEvent(this.page);

  @override
  List<Object> get props => [page];
}
