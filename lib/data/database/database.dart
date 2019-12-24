import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/database/table/actor_entries.dart';
import 'package:cineville/data/database/table/genre_entries.dart';
import 'package:cineville/data/database/table/movie_entries.dart';
import 'package:cineville/data/database/table/movie_tag_entries.dart';
import 'package:cineville/data/database/table/review_entries.dart';
import 'package:cineville/data/database/table/similar_movie_entries.dart';
import 'package:cineville/data/database/table/video_entries.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

@UseMoor(tables: [
  ActorEntries,
  GenreEntries,
  MovieEntries,
  MovieTagEntries,
  ReviewEntries,
  SimilarMovieEntries,
  VideoEntries,
], daos: [
  ActorDao,
  GenreDao,
  MovieDao,
  ReviewDao,
  VideoDao,
])
class Database extends _$Database {
  Database(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}
