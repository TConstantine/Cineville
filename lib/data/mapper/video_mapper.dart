import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/youtube_constant.dart';
import 'package:cineville/domain/entity/video.dart';

class VideoMapper {
  List<Video> map(List<VideoModel> videoModels) {
    final List<Video> videos = [];
    videoModels.forEach((videoModel) {
      videos.add(Video(id: videoModel.id, url: _mapKey(videoModel.key)));
    });
    return videos;
  }

  String _mapKey(String key) {
    return '${YoutubeConstant.BASE_VIDEO_URL}$key';
  }
}
