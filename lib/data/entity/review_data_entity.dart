import 'package:cineville/data/entity/data_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ReviewDataEntity extends Equatable implements DataEntity {
  final String author;
  final String content;

  ReviewDataEntity({@required this.author, @required this.content});

  factory ReviewDataEntity.fromJson(Map<String, dynamic> json) {
    return ReviewDataEntity(author: json['author'], content: json['content']);
  }

  @override
  Map<String, dynamic> toJson() => {'author': author, 'content': content};

  @override
  List<Object> get props => [author, content];
}
