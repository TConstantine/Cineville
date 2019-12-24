import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('ReviewEntry')
class ReviewEntries extends Table {
  IntColumn get movieId => integer().customConstraint('REFERENCES MovieEntries(id)')();
  TextColumn get author => text()();
  TextColumn get content => text()();

  @override
  Set<Column> get primaryKey => {movieId, author};
}
