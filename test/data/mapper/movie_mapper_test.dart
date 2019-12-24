import 'package:cineville/data/language/language_locale.dart';
import 'package:cineville/data/mapper/movie_mapper.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_model_builder.dart';

void main() {
  MovieMapper mapper;

  setUp(() {
    mapper = MovieMapper();
  });

  final List<MovieModel> testMovieModels = [
    TestMovieModelBuilder().withGenreIds([28, 12, 16]).build(),
    TestMovieModelBuilder().build(),
    TestMovieModelBuilder().withLanguageCode('Invalid Language Code').build(),
  ];
  final MovieModel testMovieModel = testMovieModels.first;
  final List<GenreModel> testGenreModels = [
    TestGenreModelBuilder().withId(28).withName('Action').build(),
    TestGenreModelBuilder().withId(12).withName('Adventure').build(),
    TestGenreModelBuilder().withId(16).withName('Animation').build(),
  ];

  test('should map genre ids to genres', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.genres, ['Action', 'Adventure', 'Animation']);
  });

  test('should convert rating from double to string', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.rating is String, true);
  });

  test('should map poster url to a https://www.example.com/image.jpg format', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.posterUrl,
        '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.POSTER_SIZE}${testMovieModel.posterUrl}');
  });

  test('should map backdrop url to a https://www.example.com/image.jpg format', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.backdropUrl,
        '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.BACKDROP_SIZE}${testMovieModel.backdropUrl}');
  });

  test('should map YYYY-MM-DD date format to (YYYY)', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.releaseYear, '(${testMovieModel.releaseDate.substring(0, 4)})');
  });

  test('should map language code to language name', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.first.language, LanguageLocale.languageMap[testMovieModel.languageCode]['name']);
  });

  test('should not map language code to a language name when language code is invalid', () {
    final List<Movie> movies = mapper.map(testMovieModels, testGenreModels);

    expect(movies.last.language, LanguageLocale.NO_LANGUAGE);
  });
}
