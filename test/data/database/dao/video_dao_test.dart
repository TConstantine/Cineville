import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../test_util/test_video_model_builder.dart';

void main() {
  Database database;
  VideoDao dao;

  setUp(() {
    database = Database(VmDatabase.memory());
    dao = VideoDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  final int testMovieId = 5;
  final String testVideoId = '100';
  final List<VideoModel> testVideoModelsWithDifferentIds =
      TestVideoModelBuilder().withIds(['10', '11', '12']).buildMultiple();
  final List<VideoModel> testVideoModels = TestVideoModelBuilder().buildMultiple();
  final List<VideoModel> testVideoModelsWithSameId =
      TestVideoModelBuilder().withIds([testVideoId, testVideoId, testVideoId]).buildMultiple();

  group('getMovieVideos', () {
    test('should not return any videos', () async {
      final List<VideoModel> videoModels = await dao.getMovieVideos(testMovieId);

      expect(videoModels.isEmpty, true);
    });

    test('should return videos for a specific movie', () async {
      await dao.storeMovieVideos(testMovieId, testVideoModels);
      await dao.storeMovieVideos(testMovieId + 1, testVideoModelsWithSameId);
      await dao.storeMovieVideos(testMovieId + 2, testVideoModels);

      final List<VideoModel> videoModels = await dao.getMovieVideos(testMovieId + 1);

      expect(videoModels.length, 1);
      expect(videoModels.first.id, testVideoId);
    });
  });

  group('storeMovieVideos', () {
    test('should store videos', () async {
      await dao.storeMovieVideos(testMovieId, testVideoModelsWithDifferentIds);

      final List<VideoModel> videoModels = await dao.getMovieVideos(testMovieId);

      expect(videoModels.length, testVideoModelsWithDifferentIds.length);
    });

    test('should not create new entries for videos that are already stored', () async {
      await dao.storeMovieVideos(testMovieId, testVideoModels);

      final List<VideoModel> videoModels = await dao.getMovieVideos(testMovieId);

      expect(videoModels.length, 1);
    });
  });
}
