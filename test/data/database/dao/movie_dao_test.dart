import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../builder/data_entity_builder.dart';
import '../../../builder/movie_data_entity_builder.dart';

void main() {
  DataEntityBuilder movieDataEntityBuilder;
  Database database;
  MovieDao movieDao;

  setUp(() {
    movieDataEntityBuilder = MovieDataEntityBuilder();
    database = Database(VmDatabase.memory());
    movieDao = MovieDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('when cache is empty', () {
    void getMovies(String movieCategory) {
      test('should not return any $movieCategory movies', () async {
        final List<DataEntity> movieDataEntities = await movieDao.getMovies(movieCategory);

        expect(movieDataEntities.isEmpty, true);
      });
    }

    getMovies(MovieCategory.POPULAR);
    getMovies(MovieCategory.TOP_RATED);
    getMovies(MovieCategory.UPCOMING);
  });

  test(
      'should return popular movies ordered by popularity in descending order when cache is not empty',
      () async {
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
    await movieDao.storeMovies(MovieCategory.POPULAR, movieDataEntityList);

    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(await movieDao.getMovies(MovieCategory.POPULAR));

    expect(movieDataEntities.length, movieDataEntityList.length);
    expect(movieDataEntities.first.popularity, 532.535);
    expect(movieDataEntities[1].popularity, 309.264);
    expect(movieDataEntities.last.popularity, 0);
  });

  test(
      'should return top rated movies ordered by rating in descending order when cache is not empty',
      () async {
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
    await movieDao.storeMovies(MovieCategory.TOP_RATED, movieDataEntityList);

    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(await movieDao.getMovies(MovieCategory.TOP_RATED));

    expect(movieDataEntities.length, movieDataEntityList.length);
    expect(movieDataEntities.first.rating, 6.6);
    expect(movieDataEntities[1].rating, 6.3);
    expect(movieDataEntities.last.rating, 0);
  });

  test(
      'should return upcoming movies ordered by release date in descending order when cache is not empty',
      () async {
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
    await movieDao.storeMovies(MovieCategory.UPCOMING, movieDataEntityList);

    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(await movieDao.getMovies(MovieCategory.UPCOMING));

    expect(movieDataEntities.length, movieDataEntityList.length);
    expect(movieDataEntities.first.releaseDate, '2019-12-20');
    expect(movieDataEntities[1].releaseDate, '2019-12-18');
    expect(movieDataEntities.last.releaseDate, '2019-09-17');
  });

  group('storeMovies', () {
    void storeMovies(String movieCategory) {
      test('should store $movieCategory movies', () async {
        final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();

        await movieDao.storeMovies(movieCategory, movieDataEntityList);

        final List<DataEntity> movieDataEntities = await movieDao.getMovies(movieCategory);
        expect(movieDataEntities.length, movieDataEntityList.length);
      });
    }

    storeMovies(MovieCategory.POPULAR);
    storeMovies(MovieCategory.TOP_RATED);
    storeMovies(MovieCategory.UPCOMING);
  });

  group('storeMovies', () {
    void storeMovies(String movieCategory) {
      test('should not create duplicate $movieCategory movie entries', () async {
        final DataEntity movieDataEntity = movieDataEntityBuilder.build();
        final List<DataEntity> movieDataEntityList = [
          movieDataEntity,
          movieDataEntity,
          movieDataEntity,
        ];

        await movieDao.storeMovies(movieCategory, movieDataEntityList);

        final List<DataEntity> movieDataEntities = await movieDao.getMovies(movieCategory);
        expect(movieDataEntities.length, 1);
      });
    }

    storeMovies(MovieCategory.POPULAR);
    storeMovies(MovieCategory.TOP_RATED);
    storeMovies(MovieCategory.UPCOMING);
  });

  group('when cache is not empty', () {
    void removeMovies(String movieCategory) {
      test('should remove $movieCategory movies from cache', () async {
        final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
        await movieDao.storeMovies(movieCategory, movieDataEntityList);

        await movieDao.removeMovies(movieCategory);

        final List<DataEntity> movieDataEntities = await movieDao.getMovies(movieCategory);
        expect(movieDataEntities.isEmpty, true);
      });
    }

    removeMovies(MovieCategory.POPULAR);
    removeMovies(MovieCategory.TOP_RATED);
    removeMovies(MovieCategory.UPCOMING);
  });

  test('should not return any similar movies when cache is empty', () async {
    final int movieId = 1;

    final List<DataEntity> movieDataEntities = await movieDao.getSimilarMovies(movieId);

    expect(movieDataEntities.isEmpty, true);
  });

  test('should return similar movies when cache is not empty', () async {
    final int movieId = 1;
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
    await movieDao.storeSimilarMovies(movieId, movieDataEntityList);

    final List<MovieDataEntity> movieDataEntities =
        List<MovieDataEntity>.from(await movieDao.getSimilarMovies(movieId));

    expect(movieDataEntities.length, movieDataEntityList.length);
    expect(movieDataEntities.first.id, 181812);
    expect(movieDataEntities[1].id, 419704);
    expect(movieDataEntities.last.id, 449924);
  });

  test('should store similar movies', () async {
    final int movieId = 1;
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();

    await movieDao.storeSimilarMovies(movieId, movieDataEntityList);

    final List<DataEntity> movieDataEntities = await movieDao.getSimilarMovies(movieId);
    expect(movieDataEntities.length, movieDataEntityList.length);
  });

  test('should not create duplicate similar movie entries', () async {
    final int movieId = 1;
    final DataEntity movieDataEntity = movieDataEntityBuilder.build();
    final List<DataEntity> movieDataEntityList = [
      movieDataEntity,
      movieDataEntity,
      movieDataEntity
    ];

    await movieDao.storeSimilarMovies(movieId, movieDataEntityList);

    final List<DataEntity> movieDataEntities = await movieDao.getSimilarMovies(movieId);
    expect(movieDataEntities.length, 1);
  });

  test('should remove similar movies from cache when cache is not empty', () async {
    final int movieId = 1;
    final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
    await movieDao.storeSimilarMovies(movieId, movieDataEntityList);

    await movieDao.removeSimilarMovies(movieId);

    final List<DataEntity> movieDataEntities = await movieDao.getSimilarMovies(movieId);
    expect(movieDataEntities.isEmpty, true);
  });

  group('markMovieAsFavorite', () {
    void markMovieAsFavorite(String movieCategory) {
      test('should add $movieCategory movie to favorites', () async {
        final MovieDataEntity movieDataEntity = movieDataEntityBuilder.build();
        await movieDao.storeMovies(movieCategory, [movieDataEntity]);

        await movieDao.markMovieAsFavorite(movieDataEntity.id);

        final List<DataEntity> movieDataEntities = await movieDao.getMovies(MovieCategory.FAVORITE);
        expect(movieDataEntities.isEmpty, false);
        expect(movieDataEntities.length, 1);
      });
    }

    markMovieAsFavorite(MovieCategory.POPULAR);
    markMovieAsFavorite(MovieCategory.TOP_RATED);
    markMovieAsFavorite(MovieCategory.UPCOMING);
  });

  group('isMovieFavorite', () {
    void isMovieFavorite(String movieCategory) {
      test('should return true when $movieCategory movie is favorite', () async {
        final MovieDataEntity movieDataEntity = movieDataEntityBuilder.build();
        await movieDao.storeMovies(movieCategory, [movieDataEntity]);
        await movieDao.markMovieAsFavorite(movieDataEntity.id);

        final bool isFavorite = await movieDao.isMovieMarkedAsFavorite(movieDataEntity.id);

        expect(isFavorite, true);
      });
    }

    isMovieFavorite(MovieCategory.POPULAR);
    isMovieFavorite(MovieCategory.TOP_RATED);
    isMovieFavorite(MovieCategory.UPCOMING);
  });

  group('isMovieFavorite', () {
    void isMovieFavorite(String movieCategory) {
      test('should return false when $movieCategory movie is not favorite', () async {
        final MovieDataEntity movieDataEntity = movieDataEntityBuilder.build();
        await movieDao.storeMovies(movieCategory, [movieDataEntity]);

        final bool isFavorite = await movieDao.isMovieMarkedAsFavorite(movieDataEntity.id);

        expect(isFavorite, false);
      });
    }

    isMovieFavorite(MovieCategory.POPULAR);
    isMovieFavorite(MovieCategory.TOP_RATED);
    isMovieFavorite(MovieCategory.UPCOMING);
  });

  group('removeMovieFromFavorites', () {
    void removeMovieFromFavorites(String movieCategory) {
      test('should remove $movieCategory movie from favorites', () async {
        final MovieDataEntity movieDataEntity = movieDataEntityBuilder.build();
        await movieDao.storeMovies(movieCategory, [movieDataEntity]);
        await movieDao.markMovieAsFavorite(movieDataEntity.id);

        await movieDao.removeMovieFromFavorites(movieDataEntity.id);

        final List<DataEntity> movieDataEntities = await movieDao.getMovies(MovieCategory.FAVORITE);
        expect(movieDataEntities.isEmpty, true);
      });
    }

    removeMovieFromFavorites(MovieCategory.POPULAR);
    removeMovieFromFavorites(MovieCategory.TOP_RATED);
    removeMovieFromFavorites(MovieCategory.UPCOMING);
  });
}
