import 'package:flutter_test/flutter_test.dart';
import 'package:popular_movies/data/model/movie_model.dart';

import '../../builder/movie_model_builder.dart';

void main() {
  final MovieModel testMovieModel = MovieModelBuilder().build();
  final Map<String, dynamic> testMovieModelJson = MovieModelBuilder().buildJson();
  final Map<String, dynamic> testUnratedMovieModelJson =
      MovieModelBuilder().buildJson(rating: 0, popularity: 0);

  group('fromJson', () {
    test('should convert a json object into a valid movie model', () {
      final MovieModel movieModel = MovieModel.fromJson(testMovieModelJson);

      expect(movieModel, equals(testMovieModel));
    });

    test('should cast rating to double when a movie is not rated', () {
      final MovieModel movieModel = MovieModel.fromJson(testUnratedMovieModelJson);

      expect(movieModel.rating, equals(0.0));
    });

    test('should cast popularity to double when a movie is not popular', () {
      final MovieModel movieModel = MovieModel.fromJson(testUnratedMovieModelJson);

      expect(movieModel.popularity, equals(0.0));
    });
  });

  group('toJson', () {
    test('should convert a movie model into a valid json object', () {
      final Map<String, dynamic> json = testMovieModel.toJson();

      expect(json, equals(testMovieModelJson));
    });
  });
}
