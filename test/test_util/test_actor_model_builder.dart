import 'package:cineville/data/model/actor_model.dart';

class TestActorModelBuilder {
  int id = 1;
  String name = 'Name';
  String profileImage = '/profile.jpg';
  String character = 'Character';
  int displayOrder = 0;
  List<int> _ids = [];
  List<int> _displayOrders = [];

  TestActorModelBuilder withIds(List<int> ids) {
    _ids = ids;
    return this;
  }

  TestActorModelBuilder withProfileImage(String profileImage) {
    this.profileImage = profileImage;
    return this;
  }

  TestActorModelBuilder withDisplayOrders(List<int> displayOrders) {
    _displayOrders = displayOrders;
    return this;
  }

  ActorModel build() {
    return ActorModel(
      id: id,
      name: name,
      profileImage: profileImage,
      character: character,
      displayOrder: displayOrder,
    );
  }

  List<ActorModel> buildMultiple() {
    return List.generate(3, (index) {
      if (_ids.isNotEmpty) {
        id = _ids[index];
      }
      if (_displayOrders.isNotEmpty) {
        displayOrder = _displayOrders[index];
      }
      return build();
    });
  }

  Map<String, dynamic> buildJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profileImage,
      'character': character,
      'order': displayOrder,
    };
  }

  List<Map<String, dynamic>> buildMultipleJson() {
    return [buildJson(), buildJson(), buildJson()];
  }
}
