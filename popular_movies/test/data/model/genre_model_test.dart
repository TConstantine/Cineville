import 'package:flutter_test/flutter_test.dart';
import 'package:popular_movies/data/model/genre_model.dart';

import '../../builder/genre_model_builder.dart';

void main() {
  final GenreModel testGenreModel = GenreModelBuilder().build();
  final Map<String, dynamic> testGenreModelJson = GenreModelBuilder().buildJson();

  group('fromJson', () {
    test('should map a json object into a valid genre model', () {
      final GenreModel genreModel = GenreModel.fromJson(testGenreModelJson);

      expect(genreModel, equals(testGenreModel));
    });
  });

  group('toJson', () {
    test('should convert a genre model into a json object', () {
      final Map<String, dynamic> json = testGenreModel.toJson();

      expect(json, equals(testGenreModelJson));
    });
  });
}
