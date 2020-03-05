import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/video_domain_entity_mapper.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:cineville/data/network/youtube_constant.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/video_data_entity_builder.dart';

void main() {
  DataEntityBuilder videoDataEntityBuilder;
  VideoDomainEntityMapper videoDomainEntityMapper;

  setUp(() {
    videoDataEntityBuilder = VideoDataEntityBuilder();
    videoDomainEntityMapper = VideoDomainEntityMapper();
  });

  test('should map video data entities to video domain entities', () {
    final List<DataEntity> videoDataEntities = videoDataEntityBuilder.buildList();

    final List<Video> videoDomainEntities = videoDomainEntityMapper.map(videoDataEntities);

    expect(videoDomainEntities.length, videoDataEntities.length);
  });

  test('should map key to a https://www.youtube.com/watch?v={key} format', () {
    final List<VideoDataEntity> videoDataEntities =
        List<VideoDataEntity>.from(videoDataEntityBuilder.buildList());

    final List<Video> videoDomainEntities = videoDomainEntityMapper.map(videoDataEntities);

    expect(
      videoDomainEntities.first.url,
      '${YoutubeConstant.BASE_VIDEO_URL}${videoDataEntities.first.key}',
    );
  });
}
