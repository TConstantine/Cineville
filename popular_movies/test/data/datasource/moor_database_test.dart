import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:popular_movies/data/database/dao/genre_dao.dart';
import 'package:popular_movies/data/database/dao/movie_dao.dart';
import 'package:popular_movies/data/datasource/local_data_source.dart';
import 'package:popular_movies/data/datasource/moor_database.dart';
import 'package:popular_movies/data/error/exception/cache_exception.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';

import '../../builder/genre_model_builder.dart';
import '../../builder/movie_model_builder.dart';

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

  final List<MovieModel> testMovieModels = List.generate(3, (_) => MovieModelBuilder().build());
  final List<GenreModel> testGenreModels = List.generate(3, (_) => GenreModelBuilder().build());

  group('getPopularMovies', () {
    test('should return a list of movie daos from the database', () async {
      when(_mockMovieDao.getPopularMovies()).thenAnswer((_) async => testMovieModels);

      final List<MovieModel> movieModels = await _dataSource.getPopularMovies();

      verify(_mockMovieDao.getPopularMovies());
      expect(movieModels, equals(testMovieModels));
    });

    test('should throw a cache exception when the database is empty', () async {
      when(_mockMovieDao.getPopularMovies()).thenAnswer((_) async => []);

      final call = _dataSource.getPopularMovies;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('storePopularMovies', () {
    test('should store popular movies in database', () {
      _dataSource.storePopularMovies(testMovieModels);

      verify(_mockMovieDao.storePopularMovies(testMovieModels));
    });
  });

  group('getGenres', () {
    final List<int> testGenreIds = [1, 2, 3];

    test('should return a list of genre daos from the database', () async {
      when(_mockGenreDao.getGenres(any)).thenAnswer((_) async => testGenreModels);

      final List<GenreModel> genreModels = await _dataSource.getGenres(testGenreIds);

      verify(_mockGenreDao.getGenres(testGenreIds));
      expect(genreModels, equals(testGenreModels));
    });
  });

  group('storeGenres', () {
    test('should store genres in database', () {
      _dataSource.storeGenres(testGenreModels);

      verify(_mockGenreDao.storeGenres(testGenreModels));
    });
  });
}
