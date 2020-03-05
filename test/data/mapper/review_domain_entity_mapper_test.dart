import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/review_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/review_domain_entity_builder.dart';
import '../../builder/review_data_entity_builder.dart';

void main() {
  DomainEntityBuilder reviewDomainEntityBuilder;
  DataEntityBuilder reviewDataEntityBuilder;
  ReviewDomainEntityMapper reviewDomainEntityMapper;

  setUp(() {
    reviewDomainEntityBuilder = ReviewDomainEntityBuilder();
    reviewDataEntityBuilder = ReviewDataEntityBuilder();
    reviewDomainEntityMapper = ReviewDomainEntityMapper();
  });

  test('should map review data entities to review domain entities', () {
    final List<Review> reviewDomainEntityList = reviewDomainEntityBuilder.buildList();
    final List<DataEntity> reviewDataEntities = reviewDataEntityBuilder.buildList();

    final List<Review> reviewDomainEntities = reviewDomainEntityMapper.map(reviewDataEntities);

    expect(reviewDomainEntities.first.author, reviewDomainEntityList.first.author);
    expect(reviewDomainEntities.first.content, reviewDomainEntityList.first.content);
  });
}
