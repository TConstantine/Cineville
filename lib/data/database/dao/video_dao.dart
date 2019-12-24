import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/video_entries.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'video_dao.g.dart';

@UseDao(tables: [VideoEntries])
class VideoDao extends DatabaseAccessor<Database> with _$VideoDaoMixin {
  final Database database;

  VideoDao(this.database) : super(database);

  Future<List<VideoModel>> getMovieVideos(int movieId) {
    return (select(videoEntries)..where((table) => table.movieId.equals(movieId)))
        .map((entry) => VideoModel(id: entry.videoId, key: entry.key))
        .get();
  }

  Future storeMovieVideos(int movieId, List<VideoModel> videoModels) {
    return into(videoEntries).insertAll(
      videoModels.map((videoModel) {
        return VideoEntry(movieId: movieId, videoId: videoModel.id, key: videoModel.key);
      }).toList(),
      orReplace: true,
    );
  }
}
