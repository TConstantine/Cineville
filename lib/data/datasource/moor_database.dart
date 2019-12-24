import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/model/video_model.dart';

class MoorDatabase implements LocalDataSource {
  final MovieDao movieDao;
  final GenreDao genreDao;
  final ActorDao actorDao;
  final ReviewDao reviewDao;
  final VideoDao videoDao;

  MoorDatabase(this.movieDao, this.genreDao, this.actorDao, this.reviewDao, this.videoDao);

  @override
  Future<List<ActorModel>> getMovieActors(int movieId) {
    return actorDao.getMovieActors(movieId);
  }

  @override
  Future<List<GenreModel>> getMovieGenres(List<int> genreIds) {
    return genreDao.getMovieGenres(genreIds);
  }

  @override
  Future<List<ReviewModel>> getMovieReviews(int movieId) {
    return reviewDao.getMovieReviews(movieId);
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) {
    return videoDao.getMovieVideos(movieId);
  }

  @override
  Future<List<MovieModel>> getPopularMovies() {
    return movieDao.getPopularMovies();
  }

  @override
  Future<List<MovieModel>> getSimilarMovies(int movieId) {
    return movieDao.getSimilarMovies(movieId);
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() {
    return movieDao.getTopRatedMovies();
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies() {
    return movieDao.getUpcomingMovies();
  }

  @override
  Future removePopularMovies() {
    return movieDao.removePopularMovies();
  }

  @override
  Future removeSimilarMovies(int movieId) {
    return movieDao.removeSimilarMovies(movieId);
  }

  @override
  Future removeTopRatedMovies() {
    return movieDao.removeTopRatedMovies();
  }

  @override
  Future removeUpcomingMovies() {
    return movieDao.removeUpcomingMovies();
  }

  @override
  Future storeMovieGenres(List<GenreModel> genreModels) {
    return genreDao.storeMovieGenres(genreModels);
  }

  @override
  Future storeMovieActors(int movieId, List<ActorModel> actorModels) {
    return actorDao.storeMovieActors(movieId, actorModels);
  }

  @override
  Future storeMovieReviews(int movieId, List<ReviewModel> reviewModels) {
    return reviewDao.storeMovieReviews(movieId, reviewModels);
  }

  @override
  Future storeMovieVideos(int movieId, List<VideoModel> videoModels) {
    return videoDao.storeMovieVideos(movieId, videoModels);
  }

  @override
  Future storePopularMovies(List<MovieModel> models) {
    return movieDao.storePopularMovies(models);
  }

  @override
  Future storeSimilarMovies(int movieId, List<MovieModel> movieModels) {
    return movieDao.storeSimilarMovies(movieId, movieModels);
  }

  @override
  Future storeTopRatedMovies(List<MovieModel> movieModels) {
    return movieDao.storeTopRatedMovies(movieModels);
  }

  @override
  Future storeUpcomingMovies(List<MovieModel> movieModels) {
    return movieDao.storeUpcomingMovies(movieModels);
  }
}
