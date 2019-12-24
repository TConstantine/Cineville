import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/movie_entries.dart';
import 'package:cineville/data/database/table/movie_tag_entries.dart';
import 'package:cineville/data/database/table/similar_movie_entries.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'movie_dao.g.dart';

@UseDao(tables: [MovieEntries, MovieTagEntries, SimilarMovieEntries])
class MovieDao extends DatabaseAccessor<Database> with _$MovieDaoMixin {
  static const int _MAX_LIMIT = 20;
  final Database database;

  MovieDao(this.database) : super(database);

  Future<List<MovieModel>> getPopularMovies() {
    return ((select(movieEntries)
              ..orderBy([
                (table) => OrderingTerm(
                      expression: table.popularity,
                      mode: OrderingMode.desc,
                    )
              ])
              ..limit(_MAX_LIMIT))
            .join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(MovieCategory.POPULAR)))
        .map((rows) => rows.readTable(movieEntries))
        .map((movieEntry) => _buildMovieModel(movieEntry))
        .get();
  }

  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    final List<int> similarMovieIds = await (select(similarMovieEntries)
          ..where((table) => table.movieId.equals(movieId)))
        .map((entry) => entry.similarMovieId)
        .get();
    return (select(movieEntries)
          ..limit(_MAX_LIMIT)
          ..where((table) => isIn(table.id, similarMovieIds)))
        .map((movieEntry) => _buildMovieModel(movieEntry))
        .get();
  }

  Future<List<MovieModel>> getTopRatedMovies() {
    return ((select(movieEntries)
              ..orderBy([
                (table) => OrderingTerm(
                      expression: table.rating,
                      mode: OrderingMode.desc,
                    )
              ])
              ..limit(_MAX_LIMIT))
            .join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(MovieCategory.TOP_RATED)))
        .map((rows) => rows.readTable(movieEntries))
        .map((movieEntry) => _buildMovieModel(movieEntry))
        .get();
  }

  Future<List<MovieModel>> getUpcomingMovies() {
    return ((select(movieEntries)
              ..orderBy([
                (table) => OrderingTerm(
                      expression: table.releaseDate,
                      mode: OrderingMode.desc,
                    )
              ])
              ..limit(_MAX_LIMIT))
            .join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(MovieCategory.UPCOMING)))
        .map((rows) => rows.readTable(movieEntries))
        .map((movieEntry) => _buildMovieModel(movieEntry))
        .get();
  }

  Future removePopularMovies() {
    return (delete(movieTagEntries)..where((table) => table.name.equals(MovieCategory.POPULAR)))
        .go();
  }

  Future removeSimilarMovies(int movieId) {
    return (delete(similarMovieEntries)..where((table) => table.movieId.equals(movieId))).go();
  }

  Future removeTopRatedMovies() {
    return (delete(movieTagEntries)..where((table) => table.name.equals(MovieCategory.TOP_RATED)))
        .go();
  }

  Future removeUpcomingMovies() {
    return (delete(movieTagEntries)..where((table) => table.name.equals(MovieCategory.UPCOMING)))
        .go();
  }

  Future storePopularMovies(List<MovieModel> movieModels) {
    return transaction(() async {
      await _storeMovies(movieModels);
      await _storeMovieTags(movieModels, MovieCategory.POPULAR);
    });
  }

  Future storeSimilarMovies(int movieId, List<MovieModel> movieModels) {
    return transaction(() async {
      await _storeMovies(movieModels);
      await _storeSimilarMovies(movieId, movieModels);
    });
  }

  Future storeTopRatedMovies(List<MovieModel> movieModels) {
    return transaction(() async {
      await _storeMovies(movieModels);
      await _storeMovieTags(movieModels, MovieCategory.TOP_RATED);
    });
  }

  Future storeUpcomingMovies(List<MovieModel> movieModels) {
    return transaction(() async {
      await _storeMovies(movieModels);
      await _storeMovieTags(movieModels, MovieCategory.UPCOMING);
    });
  }

  Future _storeMovies(List<MovieModel> movieModels) {
    return into(movieEntries).insertAll(
      movieModels.map((movieModel) {
        return MovieEntry(
          id: movieModel.id,
          title: movieModel.title,
          plotSynopsis: movieModel.plotSynopsis,
          genreIds: _joinGenreIds(movieModel.genreIds),
          rating: movieModel.rating,
          posterUrl: movieModel.posterUrl,
          backdropUrl: movieModel.backdropUrl,
          releaseDate: movieModel.releaseDate,
          languageCode: movieModel.languageCode,
          popularity: movieModel.popularity,
        );
      }).toList(),
      orReplace: true,
    );
  }

  Future _storeMovieTags(List<MovieModel> movieModels, String category) {
    return into(movieTagEntries).insertAll(
      movieModels.map((movieModel) {
        return MovieTagEntry(
          movieId: movieModel.id,
          name: category,
        );
      }).toList(),
      orReplace: true,
    );
  }

  Future _storeSimilarMovies(int movieId, List<MovieModel> movieModels) {
    return into(similarMovieEntries).insertAll(
      movieModels.map((movieModel) {
        return SimilarMovieEntry(
          movieId: movieId,
          similarMovieId: movieModel.id,
        );
      }).toList(),
      orReplace: true,
    );
  }

  List<int> _splitGenreIds(String ids) {
    return ids.split(',').map((id) => int.parse(id)).toList();
  }

  String _joinGenreIds(List<int> ids) {
    return ids.join(',');
  }

  MovieModel _buildMovieModel(MovieEntry movieEntry) {
    return MovieModel(
      id: movieEntry.id,
      title: movieEntry.title,
      plotSynopsis: movieEntry.plotSynopsis,
      genreIds: _splitGenreIds(movieEntry.genreIds),
      rating: movieEntry.rating,
      posterUrl: movieEntry.posterUrl,
      backdropUrl: movieEntry.backdropUrl,
      releaseDate: movieEntry.releaseDate,
      languageCode: movieEntry.languageCode,
      popularity: movieEntry.popularity,
    );
  }
}
