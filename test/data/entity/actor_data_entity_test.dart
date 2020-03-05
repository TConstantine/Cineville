import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/actor_data_entity_builder.dart';
import '../../builder/data_entity_builder.dart';

void main() {
  DataEntityBuilder actorDataEntityBuilder;

  setUp(() {
    actorDataEntityBuilder = ActorDataEntityBuilder();
  });

  test('should convert a json object into a valid actor data entity', () {
    final DataEntity expectedActorDataEntity = actorDataEntityBuilder.build();
    final Map<String, dynamic> actorDataEntityAsJson = actorDataEntityBuilder.buildAsJson();

    final DataEntity actorDataEntity = ActorDataEntity.fromJson(actorDataEntityAsJson);

    expect(actorDataEntity, equals(expectedActorDataEntity));
  });

  test('should cast a null profile url into an empty string', () {
    final Map<String, dynamic> actorDataEntityAsJson = actorDataEntityBuilder.buildAsJson();

    final ActorDataEntity actorDataEntity = ActorDataEntity.fromJson(actorDataEntityAsJson);

    expect(actorDataEntity.profileImage, '');
  });

  test('should convert an actor data entity into a valid json object', () {
    final ActorDataEntity actorDataEntity = actorDataEntityBuilder.build();

    final Map<String, dynamic> json = actorDataEntity.toJson();

    expect(
      json,
      equals({
        "character": "Roy McBride",
        "id": 287,
        "name": "Brad Pitt",
        "order": 0,
        "profile_path": ''
      }),
    );
  });
}
