import 'package:cineville/presentation/bloc/movies_state.dart';

class ErrorState extends MoviesState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
