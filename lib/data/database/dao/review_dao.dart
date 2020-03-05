import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/review_entries.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'review_dao.g.dart';

@UseDao(tables: [ReviewEntries])
class ReviewDao extends DatabaseAccessor<Database> with _$ReviewDaoMixin {
  final Database database;

  ReviewDao(this.database) : super(database);

  Future<List<DataEntity>> getMovieReviews(int movieId) {
    return (select(reviewEntries)..where((table) => table.movieId.equals(movieId)))
        .map((entry) => ReviewDataEntity(author: entry.author, content: entry.content))
        .get();
  }

  Future storeMovieReviews(int movieId, List<DataEntity> reviewDataEntities) {
    return into(reviewEntries).insertAll(
      List<ReviewDataEntity>.from(reviewDataEntities).map((reviewDataEntity) {
        return ReviewEntry(
          movieId: movieId,
          author: reviewDataEntity.author,
          content: reviewDataEntity.content,
        );
      }).toList(),
      orReplace: true,
    );
  }
}
