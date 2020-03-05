import 'package:cineville/data/entity/data_entity.dart';

abstract class DatabaseDataSource {
  Future<List<DataEntity>> getMovieDataEntities(String dataEntityType, int movieId);
  Future<List<DataEntity>> getMovieGenres(List<int> genreIds);
  Future<List<DataEntity>> getMovies(String movieCategory);
  Future<bool> isMovieMarkedAsFavorite(int movieId);
  Future markMovieAsFavorite(int movieId);
  Future<int> removeMovieFromFavorites(int movieId);
  Future removeMovies(String movieCategory);
  Future removeSimilarMovies(int movieId);
  Future storeMovieDataEntities(String dataEntityType, int movieId, List<DataEntity> dataEntities);
  Future storeMovieGenres(List<DataEntity> dataEntities);
  Future storeMovies(String movieCategory, List<DataEntity> dataEntities);
}
