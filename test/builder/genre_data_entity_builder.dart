import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';

import 'data_entity_builder.dart';
import 'genre_id_builder.dart';
import 'movie_data_entity_builder.dart';

class GenreDataEntityBuilder extends DataEntityBuilder {
  GenreDataEntityBuilder() {
    filename = 'genres.json';
    key = 'genres';
  }

  @override
  DataEntity build() {
    final DataEntityBuilder movieEntityBuilder = MovieDataEntityBuilder();
    final DataEntity movieDataEntity = movieEntityBuilder.build();
    return _buildList([movieDataEntity]).first;
  }

  @override
  List<DataEntity> buildList() {
    final DataEntityBuilder movieEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieEntityBuilder.buildList();
    return _buildList(movieDataEntities);
  }

  List<DataEntity> _buildList(List<DataEntity> movieDataEntities) {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final List<dynamic> jsonList = parseList();
    final List<DataEntity> genreDataEntities = [];
    jsonList.forEach((genreListItem) {
      final GenreDataEntity genreDataEntity = GenreDataEntity.fromJson(genreListItem);
      if (genreIds.contains(genreDataEntity.id)) {
        genreDataEntities.add(genreDataEntity);
      }
    });
    return genreDataEntities;
  }
}
