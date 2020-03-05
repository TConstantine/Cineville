import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';

class MoorDatabaseDataSource implements DatabaseDataSource {
  final MovieDao _movieDao;
  final GenreDao _genreDao;
  final ActorDao _actorDao;
  final ReviewDao _reviewDao;
  final VideoDao _videoDao;

  MoorDatabaseDataSource(
    this._movieDao,
    this._genreDao,
    this._actorDao,
    this._reviewDao,
    this._videoDao,
  );

  @override
  Future<List<DataEntity>> getMovieDataEntities(String dataEntityType, int movieId) {
    if (dataEntityType == DataEntityType.ACTOR) {
      return _actorDao.getMovieActors(movieId);
    } else if (dataEntityType == DataEntityType.REVIEW) {
      return _reviewDao.getMovieReviews(movieId);
    } else if (dataEntityType == DataEntityType.SIMILAR_MOVIE) {
      return _movieDao.getSimilarMovies(movieId);
    } else {
      return _videoDao.getMovieVideos(movieId);
    }
  }

  @override
  Future<List<DataEntity>> getMovieGenres(List<int> genreIds) {
    return _genreDao.getMovieGenres(genreIds);
  }

  @override
  Future<List<DataEntity>> getMovies(String movieCategory) {
    return _movieDao.getMovies(movieCategory);
  }

  @override
  Future<bool> isMovieMarkedAsFavorite(int movieId) {
    return _movieDao.isMovieMarkedAsFavorite(movieId);
  }

  @override
  Future markMovieAsFavorite(int movieId) {
    return _movieDao.markMovieAsFavorite(movieId);
  }

  @override
  Future<int> removeMovieFromFavorites(int movieId) {
    return _movieDao.removeMovieFromFavorites(movieId);
  }

  @override
  Future removeMovies(String movieCategory) {
    return _movieDao.removeMovies(movieCategory);
  }

  @override
  Future removeSimilarMovies(int movieId) {
    return _movieDao.removeSimilarMovies(movieId);
  }

  @override
  Future storeMovieGenres(List<DataEntity> dataEntities) {
    return _genreDao.storeMovieGenres(dataEntities);
  }

  @override
  Future storeMovieDataEntities(String dataEntityType, int movieId, List<DataEntity> dataEntities) {
    if (dataEntityType == DataEntityType.ACTOR) {
      return _actorDao.storeMovieActors(movieId, dataEntities);
    } else if (dataEntityType == DataEntityType.REVIEW) {
      return _reviewDao.storeMovieReviews(movieId, dataEntities);
    } else if (dataEntityType == DataEntityType.SIMILAR_MOVIE) {
      return _movieDao.storeSimilarMovies(movieId, dataEntities);
    } else {
      return _videoDao.storeMovieVideos(movieId, dataEntities);
    }
  }

  @override
  Future storeMovies(String movieCategory, List<DataEntity> dataEntities) {
    return _movieDao.storeMovies(movieCategory, dataEntities);
  }
}
