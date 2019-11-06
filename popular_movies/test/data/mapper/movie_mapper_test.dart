import 'package:flutter_test/flutter_test.dart';
import 'package:popular_movies/data/language/language_locale.dart';
import 'package:popular_movies/data/mapper/movie_mapper.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/data/network/tmdb_api_constant.dart';
import 'package:popular_movies/domain/entity/movie.dart';

import '../../builder/genre_model_builder.dart';
import '../../builder/movie_model_builder.dart';

void main() {
  MovieMapper _mapper;

  setUp(() {
    _mapper = MovieMapper();
  });

  group('map', () {
    final List<MovieModel> testMovieModels = [
      MovieModelBuilder().withGenreIds([28, 12, 16]).build(),
      MovieModelBuilder().build(),
      MovieModelBuilder().withLanguageCode('Invalid Language Code').build(),
    ];
    final List<GenreModel> testGenreModels = [
      GenreModelBuilder().withId(28).withName('Action').build(),
      GenreModelBuilder().withId(12).withName('Adventure').build(),
      GenreModelBuilder().withId(16).withName('Animation').build(),
    ];

    test('should map genre ids to genres', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(movies.first.genres, ['Action', 'Adventure', 'Animation']);
    });

    test('should map poster url to a https://www.example.com/image.jpg format', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(movies.first.posterUrl,
          '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.POSTER_SIZE}${testMovieModels.first.posterUrl}');
    });

    test('should map backdrop url to a https://www.example.com/image.jpg format', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(movies.first.backdropUrl,
          '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.BACKDROP_SIZE}${testMovieModels.first.backdropUrl}');
    });

    test('should map YYYY-MM-DD date format to DD/MM/YYYY', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(RegExp(r'\d{2}/\d{2}/\d{4}').hasMatch(movies.first.releaseDate), true);
    });

    test('should map language code to language name', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(movies.first.language,
          LanguageLocale.languageMap[testMovieModels.first.languageCode]['name']);
    });

    test('should not map language code to a language name when language code is invalid', () {
      final List<Movie> movies = _mapper.map(testMovieModels, testGenreModels);

      expect(movies.last.language, LanguageLocale.NO_LANGUAGE);
    });
  });
}
