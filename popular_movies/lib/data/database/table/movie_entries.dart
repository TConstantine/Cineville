import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('MovieEntry')
class MovieEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get plotSynopsis => text()();
  TextColumn get genreIds => text()();
  RealColumn get rating => real()();
  TextColumn get posterUrl => text()();
  TextColumn get backdropUrl => text()();
  TextColumn get releaseDate => text()();
  TextColumn get languageCode => text()();
  RealColumn get popularity => real()();

  @override
  Set<Column> get primaryKey => {id};
}
