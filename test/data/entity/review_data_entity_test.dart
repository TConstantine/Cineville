import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/review_data_entity_builder.dart';

void main() {
  DataEntityBuilder reviewDataEntityBuilder;

  setUp(() {
    reviewDataEntityBuilder = ReviewDataEntityBuilder();
  });

  test('should convert a json object into a valid review data entity', () {
    final DataEntity expectedReviewDataEntity = reviewDataEntityBuilder.build();
    final Map<String, dynamic> reviewDataEntitiesAsJson = reviewDataEntityBuilder.buildAsJson();

    final ReviewDataEntity reviewDataEntity = ReviewDataEntity.fromJson(reviewDataEntitiesAsJson);

    expect(reviewDataEntity, equals(expectedReviewDataEntity));
  });

  test('should convert a review data entity into a valid json object', () {
    final ReviewDataEntity reviewDataEntity = reviewDataEntityBuilder.build();
    final Map<String, dynamic> reviewDataEntitiesAsJson = reviewDataEntityBuilder.buildAsJson();

    final Map<String, dynamic> json = reviewDataEntity.toJson();

    expect(json, equals(reviewDataEntitiesAsJson));
  });
}
