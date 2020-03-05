import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/video_entries.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'video_dao.g.dart';

@UseDao(tables: [VideoEntries])
class VideoDao extends DatabaseAccessor<Database> with _$VideoDaoMixin {
  final Database database;

  VideoDao(this.database) : super(database);

  Future<List<DataEntity>> getMovieVideos(int movieId) {
    return (select(videoEntries)..where((table) => table.movieId.equals(movieId)))
        .map((entry) => VideoDataEntity(id: entry.videoId, key: entry.key))
        .get();
  }

  Future storeMovieVideos(int movieId, List<DataEntity> videoDataEntities) {
    return into(videoEntries).insertAll(
      List<VideoDataEntity>.from(videoDataEntities).map((videoDataEntity) {
        return VideoEntry(movieId: movieId, videoId: videoDataEntity.id, key: videoDataEntity.key);
      }).toList(),
      orReplace: true,
    );
  }
}
