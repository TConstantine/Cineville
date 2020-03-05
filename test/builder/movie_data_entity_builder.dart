import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';

import 'data_entity_builder.dart';

class MovieDataEntityBuilder extends DataEntityBuilder {
  MovieDataEntityBuilder() {
    filename = 'movies.json';
    key = 'results';
  }

  @override
  DataEntity build() {
    return MovieDataEntity.fromJson(buildAsJson());
  }

  @override
  List<DataEntity> buildList() {
    final List<dynamic> jsonList = parseList();
    return List.generate(jsonList.length, (index) => MovieDataEntity.fromJson(jsonList[index]));
  }
}
