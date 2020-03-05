import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/review_data_entity.dart';

import 'data_entity_builder.dart';

class ReviewDataEntityBuilder extends DataEntityBuilder {
  ReviewDataEntityBuilder() {
    filename = 'reviews.json';
    key = 'results';
  }

  @override
  DataEntity build() {
    return ReviewDataEntity.fromJson(buildAsJson());
  }

  @override
  List<DataEntity> buildList() {
    final List<dynamic> jsonList = parseList();
    return List.generate(jsonList.length, (index) => ReviewDataEntity.fromJson(jsonList[index]));
  }
}
