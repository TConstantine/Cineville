import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Review extends Equatable {
  final String author;
  final String content;

  Review({@required this.author, @required this.content});

  @override
  List<Object> get props {
    return [author, content];
  }
}
