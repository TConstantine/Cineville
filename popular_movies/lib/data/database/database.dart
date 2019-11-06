import 'package:moor_flutter/moor_flutter.dart';
import 'package:popular_movies/data/database/dao/genre_dao.dart';
import 'package:popular_movies/data/database/dao/movie_dao.dart';
import 'package:popular_movies/data/database/table/genre_entries.dart';
import 'package:popular_movies/data/database/table/movie_entries.dart';
import 'package:popular_movies/data/database/table/movie_tag_entries.dart';

part 'database.g.dart';

@UseMoor(tables: [MovieEntries, MovieTagEntries, GenreEntries], daos: [MovieDao, GenreDao])
class Database extends _$Database {
  Database() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  @override
  int get schemaVersion => 1;
}
