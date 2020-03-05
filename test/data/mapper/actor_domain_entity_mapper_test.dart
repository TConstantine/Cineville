import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/actor_domain_entity_mapper.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/actor_data_entity_builder.dart';
import '../../builder/data_entity_builder.dart';

void main() {
  DataEntityBuilder actorDataEntityBuilder;
  ActorDomainEntityMapper actorDomainEntityMapper;

  setUp(() {
    actorDataEntityBuilder = ActorDataEntityBuilder();
    actorDomainEntityMapper = ActorDomainEntityMapper();
  });

  test('should map actor data entities to actor domain entities', () {
    final List<DataEntity> actorDataEntities = actorDataEntityBuilder.buildList();

    final List<Actor> actorDomainEntities = actorDomainEntityMapper.map(actorDataEntities);

    expect(actorDomainEntities.length, actorDataEntities.length);
  });

  test('should map profile url to a https://www.example.com/image.jpg format', () {
    final List<ActorDataEntity> actorDataEntities =
        List<ActorDataEntity>.from(actorDataEntityBuilder.buildList());

    final List<Actor> actorDomainEntities = actorDomainEntityMapper.map(actorDataEntities);

    expect(
      actorDomainEntities.first.profileUrl,
      '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.PROFILE_SIZE}${actorDataEntities.first.profileImage}',
    );
  });
}
