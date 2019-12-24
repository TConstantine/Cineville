import 'package:cineville/presentation/bloc/bloc_state.dart';

class ErrorState extends BlocState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
