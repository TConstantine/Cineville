import 'package:moor_flutter/moor_flutter.dart';
import 'package:popular_movies/data/database/database.dart';
import 'package:popular_movies/data/database/table/movie_entries.dart';
import 'package:popular_movies/data/database/table/movie_tag_entries.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/resources/untranslatable_stings.dart';

part 'movie_dao.g.dart';

@UseDao(tables: [MovieEntries, MovieTagEntries])
class MovieDao extends DatabaseAccessor<Database> with _$MovieDaoMixin {
  final Database database;

  MovieDao(this.database) : super(database);

  Future<List<MovieModel>> getPopularMovies() {
    return ((select(movieEntries)
              ..orderBy(
                  [(table) => OrderingTerm(expression: table.popularity, mode: OrderingMode.desc)]))
            .join(
      [leftOuterJoin(movieTagEntries, movieTagEntries.movieId.equalsExp(movieEntries.id))],
    )..where(movieTagEntries.name.equals(UntranslatableStrings.POPULAR_MOVIES_CATEGORY)))
        .map((rows) => rows.readTable(movieEntries))
        .map(
          (movieEntry) => MovieModel(
            id: movieEntry.id,
            title: movieEntry.title,
            plotSynopsis: movieEntry.plotSynopsis,
            genreIds: movieEntry.genreIds.split(',').map((genreId) => int.parse(genreId)).toList(),
            rating: movieEntry.rating,
            posterUrl: movieEntry.posterUrl,
            backdropUrl: movieEntry.backdropUrl,
            releaseDate: movieEntry.releaseDate,
            languageCode: movieEntry.languageCode,
            popularity: movieEntry.popularity,
          ),
        )
        .get();
  }

  Future storePopularMovies(List<MovieModel> movieModels) {
    return transaction(() async {
      await into(movieEntries).insertAll(
        movieModels.map((movieModel) {
          return MovieEntry(
              id: movieModel.id,
              title: movieModel.title,
              plotSynopsis: movieModel.plotSynopsis,
              genreIds: movieModel.genreIds.join(','),
              rating: movieModel.rating,
              posterUrl: movieModel.posterUrl,
              backdropUrl: movieModel.backdropUrl,
              releaseDate: movieModel.releaseDate,
              languageCode: movieModel.languageCode,
              popularity: movieModel.popularity);
        }).toList(),
        orReplace: true,
      );
      await into(movieTagEntries).insertAll(
        movieModels.map((movieModel) {
          return MovieTagEntry(
            movieId: movieModel.id,
            name: UntranslatableStrings.POPULAR_MOVIES_CATEGORY,
          );
        }).toList(),
        orReplace: true,
      );
    });
  }
}
