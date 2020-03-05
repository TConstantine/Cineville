import 'package:cineville/data/entity/data_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GenreDataEntity extends Equatable implements DataEntity {
  final int id;
  final String name;

  GenreDataEntity({@required this.id, @required this.name});

  factory GenreDataEntity.fromJson(Map<String, dynamic> json) {
    return GenreDataEntity(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object> get props => [id, name];
}
