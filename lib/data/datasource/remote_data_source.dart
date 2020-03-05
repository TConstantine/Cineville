import 'package:cineville/data/entity/data_entity.dart';

abstract class RemoteDataSource {
  Future<List<DataEntity>> getMovieDataEntities(String dataEntityType, int movieId);
  Future<List<DataEntity>> getMovieGenres();
  Future<List<DataEntity>> getMovies(String movieCategory, int page);
}
