import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../builder/actor_data_entity_builder.dart';
import '../../../builder/data_entity_builder.dart';

void main() {
  DataEntityBuilder actorDataEntityBuilder;
  Database database;
  ActorDao actorDao;

  setUp(() {
    actorDataEntityBuilder = ActorDataEntityBuilder();
    database = Database(VmDatabase.memory());
    actorDao = ActorDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should not return any actors when cache is empty', () async {
    final int movieId = 1;

    final List<DataEntity> actorDataEntities = await actorDao.getMovieActors(movieId);

    expect(actorDataEntities.isEmpty, true);
  });

  test('should return actors when cache is not empty', () async {
    final int movieId = 1;
    final ActorDataEntity actorDataEntity = actorDataEntityBuilder.build();
    await actorDao.storeMovieActors(movieId, [actorDataEntity, actorDataEntity, actorDataEntity]);

    final List<ActorDataEntity> actorDataEntities = await actorDao.getMovieActors(movieId);

    expect(actorDataEntities.length, 1);
    expect(actorDataEntities.first.id, actorDataEntity.id);
  });

  test('should return actors ordered by display order', () async {
    final int movieId = 1;
    final List<ActorDataEntity> actorDataEntityList =
        List<ActorDataEntity>.from(actorDataEntityBuilder.buildList());
    await actorDao.storeMovieActors(movieId, actorDataEntityList);

    final List<ActorDataEntity> actorDataEntities = await actorDao.getMovieActors(movieId);

    expect(actorDataEntities.length, 3);
    expect(actorDataEntities.first.displayOrder, actorDataEntityList.first.displayOrder);
    expect(actorDataEntities[1].displayOrder, actorDataEntityList[1].displayOrder);
    expect(actorDataEntities.last.displayOrder, actorDataEntityList.last.displayOrder);
  });

  test('should store actors', () async {
    final int movieId = 1;
    final List<DataEntity> actorDataEntityList = actorDataEntityBuilder.buildList();
    await actorDao.storeMovieActors(movieId, actorDataEntityList);

    final List<DataEntity> actorDataEntities = await actorDao.getMovieActors(movieId);

    expect(actorDataEntities.length, actorDataEntityList.length);
  });

  test('should not create duplicate actor entries', () async {
    final int movieId = 1;
    final DataEntity actorDataEntity = actorDataEntityBuilder.build();
    final List<DataEntity> actorDataEntityList = [
      actorDataEntity,
      actorDataEntity,
      actorDataEntity
    ];

    await actorDao.storeMovieActors(movieId, actorDataEntityList);

    final List<DataEntity> actorDataEntities = await actorDao.getMovieActors(movieId);
    expect(actorDataEntities.length, 1);
  });
}
