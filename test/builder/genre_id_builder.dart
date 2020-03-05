import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';

import 'data_entity_builder.dart';
import 'movie_data_entity_builder.dart';

class GenreIdBuilder {
  static List<int> buildList() {
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final List<int> genreIds = [];
    List<MovieDataEntity>.from(movieDataEntities).forEach((movieDataEntity) {
      genreIds.addAll(movieDataEntity.genreIds);
    });
    return genreIds.toSet().toList();
  }
}
