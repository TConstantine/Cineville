import 'package:cineville/data/language/language_locale.dart';
import 'package:cineville/data/model/genre_model.dart';
import 'package:cineville/data/model/movie_model.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/movie.dart';

class MovieMapper {
  List<Movie> map(List<MovieModel> movieModels, List<GenreModel> genreModels) {
    final List<Movie> entities = [];
    movieModels.forEach((model) => entities.add(Movie(
        id: model.id,
        title: model.title,
        plotSynopsis: model.plotSynopsis,
        genres: _mapGenreIds(model.genreIds, genreModels),
        rating: _mapRating(model.rating),
        posterUrl: _mapPosterUrl(model.posterUrl),
        backdropUrl: _mapBackdropUrl(model.backdropUrl),
        releaseYear: _mapReleaseDate(model.releaseDate),
        language: _mapLanguageCode(model.languageCode),
        popularity: model.popularity)));
    return entities;
  }

  List<String> _mapGenreIds(List<int> genreIds, List<GenreModel> models) {
    final List<String> entities = [];
    models.forEach((model) {
      if (genreIds.contains(model.id)) {
        entities.add(model.name);
      }
    });
    return entities;
  }

  String _mapRating(double rating) {
    return rating.toString();
  }

  String _mapPosterUrl(String posterUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.POSTER_SIZE}$posterUrl';
  }

  String _mapBackdropUrl(String backdropUrl) {
    return '${TmdbApiConstant.BASE_IMAGE_URL}${TmdbApiConstant.BACKDROP_SIZE}$backdropUrl';
  }

  String _mapReleaseDate(String releaseDate) {
    return '(${releaseDate.split('-').first})';
  }

  String _mapLanguageCode(String languageCode) {
    if (LanguageLocale.languageMap.containsKey(languageCode)) {
      return LanguageLocale.languageMap[languageCode]['name'];
    }
    return LanguageLocale.NO_LANGUAGE;
  }
}
