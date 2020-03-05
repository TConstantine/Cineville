import 'package:cineville/data/entity/data_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ActorDataEntity extends Equatable implements DataEntity {
  final int id;
  final String name;
  final String profileImage;
  final String character;
  final int displayOrder;

  ActorDataEntity({
    @required this.id,
    @required this.name,
    @required this.profileImage,
    @required this.character,
    @required this.displayOrder,
  });

  factory ActorDataEntity.fromJson(Map<String, dynamic> json) {
    return ActorDataEntity(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_path'] ?? '',
      character: json['character'],
      displayOrder: json['order'],
    );
  }

  @override
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
  List<Object> get props => [id, name, profileImage, character, displayOrder];
}
