import 'package:cineville/data/mapper/actor_mapper.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_actor_model_builder.dart';

void main() {
  ActorMapper mapper;

  setUp(() {
    mapper = ActorMapper();
  });

  final List<ActorModel> testActorModels = TestActorModelBuilder().buildMultiple();

  test('should map actor models to actor entities', () {
    final List<Actor> actors = mapper.map(testActorModels);

    expect(actors.length, testActorModels.length);
  });

  test('should map profile url to a https://www.example.com/image.jpg format', () {
    final List<Actor> actors = mapper.map(testActorModels);

    expect(actors.first.profileUrl,
        '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.PROFILE_SIZE}${testActorModels.first.profileImage}');
  });
}
