import 'package:cineville/data/entity/data_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class VideoDataEntity extends Equatable implements DataEntity {
  final String id;
  final String key;

  VideoDataEntity({@required this.id, @required this.key});

  factory VideoDataEntity.fromJson(Map<String, dynamic> json) {
    return VideoDataEntity(id: json['id'], key: json['key']);
  }

  @override
  Map<String, dynamic> toJson() => {'id': id, 'key': key};

  @override
  List<Object> get props => [id, key];
}
