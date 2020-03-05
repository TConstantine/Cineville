import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';
import 'package:cineville/domain/entity/review.dart';

class ReviewDomainEntityMapper {
  List<Review> map(List<DataEntity> reviewDataEntities) {
    final List<Review> reviewDomainEntities = [];
    List<ReviewDataEntity>.from(reviewDataEntities).forEach((reviewDataEntity) {
      reviewDomainEntities.add(
        Review(author: reviewDataEntity.author, content: reviewDataEntity.content),
      );
    });
    return reviewDomainEntities;
  }
}
