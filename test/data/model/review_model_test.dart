import 'package:cineville/data/model/review_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_review_model_builder.dart';

void main() {
  final ReviewModel testModel = TestReviewModelBuilder().build();
  final Map<String, dynamic> testModelJson = TestReviewModelBuilder().buildJson();

  group('fromJson', () {
    test('should convert a json object into a valid review model', () {
      final ReviewModel model = ReviewModel.fromJson(testModelJson);

      expect(model, equals(testModel));
    });
  });

  group('toJson', () {
    test('should convert a review model into a valid json object', () {
      final Map<String, dynamic> json = testModel.toJson();

      expect(json, equals(testModelJson));
    });
  });
}
