import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:cineville/data/network/youtube_constant.dart';
import 'package:cineville/domain/entity/video.dart';

class VideoDomainEntityMapper {
  List<Video> map(List<DataEntity> videoDataEntities) {
    final List<Video> videoDomainEntities = [];
    List<VideoDataEntity>.from(videoDataEntities).forEach((videoDataEntity) {
      videoDomainEntities.add(Video(id: videoDataEntity.id, url: _mapKey(videoDataEntity.key)));
    });
    return videoDomainEntities;
  }

  String _mapKey(String key) {
    return '${YoutubeConstant.BASE_VIDEO_URL}$key';
  }
}
