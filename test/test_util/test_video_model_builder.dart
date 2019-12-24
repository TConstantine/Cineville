import 'package:cineville/data/model/video_model.dart';

class TestVideoModelBuilder {
  String id = '5cb0c7fdc3a3683c26ac7167';
  final String key = 'N1XmtdMZdL8';
  List<String> _ids = [];

  TestVideoModelBuilder withIds(List<String> ids) {
    _ids = ids;
    return this;
  }

  VideoModel build() {
    return VideoModel(id: id, key: key);
  }

  Map<String, dynamic> buildJson() {
    return {'id': id, 'key': key};
  }

  List<VideoModel> buildMultiple() {
    return List.generate(3, (index) {
      if (_ids.isNotEmpty) {
        id = _ids[index];
      }
      return build();
    });
  }

  List<Map<String, dynamic>> buildMultipleJson() {
    return List.generate(3, (_) => buildJson());
  }
}
