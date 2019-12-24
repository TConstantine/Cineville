import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../test_util/test_review_model_builder.dart';

void main() {
  Database database;
  ReviewDao dao;

  setUp(() {
    database = Database(VmDatabase.memory());
    dao = ReviewDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  final int testMovieId = 5;
  final String testAuthor = 'Superman';
  final List<ReviewModel> testReviewModelsWithDifferentAuthors =
      TestReviewModelBuilder().withAuthors(['Batman', 'Joker', 'Spiderman']).buildMultiple();
  final List<ReviewModel> testReviewModels = TestReviewModelBuilder().buildMultiple();
  final List<ReviewModel> testReviewModelsWithSameAuthor =
      TestReviewModelBuilder().withAuthors([testAuthor, testAuthor, testAuthor]).buildMultiple();

  group('getMovieReviews', () {
    test('should not return any reviews', () async {
      final List<ReviewModel> reviewModels = await dao.getMovieReviews(testMovieId);

      expect(reviewModels.isEmpty, true);
    });

    test('should return reviews for a specific movie', () async {
      await dao.storeMovieReviews(testMovieId, testReviewModels);
      await dao.storeMovieReviews(testMovieId + 1, testReviewModelsWithSameAuthor);
      await dao.storeMovieReviews(testMovieId + 2, testReviewModels);

      final List<ReviewModel> reviewModels = await dao.getMovieReviews(testMovieId + 1);

      expect(reviewModels.length, 1);
      expect(reviewModels.first.author, testAuthor);
    });
  });

  group('storeMovieReviews', () {
    test('should store reviews', () async {
      await dao.storeMovieReviews(testMovieId, testReviewModelsWithDifferentAuthors);

      final List<ReviewModel> reviewModels = await dao.getMovieReviews(testMovieId);

      expect(reviewModels.length, testReviewModelsWithDifferentAuthors.length);
    });

    test('should not create new entries for reviews that are already stored', () async {
      await dao.storeMovieReviews(testMovieId, testReviewModels);

      final List<ReviewModel> reviewModels = await dao.getMovieReviews(testMovieId);

      expect(reviewModels.length, 1);
    });
  });
}
