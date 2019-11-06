import 'package:popular_movies/data/database/dao/genre_dao.dart';
import 'package:popular_movies/data/database/dao/movie_dao.dart';
import 'package:popular_movies/data/datasource/local_data_source.dart';
import 'package:popular_movies/data/error/exception/cache_exception.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';

class MoorDatabase implements LocalDataSource {
  final MovieDao _movieDao;
  final GenreDao _genreDao;

  MoorDatabase(this._movieDao, this._genreDao);

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final List<MovieModel> movieDaos = await _movieDao.getPopularMovies();
    if (movieDaos.isEmpty) {
      throw CacheException();
    }
    return movieDaos;
  }

  @override
  Future storePopularMovies(List<MovieModel> movieDaos) {
    return _movieDao.storePopularMovies(movieDaos);
  }

  @override
  Future<List<GenreModel>> getGenres(List<int> genreIds) {
    return _genreDao.getGenres(genreIds);
  }

  @override
  Future storeGenres(List<GenreModel> genreDaos) {
    return _genreDao.storeGenres(genreDaos);
  }
}
