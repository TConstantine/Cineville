import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/moor_database.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_genre_model_builder.dart';
import '../../test_util/test_movie_model_builder.dart';

class MockMovieDao extends Mock implements MovieDao {}

class MockGenreDao extends Mock implements GenreDao {}

void main() {
  MovieDao _mockMovieDao;
  GenreDao _mockGenreDao;
  LocalDataSource _dataSource;

  setUp(() {
    _mockMovieDao = MockMovieDao();
    _mockGenreDao = MockGenreDao();
    _dataSource = MoorDatabase(_mockMovieDao, _mockGenreDao);
  });

  final List<MovieModel> testMovieModels = TestMovieModelBuilder().buildMultiple();
  final List<GenreModel> testGenreModels = TestGenreModelBuilder().buildMultiple();
  final List<int> testGenreIds = [1, 2, 3];

  group('getGenres', () {
    test('should return a list of genre daos from the database', () async {
      when(_mockGenreDao.getGenres(any)).thenAnswer((_) async => testGenreModels);

      final List<GenreModel> genreModels = await _dataSource.getGenres(testGenreIds);

      verify(_mockGenreDao.getGenres(testGenreIds));
      expect(genreModels, equals(testGenreModels));
    });
  });

  group('getPopularMovies', () {
    test('should return a list of movie daos from the database', () async {
      when(_mockMovieDao.getPopularMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await _dataSource.getPopularMovies();

      verify(_mockMovieDao.getPopularMovies());
      expect(movieModels, equals(testMovieModels));
    });
  });

  group('getTopRatedMovies', () {
    test('should return a list of movie daos from the database', () async {
      when(_mockMovieDao.getTopRatedMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await _dataSource.getTopRatedMovies();

      verify(_mockMovieDao.getTopRatedMovies());
      expect(movieModels, equals(testMovieModels));
    });
  });

  group('storeGenres', () {
    test('should store genres in database', () {
      _dataSource.storeGenres(testGenreModels);

      verify(_mockGenreDao.storeGenres(testGenreModels));
    });
  });

  group('storePopularMovies', () {
    test('should store popular movies in database', () {
      _dataSource.storePopularMovies(testMovieModels);

      verify(_mockMovieDao.storePopularMovies(testMovieModels));
    });
  });

  group('storeTopRatedMovies', () {
    test('should store top rated movies in database', () {
      _dataSource.storeTopRatedMovies(testMovieModels);

      verify(_mockMovieDao.storeTopRatedMovies(testMovieModels));
    });
  });
}
