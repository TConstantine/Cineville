import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('MovieTagEntry')
class MovieTagEntries extends Table {
  IntColumn get movieId => integer().customConstraint('REFERENCES MovieEntries(id)')();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {movieId, name};
}
