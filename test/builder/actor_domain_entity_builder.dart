import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/actor_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/actor.dart';

import 'actor_data_entity_builder.dart';
import 'data_entity_builder.dart';
import 'domain_entity_builder.dart';

class ActorDomainEntityBuilder extends DomainEntityBuilder {
  @override
  List<Actor> buildList() {
    final DataEntityBuilder actorDataEntityBuilder = ActorDataEntityBuilder();
    final List<DataEntity> actorDataEntities = actorDataEntityBuilder.buildList();
    final ActorDomainEntityMapper actorMapper = ActorDomainEntityMapper();
    return actorMapper.map(actorDataEntities);
  }
}
