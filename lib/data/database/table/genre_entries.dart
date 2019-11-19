import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('GenreEntry')
class GenreEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id, name};
}
