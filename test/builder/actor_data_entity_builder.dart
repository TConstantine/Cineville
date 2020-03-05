import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';

import 'data_entity_builder.dart';

class ActorDataEntityBuilder extends DataEntityBuilder {
  ActorDataEntityBuilder() {
    filename = 'actors.json';
    key = 'cast';
  }

  @override
  DataEntity build() {
    return ActorDataEntity.fromJson(buildAsJson());
  }

  @override
  List<DataEntity> buildList() {
    final List<dynamic> jsonList = parseList();
    return List.generate(jsonList.length, (index) => ActorDataEntity.fromJson(jsonList[index]));
  }
}
