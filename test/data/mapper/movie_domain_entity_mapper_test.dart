import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/language/language_locale.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';

void main() {
  DataEntityBuilder movieDataEntityBuilder;
  DataEntityBuilder genreDataEntityBuilder;
  MovieDomainEntityMapper movieDomainEntityMapper;

  setUp(() {
    movieDataEntityBuilder = MovieDataEntityBuilder();
    genreDataEntityBuilder = GenreDataEntityBuilder();
    movieDomainEntityMapper = MovieDomainEntityMapper();
  });

  test('should map genre ids to genres', () {
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.genres, ['Action']);
  });

  test('should convert rating from double to string', () {
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.rating is String, true);
  });

  test('should map poster url to a https://www.example.com/image.jpg format', () {
    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(movieDataEntityBuilder.buildList());
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.posterUrl,
        '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.POSTER_SIZE}${movieDataEntities.first.posterUrl}');
  });

  test('should map backdrop url to a https://www.example.com/image.jpg format', () {
    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(movieDataEntityBuilder.buildList());
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.backdropUrl,
        '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.BACKDROP_SIZE}${movieDataEntities.first.backdropUrl}');
  });

  test('should map YYYY-MM-DD date format to (YYYY)', () {
    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(movieDataEntityBuilder.buildList());
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.releaseYear,
        '(${movieDataEntities.first.releaseDate.substring(0, 4)})');
  });

  test('should map language code to language name', () {
    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(movieDataEntityBuilder.buildList());
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.first.language,
        LanguageLocale.languageMap[movieDataEntities.first.languageCode]['name']);
  });

  test('should not map language code to a language name when language code is invalid', () {
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();

    final List<Movie> movieDomainEntities =
        movieDomainEntityMapper.map(movieDataEntities, genreDataEntities);

    expect(movieDomainEntities.last.language, LanguageLocale.NO_LANGUAGE);
  });
}
