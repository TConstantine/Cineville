import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';

class MoorDatabase implements LocalDataSource {
  final MovieDao _movieDao;
  final GenreDao _genreDao;

  MoorDatabase(this._movieDao, this._genreDao);

  @override
  Future<List<GenreModel>> getGenres(List<int> genreIds) {
    return _genreDao.getGenres(genreIds);
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return await _movieDao.getPopularMovies();
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return await _movieDao.getTopRatedMovies();
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    return await _movieDao.getUpcomingMovies();
  }

  @override
  Future storeGenres(List<GenreModel> genreDaos) {
    return _genreDao.storeGenres(genreDaos);
  }

  @override
  Future storePopularMovies(List<MovieModel> movieDaos) {
    return _movieDao.storePopularMovies(movieDaos);
  }

  @override
  Future storeTopRatedMovies(List<MovieModel> movieDaos) {
    return _movieDao.storeTopRatedMovies(movieDaos);
  }

  @override
  Future storeUpcomingMovies(List<MovieModel> movieDaos) {
    return _movieDao.storeUpcomingMovies(movieDaos);
  }
}
