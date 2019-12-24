import 'package:cineville/domain/entity/actor.dart';

class TestActorBuilder {
  final int _id = 1;
  final String _name = 'Name';
  final String _profileUrl = 'https://example.com/profile.jpg';
  final String _character = 'Character';
  final int _order = 0;

  Actor build() {
    return Actor(
      id: _id,
      name: _name,
      profileUrl: _profileUrl,
      character: _character,
      displayOrder: _order,
    );
  }

  List<Actor> buildMultiple() {
    return [build(), build(), build()];
  }
}
