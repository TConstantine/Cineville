import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/movie_entries.dart';
import 'package:cineville/data/database/table/movie_tag_entries.dart';
import 'package:cineville/data/database/table/similar_movie_entries.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'movie_dao.g.dart';

@UseDao(tables: [MovieEntries, MovieTagEntries, SimilarMovieEntries])
class MovieDao extends DatabaseAccessor<Database> with _$MovieDaoMixin {
  static const int _MAX_LIMIT = 20;
  final Database database;

  MovieDao(this.database) : super(database);

  Future markMovieAsFavorite(int movieId) {
    return into(movieTagEntries).insert(
      MovieTagEntry(
        movieId: movieId,
        name: MovieCategory.FAVORITE,
      ),
      orReplace: true,
    );
  }

  Future<List<DataEntity>> getSimilarMovies(int movieId) async {
    final List<int> similarMovieIds = await (select(similarMovieEntries)
          ..where((table) => table.movieId.equals(movieId)))
        .map((entry) => entry.similarMovieId)
        .get();
    return (select(movieEntries)
          ..limit(_MAX_LIMIT)
          ..where((table) => table.id.isIn(similarMovieIds)))
        .map((movieEntry) => _buildMovieDataEntity(movieEntry))
        .get();
  }

  Future<List<DataEntity>> getMovies(String movieCategory) {
    Expression expression;
    if (movieCategory == MovieCategory.FAVORITE) {
      return _getFavoriteMovies();
    } else if (movieCategory == MovieCategory.UPCOMING) {
      expression = $MovieEntriesTable(database).releaseDate;
    } else if (movieCategory == MovieCategory.TOP_RATED) {
      expression = $MovieEntriesTable(database).rating;
    } else {
      expression = $MovieEntriesTable(database).popularity;
    }
    return _getMovies(expression, movieCategory);
  }

  Future<bool> isMovieMarkedAsFavorite(int movieId) async {
    final List<MovieTagEntry> favoriteMovieList = await (select(movieTagEntries)
          ..where((table) => table.name.equals(MovieCategory.FAVORITE))
          ..where((table) => table.movieId.equals(movieId)))
        .get();
    return favoriteMovieList.isNotEmpty;
  }

  Future<int> removeMovieFromFavorites(int movieId) {
    return delete(movieTagEntries)
        .delete(MovieTagEntry(movieId: movieId, name: MovieCategory.FAVORITE));
  }

  Future removeMovies(String movieCategory) {
    return (delete(movieTagEntries)..where((table) => table.name.equals(movieCategory))).go();
  }

  Future removeSimilarMovies(int movieId) {
    return (delete(similarMovieEntries)..where((table) => table.movieId.equals(movieId))).go();
  }

  Future storeMovies(String movieCategory, List<DataEntity> movieDataEntities) {
    return transaction(() async {
      await _insertMovies(movieDataEntities);
      await _insertMovieTags(movieCategory, movieDataEntities);
    });
  }

  Future storeSimilarMovies(int movieId, List<DataEntity> movieDataEntities) {
    return transaction(() async {
      await _insertMovies(movieDataEntities);
      await _storeSimilarMovies(movieId, movieDataEntities);
    });
  }

  Future<List<DataEntity>> _getFavoriteMovies() {
    return (select(movieEntries).join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(MovieCategory.FAVORITE)))
        .map((rows) => rows.readTable(movieEntries))
        .map((movieEntry) => _buildMovieDataEntity(movieEntry))
        .get();
  }

  Future<List<DataEntity>> _getMovies(Expression expression, String movieCategory) {
    return ((select(movieEntries)
              ..orderBy([(table) => OrderingTerm.desc(expression)])
              ..limit(_MAX_LIMIT))
            .join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(movieCategory)))
        .map((rows) => rows.readTable(movieEntries))
        .map((movieEntry) => _buildMovieDataEntity(movieEntry))
        .get();
  }

  Future _insertMovies(List<DataEntity> movieDataEntities) {
    return batch((batch) {
      batch.insertAll(
        movieEntries,
        List<MovieDataEntity>.from(movieDataEntities).map((movieDataEntity) {
          return MovieEntry(
            id: movieDataEntity.id,
            title: movieDataEntity.title,
            plotSynopsis: movieDataEntity.plotSynopsis,
            genreIds: _joinGenreIds(movieDataEntity.genreIds),
            rating: movieDataEntity.rating,
            posterUrl: movieDataEntity.posterUrl,
            backdropUrl: movieDataEntity.backdropUrl,
            releaseDate: movieDataEntity.releaseDate,
            languageCode: movieDataEntity.languageCode,
            popularity: movieDataEntity.popularity,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future _insertMovieTags(String category, List<DataEntity> movieDataEntities) {
    return batch((batch) {
      batch.insertAll(
        movieTagEntries,
        List<MovieDataEntity>.from(movieDataEntities).map((movieDataEntity) {
          return MovieTagEntry(
            movieId: movieDataEntity.id,
            name: category,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future _storeSimilarMovies(int movieId, List<DataEntity> movieDataEntities) {
    return batch((batch) {
      batch.insertAll(
        similarMovieEntries,
        List<MovieDataEntity>.from(movieDataEntities).map((movieDataEntity) {
          return SimilarMovieEntry(
            movieId: movieId,
            similarMovieId: movieDataEntity.id,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  List<int> _splitGenreIds(String ids) {
    return ids.split(',').map((id) => int.parse(id)).toList();
  }

  String _joinGenreIds(List<int> ids) {
    return ids.join(',');
  }

  DataEntity _buildMovieDataEntity(MovieEntry movieEntry) {
    return MovieDataEntity(
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
