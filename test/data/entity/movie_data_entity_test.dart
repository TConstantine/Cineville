import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';

void main() {
  DataEntityBuilder movieDataEntityBuilder;

  setUp(() {
    movieDataEntityBuilder = MovieDataEntityBuilder();
  });

  group('fromJson', () {
    test('should convert a json object into a valid movie model', () {
      final DataEntity expectedMovieDataEntity = movieDataEntityBuilder.build();
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();

      final DataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      expect(movieDataEntity, equals(expectedMovieDataEntity));
    });

    test('should cast rating to double when a movie is not rated', () {
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();

      final MovieDataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      expect(movieDataEntity.rating, equals(0.0));
    });

    test('should cast a null poster url into an empty string', () {
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();

      final MovieDataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      expect(movieDataEntity.posterUrl, '');
    });

    test('should cast a null backdrop url into an empty string', () {
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();

      final MovieDataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      expect(movieDataEntity.backdropUrl, '');
    });

    test('should cast popularity to double when a movie is not popular', () {
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();

      final MovieDataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      expect(movieDataEntity.popularity, equals(0.0));
    });
  });

  group('toJson', () {
    test('should convert a movie model into a valid json object', () {
      final Map<String, dynamic> movieDataEntitiesAsJson = movieDataEntityBuilder.buildAsJson();
      final MovieDataEntity movieDataEntity = MovieDataEntity.fromJson(movieDataEntitiesAsJson);

      final Map<String, dynamic> json = movieDataEntity.toJson();

      expect(
        json,
        equals({
          "popularity": 0.0,
          "poster_path": '',
          "id": 419704,
          "backdrop_path": '',
          "original_language": "en",
          "genre_ids": [1],
          "title": "Ad Astra",
          "vote_average": 0.0,
          "overview":
              "The near future, a time when both hope and hardships drive humanity to look to the stars and beyond. While a mysterious phenomenon menaces to destroy life on planet Earth, astronaut Roy McBride undertakes a mission across the immensity of space and its many perils to uncover the truth about a lost expedition that decades before boldly faced emptiness and silence in search of the unknown.",
          "release_date": "2019-09-17"
        }),
      );
    });
  });
}
