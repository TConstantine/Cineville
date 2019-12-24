import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Video extends Equatable {
  final String id;
  final String url;

  Video({@required this.id, @required this.url});

  @override
  List<Object> get props => [id, url];
}
