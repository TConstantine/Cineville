import 'package:cineville/data/model/actor_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_actor_model_builder.dart';

void main() {
  final ActorModel testActorModel = TestActorModelBuilder().build();
  final Map<String, dynamic> testActorModelJson = TestActorModelBuilder().buildJson();
  final Map<String, dynamic> testActorModelJsonWithoutProfile =
      TestActorModelBuilder().withProfileImage(null).buildJson();

  group('fromJson', () {
    test('should convert a json object into a valid actor model', () {
      final ActorModel actorModel = ActorModel.fromJson(testActorModelJson);

      expect(actorModel, equals(testActorModel));
    });

    test('should cast a null profile url into an empty string', () {
      final ActorModel actorModel = ActorModel.fromJson(testActorModelJsonWithoutProfile);

      expect(actorModel.profileImage, '');
    });
  });

  group('toJson', () {
    test('should convert an actor model into a valid json object', () {
      final Map<String, dynamic> json = testActorModel.toJson();

      expect(json, equals(testActorModelJson));
    });
  });
}
