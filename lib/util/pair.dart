import 'package:equatable/equatable.dart';

class Pair<L, R> extends Equatable {
  final L left;
  final R right;

  Pair(this.left, this.right);

  @override
  List<Object> get props => [left, right];
}
