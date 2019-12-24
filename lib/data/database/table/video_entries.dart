import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('VideoEntry')
class VideoEntries extends Table {
  IntColumn get movieId => integer().customConstraint('REFERENCES MovieEntries(id)')();
  TextColumn get videoId => text()();
  TextColumn get key => text()();

  @override
  Set<Column> get primaryKey => {movieId, videoId};
}
