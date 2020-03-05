import 'package:cineville/presentation/bloc/bloc_state.dart';

class RemovedState extends BlocState {
  final String message;

  RemovedState(this.message);

  @override
  List<Object> get props => [message];
}
