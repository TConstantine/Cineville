import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';

import 'data_entity_builder.dart';

class VideoDataEntityBuilder extends DataEntityBuilder {
  VideoDataEntityBuilder() {
    filename = 'videos.json';
    key = 'results';
  }

  @override
  DataEntity build() {
    return VideoDataEntity.fromJson(buildAsJson());
  }

  @override
  List<DataEntity> buildList() {
    final List<dynamic> jsonList = parseList();
    return List.generate(jsonList.length, (index) => VideoDataEntity.fromJson(jsonList[index]));
  }
}
