import 'package:cineville/domain/entity/video.dart';

class TestVideoBuilder {
  String id = 'id';
  String url = 'https://www.youtube.com/watch?v=key';

  List<Video> buildMultiple() {
    return List.generate(3, (_) => _build());
  }

  Video _build() {
    return Video(id: id, url: url);
  }
}
