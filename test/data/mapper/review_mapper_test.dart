import 'package:cineville/data/mapper/review_mapper.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_review_builder.dart';
import '../../test_util/test_review_model_builder.dart';

void main() {
  ReviewMapper _mapper;

  setUp(() {
    _mapper = ReviewMapper();
  });

  final List<ReviewModel> testReviewModels = TestReviewModelBuilder().buildMultiple();
  final List<Review> testReviews = TestReviewBuilder().buildMultiple();

  group('map', () {
    test('should map review models to review entities', () {
      final List<Review> reviews = _mapper.map(testReviewModels);

      expect(reviews.first.author, testReviews.first.author);
      expect(reviews.first.content, testReviews.first.content);
    });
  });
}
