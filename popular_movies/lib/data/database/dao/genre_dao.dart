import 'package:moor_flutter/moor_flutter.dart';
import 'package:popular_movies/data/database/database.dart';
import 'package:popular_movies/data/database/table/genre_entries.dart';
import 'package:popular_movies/data/model/genre_model.dart';

part 'genre_dao.g.dart';

@UseDao(tables: [GenreEntries])
class GenreDao extends DatabaseAccessor<Database> with _$GenreDaoMixin {
  final Database database;

  GenreDao(this.database) : super(database);

  Future<List<GenreModel>> getGenres(List<int> genreIds) {
    final String whereClause = genreIds.toString().replaceAll('[', '(').replaceAll(']', ')');
    return customSelectQuery(
      'SELECT * FROM genre_entries WHERE id IN $whereClause ORDER BY name',
      readsFrom: {genreEntries},
    )
        .map((row) => GenreEntry.fromData(row.data, database))
        .map((genreEntry) => GenreModel(id: genreEntry.id, name: genreEntry.name))
        .get();
  }

  Future storeGenres(List<GenreModel> genreModels) {
    return into(genreEntries).insertAll(
      genreModels.map((genreModel) {
        return GenreEntry(id: genreModel.id, name: genreModel.name);
      }).toList(),
      orReplace: true,
    );
  }
}
