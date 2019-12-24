import 'package:cineville/presentation/bloc/bloc_event.dart';

class LoadUpcomingMoviesEvent extends BlocEvent {
  final int page;

  LoadUpcomingMoviesEvent(this.page);

  @override
  List<Object> get props => [page];
}
