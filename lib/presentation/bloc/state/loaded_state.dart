import 'package:cineville/presentation/bloc/bloc_state.dart';

class LoadedState<E> extends BlocState {
  final List<E> entities;

  LoadedState(this.entities);

  @override
  List<Object> get props => [entities];
}
