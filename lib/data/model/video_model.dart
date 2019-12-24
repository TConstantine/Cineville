import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class VideoModel extends Equatable {
  final String id;
  final String key;

  VideoModel({@required this.id, @required this.key});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(id: json['id'], key: json['key']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'key': key};
  }

  @override
  List<Object> get props => [id, key];
}
