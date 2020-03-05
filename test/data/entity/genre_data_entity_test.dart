import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';

void main() {
  DataEntityBuilder genreDataEntityBuilder;

  setUp(() {
    genreDataEntityBuilder = GenreDataEntityBuilder();
  });

  test('should map a json object into a valid genre data entity', () {
    final DataEntity expectedGenreDataEntity = genreDataEntityBuilder.build();
    final Map<String, dynamic> genreDataEntitiesAsJson = genreDataEntityBuilder.buildAsJson();

    final DataEntity genreDataEntity = GenreDataEntity.fromJson(genreDataEntitiesAsJson);

    expect(genreDataEntity, equals(expectedGenreDataEntity));
  });

  test('should convert a genre data entity into a json object', () {
    final GenreDataEntity genreDataEntity = genreDataEntityBuilder.build();
    final Map<String, dynamic> genreDataEntityAsJson = genreDataEntityBuilder.buildAsJson();

    final Map<String, dynamic> json = genreDataEntity.toJson();

    expect(json, equals(genreDataEntityAsJson));
  });
}
