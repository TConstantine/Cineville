import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../builder/data_entity_builder.dart';
import '../../../builder/review_data_entity_builder.dart';

void main() {
  DataEntityBuilder reviewDataEntityBuilder;
  Database database;
  ReviewDao reviewDao;

  setUp(() {
    reviewDataEntityBuilder = ReviewDataEntityBuilder();
    database = Database(VmDatabase.memory());
    reviewDao = ReviewDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should not return any reviews when cache is empty', () async {
    final int movieId = 1;

    final List<DataEntity> reviewDataEntities = await reviewDao.getMovieReviews(movieId);

    expect(reviewDataEntities.isEmpty, true);
  });

  test('should return reviews when cache is not empty', () async {
    final int movieId = 1;
    final List<ReviewDataEntity> reviewDataEntityList =
        List<ReviewDataEntity>.from(reviewDataEntityBuilder.buildList());
    await reviewDao.storeMovieReviews(movieId, reviewDataEntityList);

    final List<ReviewDataEntity> reviewDataEntities = await reviewDao.getMovieReviews(movieId);

    expect(reviewDataEntities.length, reviewDataEntityList.length);
    expect(reviewDataEntities.first.author, reviewDataEntityList.first.author);
    expect(reviewDataEntities[1].author, reviewDataEntityList[1].author);
    expect(reviewDataEntities.last.author, reviewDataEntityList.last.author);
  });

  test('should store reviews', () async {
    final int movieId = 1;
    final List<DataEntity> reviewDataEntityList = reviewDataEntityBuilder.buildList();

    await reviewDao.storeMovieReviews(movieId, reviewDataEntityList);

    final List<DataEntity> reviewDataEntities = await reviewDao.getMovieReviews(movieId);
    expect(reviewDataEntities.length, reviewDataEntityList.length);
  });

  test('should not create duplicate review entries', () async {
    final int movieId = 1;
    final DataEntity reviewDataEntity = reviewDataEntityBuilder.build();
    final List<DataEntity> reviewDataEntityList = [
      reviewDataEntity,
      reviewDataEntity,
      reviewDataEntity,
    ];

    await reviewDao.storeMovieReviews(movieId, reviewDataEntityList);

    final List<DataEntity> reviewDataEntities = await reviewDao.getMovieReviews(movieId);
    expect(reviewDataEntities.length, 1);
  });
}
