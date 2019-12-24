import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../test_util/test_actor_model_builder.dart';

void main() {
  Database database;
  ActorDao dao;

  setUp(() {
    database = Database(VmDatabase.memory());
    dao = ActorDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  final int testMovieId = 5;
  final int testActorId = 10;
  final List<int> testDifferentIds = [15, 16, 17];
  final List<int> testDifferentDisplayOrders = [13, 17, 9];
  final List<ActorModel> testActorModelsWithDifferentIds =
      TestActorModelBuilder().withIds(testDifferentIds).buildMultiple();
  final List<ActorModel> testActorModelsWithDifferentIdsAndDisplayOrder = TestActorModelBuilder()
      .withIds(testDifferentIds)
      .withDisplayOrders(testDifferentDisplayOrders)
      .buildMultiple();
  final List<ActorModel> testActorModels = TestActorModelBuilder().buildMultiple();
  final List<ActorModel> testActorModelsWithSameIds =
      TestActorModelBuilder().withIds([testActorId, testActorId, testActorId]).buildMultiple();

  group('getMovieActors', () {
    test('should not return any actors', () async {
      final List<ActorModel> actorModels = await dao.getMovieActors(testMovieId);

      expect(actorModels.isEmpty, true);
    });

    test('should return actors for a specific movie', () async {
      await dao.storeMovieActors(testMovieId, testActorModels);
      await dao.storeMovieActors(testMovieId + 1, testActorModelsWithSameIds);
      await dao.storeMovieActors(testMovieId + 2, testActorModels);

      final List<ActorModel> actorModels = await dao.getMovieActors(testMovieId + 1);

      expect(actorModels.length, 1);
      expect(actorModels.first.id, testActorId);
    });

    test('should return actors ordered by display order', () async {
      await dao.storeMovieActors(testMovieId, testActorModelsWithDifferentIdsAndDisplayOrder);

      final List<ActorModel> actorModels = await dao.getMovieActors(testMovieId);

      expect(actorModels.length, 3);
      expect(actorModels[0].displayOrder, 9);
      expect(actorModels[1].displayOrder, 13);
      expect(actorModels[2].displayOrder, 17);
    });
  });

  group('storeMovieActors', () {
    test('should store actors', () async {
      await dao.storeMovieActors(testMovieId, testActorModelsWithDifferentIds);

      final List<ActorModel> actorModels = await dao.getMovieActors(testMovieId);

      expect(actorModels.length, testActorModelsWithDifferentIds.length);
    });

    test('should not create new entries for actors that are already stored', () async {
      await dao.storeMovieActors(testMovieId, testActorModels);

      final List<ActorModel> actorModels = await dao.getMovieActors(testMovieId);

      expect(actorModels.length, 1);
    });
  });
}
