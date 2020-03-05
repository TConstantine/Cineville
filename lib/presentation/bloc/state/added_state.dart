import 'package:cineville/presentation/bloc/bloc_state.dart';

class AddedState extends BlocState {
  final String message;

  AddedState(this.message);

  @override
  List<Object> get props => [message];
}
