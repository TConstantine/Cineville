import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/review_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/review.dart';

import 'data_entity_builder.dart';
import 'domain_entity_builder.dart';
import 'review_data_entity_builder.dart';

class ReviewDomainEntityBuilder extends DomainEntityBuilder {
  @override
  List<Review> buildList() {
    final DataEntityBuilder reviewDataEntityBuilder = ReviewDataEntityBuilder();
    final List<DataEntity> reviewDataEntities = reviewDataEntityBuilder.buildList();
    final ReviewDomainEntityMapper reviewMapper = ReviewDomainEntityMapper();
    return reviewMapper.map(reviewDataEntities);
  }
}
