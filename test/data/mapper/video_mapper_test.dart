import 'package:cineville/data/mapper/video_mapper.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/youtube_constant.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_video_model_builder.dart';

void main() {
  VideoMapper mapper;

  setUp(() {
    mapper = VideoMapper();
  });

  final List<VideoModel> testVideoModels = TestVideoModelBuilder().buildMultiple();

  test('should map video models to video entities', () {
    final List<Video> videos = mapper.map(testVideoModels);

    expect(videos.length, testVideoModels.length);
  });

  test('should map key to a https://www.youtube.com/watch?v={key} format', () {
    final List<Video> videos = mapper.map(testVideoModels);

    expect(videos.first.url, '${YoutubeConstant.BASE_VIDEO_URL}${testVideoModels.first.key}');
  });
}
