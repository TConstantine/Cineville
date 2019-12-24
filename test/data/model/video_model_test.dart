import 'package:cineville/data/model/video_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_video_model_builder.dart';

void main() {
  final VideoModel testVideoModel = TestVideoModelBuilder().build();
  final Map<String, dynamic> testVideoModelJson = TestVideoModelBuilder().buildJson();

  group('fromJson', () {
    test('should convert a json object into a valid video model', () {
      final VideoModel videoModel = VideoModel.fromJson(testVideoModelJson);

      expect(videoModel, equals(testVideoModel));
    });
  });

  group('toJson', () {
    test('should convert a video model into a valid json object', () {
      final Map<String, dynamic> json = testVideoModel.toJson();

      expect(json, equals(testVideoModelJson));
    });
  });
}
