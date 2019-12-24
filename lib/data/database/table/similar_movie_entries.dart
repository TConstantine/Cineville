import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('SimilarMovieEntry')
class SimilarMovieEntries extends Table {
  IntColumn get movieId => integer().customConstraint('REFERENCES MovieEntries(id)')();
  IntColumn get similarMovieId => integer().customConstraint('REFERENCES MovieEntries(id)')();

  @override
  Set<Column> get primaryKey => {movieId, similarMovieId};
}
