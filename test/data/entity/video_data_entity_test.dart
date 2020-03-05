import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/video_data_entity_builder.dart';

void main() {
  DataEntityBuilder videoDataEntityBuilder;

  setUp(() {
    videoDataEntityBuilder = VideoDataEntityBuilder();
  });

  test('should convert a json object into a valid video data entity', () {
    final DataEntity expectedVideoDataEntity = videoDataEntityBuilder.build();
    final Map<String, dynamic> videoDataEntitiesAsJson = videoDataEntityBuilder.buildAsJson();

    final DataEntity videoDataEntity = VideoDataEntity.fromJson(videoDataEntitiesAsJson);

    expect(videoDataEntity, equals(expectedVideoDataEntity));
  });

  test('should convert a video data entity into a valid json object', () {
    final VideoDataEntity videoDataEntity = videoDataEntityBuilder.build();
    final Map<String, dynamic> videoDataEntitiesAsJson = videoDataEntityBuilder.buildAsJson();

    final Map<String, dynamic> json = videoDataEntity.toJson();

    expect(json, equals(videoDataEntitiesAsJson));
  });
}
