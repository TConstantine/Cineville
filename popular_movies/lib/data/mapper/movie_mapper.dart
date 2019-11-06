import 'package:popular_movies/data/language/language_locale.dart';
import 'package:popular_movies/data/model/genre_model.dart';
import 'package:popular_movies/data/model/movie_model.dart';
import 'package:popular_movies/data/network/tmdb_api_constant.dart';
import 'package:popular_movies/domain/entity/movie.dart';

class MovieMapper {
  List<Movie> map(List<MovieModel> movieDaos, List<GenreModel> genreDaos) {
    final List<Movie> movies = [];
    movieDaos.forEach((movieDao) => movies.add(Movie(
        id: movieDao.id,
        title: movieDao.title,
        plotSynopsis: movieDao.plotSynopsis,
        genres: _mapGenreIds(movieDao.genreIds, genreDaos),
        rating: movieDao.rating,
        posterUrl: _mapPosterUrl(movieDao.posterUrl),
        backdropUrl: _mapBackdropUrl(movieDao.backdropUrl),
        releaseDate: _mapReleaseDate(movieDao.releaseDate),
        language: _mapLanguageCode(movieDao.languageCode),
        popularity: movieDao.popularity)));
    return movies;
  }

  List<String> _mapGenreIds(List<int> genreIds, List<GenreModel> genreDaos) {
    final List<String> genres = [];
    genreDaos.forEach((genreDao) {
      if (genreIds.contains(genreDao.id)) {
        genres.add(genreDao.name);
      }
    });
    return genres;
  }

  String _mapPosterUrl(String posterUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.POSTER_SIZE}$posterUrl';
  }

  String _mapBackdropUrl(String backdropUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.BACKDROP_SIZE}$backdropUrl';
  }

  String _mapReleaseDate(String releaseDate) {
    return releaseDate.split('-').reversed.join('/');
  }

  String _mapLanguageCode(String languageCode) {
    if (LanguageLocale.languageMap.containsKey(languageCode)) {
      return LanguageLocale.languageMap[languageCode]['name'];
    }
    return LanguageLocale.NO_LANGUAGE;
  }
}
