import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ActorModel extends Equatable {
  final int id;
  final String name;
  final String profileImage;
  final String character;
  final int displayOrder;

  ActorModel({
    @required this.id,
    @required this.name,
    @required this.profileImage,
    @required this.character,
    @required this.displayOrder,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_path'] ?? '',
      character: json['character'],
      displayOrder: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profileImage,
      'character': character,
      'order': displayOrder,
    };
  }

  @override
  List<Object> get props {
    return [id, name, profileImage, character, displayOrder];
  }
}
