import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/video_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../builder/data_entity_builder.dart';
import '../../../builder/video_data_entity_builder.dart';

void main() {
  DataEntityBuilder videoDataEntityBuilder;
  Database database;
  VideoDao videoDao;

  setUp(() {
    videoDataEntityBuilder = VideoDataEntityBuilder();
    database = Database(VmDatabase.memory());
    videoDao = VideoDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should not return any videos when cache is empty', () async {
    final int movieId = 1;

    final List<DataEntity> videoDataEntities = await videoDao.getMovieVideos(movieId);

    expect(videoDataEntities.isEmpty, true);
  });

  test('should return videos when cache is not empty', () async {
    final int movieId = 1;
    final List<VideoDataEntity> videoDataEntityList =
        List<VideoDataEntity>.from(videoDataEntityBuilder.buildList());
    await videoDao.storeMovieVideos(movieId, videoDataEntityList);

    final List<VideoDataEntity> videoDataEntities = await videoDao.getMovieVideos(movieId);

    expect(videoDataEntities.length, videoDataEntityList.length);
    expect(videoDataEntities.first.id, videoDataEntityList.first.id);
    expect(videoDataEntities[1].id, videoDataEntityList[1].id);
    expect(videoDataEntities.last.id, videoDataEntityList.last.id);
  });

  test('should store videos', () async {
    final int movieId = 1;
    final List<DataEntity> videoDataEntityList = videoDataEntityBuilder.buildList();

    await videoDao.storeMovieVideos(movieId, videoDataEntityList);

    final List<DataEntity> videoDataEntities = await videoDao.getMovieVideos(movieId);
    expect(videoDataEntities.length, videoDataEntityList.length);
  });

  test('should not create duplicate video entries', () async {
    final int movieId = 1;
    final DataEntity videoDataEntity = videoDataEntityBuilder.build();
    final List<DataEntity> videoDataEntityList = [
      videoDataEntity,
      videoDataEntity,
      videoDataEntity,
    ];

    await videoDao.storeMovieVideos(movieId, videoDataEntityList);

    final List<DataEntity> videoDataEntities = await videoDao.getMovieVideos(movieId);
    expect(videoDataEntities.length, 1);
  });
}
