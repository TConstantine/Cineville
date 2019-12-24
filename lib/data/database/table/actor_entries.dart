import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ActorEntry')
class ActorEntries extends Table {
  IntColumn get movieId => integer().customConstraint('REFERENCES MovieEntries(id)')();
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get profileUrl => text()();
  TextColumn get character => text()();
  IntColumn get displayOrder => integer()();

  @override
  Set<Column> get primaryKey => {movieId, id};
}
