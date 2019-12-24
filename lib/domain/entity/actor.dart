import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Actor extends Equatable {
  final int id;
  final String name;
  final String profileUrl;
  final String character;
  final int displayOrder;

  Actor({
    @required this.id,
    @required this.name,
    @required this.profileUrl,
    @required this.character,
    @required this.displayOrder,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      profileUrl,
      character,
      displayOrder,
    ];
  }
}
