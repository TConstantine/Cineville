import 'package:cineville/data/model/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_genre_model_builder.dart';

void main() {
  final GenreModel testGenreModel = TestGenreModelBuilder().build();
  final Map<String, dynamic> testGenreModelJson = TestGenreModelBuilder().buildJson();

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
