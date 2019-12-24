import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../test_util/test_genre_model_builder.dart';

void main() {
  Database database;
  GenreDao dao;

  setUp(() {
    database = Database(VmDatabase.memory());
    dao = GenreDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('getMovieGenres', () {
    test('should not return any genres', () async {
      final List<int> testGenreIds = [1, 2, 3];

      final List<GenreModel> genreModels = await dao.getMovieGenres(testGenreIds);

      expect(genreModels.isEmpty, true);
    });

    test('should return genres for the specified ids', () async {
      final List<int> testGenreIds = [1, 3];
      final List<GenreModel> testGenreModels =
          TestGenreModelBuilder().withIds([1, 2, 3]).buildMultiple();

      await dao.storeMovieGenres(testGenreModels);

      final List<GenreModel> genreModels = await dao.getMovieGenres(testGenreIds);

      expect(genreModels.length, 2);
      expect(genreModels[0].id, 1);
      expect(genreModels[1].id, 3);
    });

    test('should return genres ordered by name', () async {
      final List<int> testGenreIds = [1, 2, 3];
      final List<String> testGenreNames = ['Drama', 'Fantasy', 'Comedy'];
      final List<GenreModel> testGenreModels =
          TestGenreModelBuilder().withIds(testGenreIds).withNames(testGenreNames).buildMultiple();
      await dao.storeMovieGenres(testGenreModels);

      final List<GenreModel> genreModels = await dao.getMovieGenres(testGenreIds);

      expect(genreModels.length, 3);
      expect(genreModels[0].name, 'Comedy');
      expect(genreModels[1].name, 'Drama');
      expect(genreModels[2].name, 'Fantasy');
    });
  });

  group('storeMovieGenres', () {
    test('should store genres', () async {
      final List<int> testGenreIds = [1, 2, 3];
      final List<GenreModel> testGenreModels =
          TestGenreModelBuilder().withIds(testGenreIds).buildMultiple();

      await dao.storeMovieGenres(testGenreModels);

      final List<GenreModel> genreModels = await dao.getMovieGenres(testGenreIds);
      expect(genreModels.length, testGenreModels.length);
    });

    test('should not create new entries for genres that are already stored', () async {
      final List<int> testGenreIds = [1, 2, 3];
      final List<GenreModel> testGenreModels =
          TestGenreModelBuilder().withIds([1, 1, 1]).buildMultiple();

      await dao.storeMovieGenres(testGenreModels);

      final List<GenreModel> genreModels = await dao.getMovieGenres(testGenreIds);
      expect(genreModels.length, 1);
    });
  });
}
