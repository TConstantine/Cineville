import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/video_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/video.dart';

import 'data_entity_builder.dart';
import 'domain_entity_builder.dart';
import 'video_data_entity_builder.dart';

class VideoDomainEntityBuilder extends DomainEntityBuilder {
  @override
  List<Video> buildList() {
    final DataEntityBuilder videoDataEntityBuilder = VideoDataEntityBuilder();
    final List<DataEntity> videoDataEntities = videoDataEntityBuilder.buildList();
    final VideoDomainEntityMapper videoMapper = VideoDomainEntityMapper();
    return videoMapper.map(videoDataEntities);
  }
}
