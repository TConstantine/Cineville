import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/domain/entity/review.dart';

class ReviewMapper {
  List<Review> map(List<ReviewModel> reviewModels) {
    final List<Review> reviews = [];
    reviewModels.forEach(
      (reviewModel) => reviews.add(
        Review(author: reviewModel.author, content: reviewModel.content),
      ),
    );
    return reviews;
  }
}
