import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/review_entries.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'review_dao.g.dart';

@UseDao(tables: [ReviewEntries])
class ReviewDao extends DatabaseAccessor<Database> with _$ReviewDaoMixin {
  final Database database;

  ReviewDao(this.database) : super(database);

  Future<List<ReviewModel>> getMovieReviews(int movieId) {
    return (select(reviewEntries)..where((table) => table.movieId.equals(movieId)))
        .map((entry) => ReviewModel(author: entry.author, content: entry.content))
        .get();
  }

  Future storeMovieReviews(int movieId, List<ReviewModel> reviewModels) {
    return into(reviewEntries).insertAll(
      reviewModels.map((reviewModel) {
        return ReviewEntry(
          movieId: movieId,
          author: reviewModel.author,
          content: reviewModel.content,
        );
      }).toList(),
      orReplace: true,
    );
  }
}
