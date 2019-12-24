import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/actor.dart';

class ActorMapper {
  List<Actor> map(List<ActorModel> actorModels) {
    final List<Actor> actors = [];
    actorModels.forEach(
      (actorModel) => actors.add(
        Actor(
          id: actorModel.id,
          name: actorModel.name,
          profileUrl: _mapProfileUrl(actorModel.profileImage),
          character: actorModel.character,
          displayOrder: actorModel.displayOrder,
        ),
      ),
    );
    return actors;
  }

  String _mapProfileUrl(String profileUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.PROFILE_SIZE}$profileUrl';
  }
}
