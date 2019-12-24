import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ReviewModel extends Equatable {
  final String author;
  final String content;

  ReviewModel({@required this.author, @required this.content});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(author: json['author'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {'author': author, 'content': content};
  }

  @override
  List<Object> get props {
    return [author, content];
  }
}
