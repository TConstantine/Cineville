import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/actor.dart';

class ActorDomainEntityMapper {
  List<Actor> map(List<DataEntity> actorDataEntities) {
    final List<Actor> actorDomainEntities = [];
    List<ActorDataEntity>.from(actorDataEntities).forEach(
      (actorDataEntity) => actorDomainEntities.add(
        Actor(
          id: actorDataEntity.id,
          name: actorDataEntity.name,
          profileUrl: _mapProfileUrl(actorDataEntity.profileImage),
          character: actorDataEntity.character,
          displayOrder: actorDataEntity.displayOrder,
        ),
      ),
    );
    return actorDomainEntities;
  }

  String _mapProfileUrl(String profileUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.PROFILE_SIZE}$profileUrl';
  }
}
