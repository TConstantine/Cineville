import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/genre_entries.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'genre_dao.g.dart';

@UseDao(tables: [GenreEntries])
class GenreDao extends DatabaseAccessor<Database> with _$GenreDaoMixin {
  final Database database;

  GenreDao(this.database) : super(database);

  Future<List<DataEntity>> getMovieGenres(List<int> genreIds) {
    final String whereClause = genreIds.toString().replaceAll('[', '(').replaceAll(']', ')');
    return customSelectQuery(
      'SELECT * FROM genre_entries WHERE id IN $whereClause ORDER BY name',
      readsFrom: {genreEntries},
    )
        .map((row) => GenreEntry.fromData(row.data, database))
        .map((genreEntry) => GenreDataEntity(id: genreEntry.id, name: genreEntry.name))
        .get();
  }

  Future storeMovieGenres(List<DataEntity> genreDataEntities) {
    return into(genreEntries).insertAll(
      List<GenreDataEntity>.from(genreDataEntities).map((genreDataEntity) {
        return GenreEntry(id: genreDataEntity.id, name: genreDataEntity.name);
      }).toList(),
      orReplace: true,
    );
  }
}
