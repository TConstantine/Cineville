import 'package:cineville/data/model/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_movie_model_builder.dart';

void main() {
  final MovieModel testMovieModel = TestMovieModelBuilder().build();
  final Map<String, dynamic> testMovieModelJson = TestMovieModelBuilder().buildJson();
  final Map<String, dynamic> testUnratedMovieModelJson =
      TestMovieModelBuilder().buildJson(rating: 0, popularity: 0);
  final Map<String, dynamic> testMovieModelJsonWithoutPoster =
      TestMovieModelBuilder().buildJson(posterUrl: null);
  final Map<String, dynamic> testMovieModelJsonWithoutBackdrop =
      TestMovieModelBuilder().buildJson(backdropUrl: null);

  group('fromJson', () {
    test('should convert a json object into a valid movie model', () {
      final MovieModel movieModel = MovieModel.fromJson(testMovieModelJson);

      expect(movieModel, equals(testMovieModel));
    });

    test('should cast rating to double when a movie is not rated', () {
      final MovieModel movieModel = MovieModel.fromJson(testUnratedMovieModelJson);

      expect(movieModel.rating, equals(0.0));
    });

    test('should cast a null poster url into an empty string', () {
      final MovieModel movieModel = MovieModel.fromJson(testMovieModelJsonWithoutPoster);

      expect(movieModel.posterUrl, '');
    });

    test('should cast a null backdrop url into an empty string', () {
      final MovieModel movieModel = MovieModel.fromJson(testMovieModelJsonWithoutBackdrop);

      expect(movieModel.backdropUrl, '');
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
