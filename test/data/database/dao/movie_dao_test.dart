import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../test_util/test_movie_model_builder.dart';

void main() {
  Database database;
  MovieDao dao;

  setUp(() {
    database = Database(VmDatabase.memory());
    dao = MovieDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('getPopularMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> movieModels = await dao.getPopularMovies();

      expect(movieModels.isEmpty, true);
    });

    test('should return movies ordered by popularity in descending order', () async {
      final List<double> testPopularity = [23.0, 10.0, 36.0];
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels = TestMovieModelBuilder()
          .withMovieIds(testMovieIds)
          .withPopularity(testPopularity)
          .buildMultiple();
      await dao.storePopularMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getPopularMovies();

      expect(movieModels.length, 3);
      expect(movieModels[0].popularity, 36.0);
      expect(movieModels[1].popularity, 23.0);
      expect(movieModels[2].popularity, 10.0);
    });
  });

  group('getSimilarMovies', () {
    test('should not return any movies', () async {
      final int testMovieId = 1;

      final List<MovieModel> movieModels = await dao.getSimilarMovies(testMovieId);

      expect(movieModels.isEmpty, true);
    });

    test('should return similar movies for a specific movie id', () async {
      final int testMovieId = 1;
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds([5, 10, 8]).buildMultiple();
      final List<MovieModel> testMovieModels2 =
          TestMovieModelBuilder().withMovieIds([11, 15, 26]).buildMultiple();
      await dao.storeSimilarMovies(testMovieId, testMovieModels2);
      await dao.storeSimilarMovies(testMovieId + 1, testMovieModels);

      final List<MovieModel> movieModels = await dao.getSimilarMovies(testMovieId);

      expect(movieModels.length, 3);
      expect(movieModels[0].id, 11);
      expect(movieModels[1].id, 15);
      expect(movieModels[2].id, 26);
    });
  });

  group('getTopRatedMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> movieModels = await dao.getTopRatedMovies();

      expect(movieModels.isEmpty, true);
    });

    test('should return movies ordered by rating in descending order', () async {
      final List<double> testRatings = [23.0, 10.0, 36.0];
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels = TestMovieModelBuilder()
          .withMovieIds(testMovieIds)
          .withRatings(testRatings)
          .buildMultiple();
      await dao.storeTopRatedMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getTopRatedMovies();

      expect(movieModels.length, 3);
      expect(movieModels[0].rating, 36.0);
      expect(movieModels[1].rating, 23.0);
      expect(movieModels[2].rating, 10.0);
    });
  });

  group('getUpcomingMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> movieModels = await dao.getUpcomingMovies();

      expect(movieModels.isEmpty, true);
    });

    test('should return movies ordered by release date in descending order', () async {
      final List<String> testReleaseDates = ['2005-01-01', '2000-01-01', '2010-01-01'];
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels = TestMovieModelBuilder()
          .withMovieIds(testMovieIds)
          .withReleaseDates(testReleaseDates)
          .buildMultiple();
      await dao.storeUpcomingMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getUpcomingMovies();

      expect(movieModels.length, 3);
      expect(movieModels[0].releaseDate, '2010-01-01');
      expect(movieModels[1].releaseDate, '2005-01-01');
      expect(movieModels[2].releaseDate, '2000-01-01');
    });
  });

  group('removePopularMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
      await dao.storePopularMovies(testMovieModels);

      await dao.removePopularMovies();

      final List<MovieModel> movieModels = await dao.getPopularMovies();
      expect(movieModels.isEmpty, true);
    });
  });

  group('removeSimilarMovies', () {
    test('should not return any movies', () async {
      final int testMovieId = 1;
      final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
      await dao.storeSimilarMovies(testMovieId, testMovieModels);

      await dao.removeSimilarMovies(testMovieId);

      final List<MovieModel> movieModels = await dao.getSimilarMovies(testMovieId);
      expect(movieModels.isEmpty, true);
    });
  });

  group('removeTopRatedMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
      await dao.storeTopRatedMovies(testMovieModels);

      await dao.removeTopRatedMovies();

      final List<MovieModel> movieModels = await dao.getTopRatedMovies();
      expect(movieModels.isEmpty, true);
    });
  });

  group('removeUpcomingMovies', () {
    test('should not return any movies', () async {
      final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
      await dao.storeUpcomingMovies(testMovieModels);

      await dao.removeUpcomingMovies();

      final List<MovieModel> movieModels = await dao.getUpcomingMovies();
      expect(movieModels.isEmpty, true);
    });
  });

  group('storePopularMovies', () {
    test('should store popular movies', () async {
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storePopularMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getPopularMovies();
      expect(movieModels.length, testMovieModels.length);
    });

    test('should not create new entries for movies that are already stored', () async {
      final List<int> testMovieIds = List.generate(3, (_) => 1);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storePopularMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getPopularMovies();
      expect(movieModels.length, 1);
    });
  });

  group('storeSimilarMovies', () {
    test('should store similar movies', () async {
      final int testMovieId = 5;
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeSimilarMovies(testMovieId, testMovieModels);

      final List<MovieModel> movieModels = await dao.getSimilarMovies(testMovieId);
      expect(movieModels.length, testMovieModels.length);
    });

    test('should not create new entries for movies that are already stored', () async {
      final int testMovieId = 5;
      final List<int> testMovieIds = List.generate(3, (_) => 1);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeSimilarMovies(testMovieId, testMovieModels);

      final List<MovieModel> movieModels = await dao.getSimilarMovies(testMovieId);
      expect(movieModels.length, 1);
    });
  });

  group('storeTopRatedMovies', () {
    test('should store top rated movies', () async {
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeTopRatedMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getTopRatedMovies();
      expect(movieModels.length, testMovieModels.length);
    });

    test('should not create new entries for movies that are already stored', () async {
      final List<int> testMovieIds = [1, 1, 1];
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeTopRatedMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getTopRatedMovies();
      expect(movieModels.length, 1);
    });
  });

  group('storeUpcomingMovies', () {
    test('should store upcoming movies', () async {
      final List<int> testMovieIds = List.generate(3, (index) => index);
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeUpcomingMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getUpcomingMovies();
      expect(movieModels.length, testMovieModels.length);
    });

    test('should not create new entries for movies that are already stored', () async {
      final List<int> testMovieIds = [1, 1, 1];
      final List<MovieModel> testMovieModels =
          TestMovieModelBuilder().withMovieIds(testMovieIds).buildMultiple();

      await dao.storeUpcomingMovies(testMovieModels);

      final List<MovieModel> movieModels = await dao.getUpcomingMovies();
      expect(movieModels.length, 1);
    });
  });
}
