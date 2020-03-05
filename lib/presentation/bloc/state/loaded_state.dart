import 'package:cineville/presentation/bloc/bloc_state.dart';

class LoadedState<E> extends BlocState {
  final E loadedData;

  LoadedState(this.loadedData);

  @override
  List<Object> get props => [loadedData];
}
