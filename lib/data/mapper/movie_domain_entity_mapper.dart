import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/data/language/language_locale.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/domain/entity/movie.dart';

class MovieDomainEntityMapper {
  List<Movie> map(List<DataEntity> movieDataEntities, List<DataEntity> genreDataEntities) {
    final List<Movie> movieDomainEntities = [];
    List<MovieDataEntity>.from(movieDataEntities).forEach((movieDataEntity) {
      movieDomainEntities.add(Movie(
          id: movieDataEntity.id,
          title: movieDataEntity.title,
          plotSynopsis: movieDataEntity.plotSynopsis,
          genres: _mapGenreIds(movieDataEntity.genreIds, genreDataEntities),
          rating: _mapRating(movieDataEntity.rating),
          posterUrl: _mapPosterUrl(movieDataEntity.posterUrl),
          backdropUrl: _mapBackdropUrl(movieDataEntity.backdropUrl),
          releaseYear: _mapReleaseDate(movieDataEntity.releaseDate),
          language: _mapLanguageCode(movieDataEntity.languageCode),
          popularity: movieDataEntity.popularity));
    });
    return movieDomainEntities;
  }

  List<String> _mapGenreIds(List<int> genreIds, List<DataEntity> genreDataEntities) {
    final List<String> genres = [];
    List<GenreDataEntity>.from(genreDataEntities).forEach((genreDataEntity) {
      if (genreIds.contains(genreDataEntity.id)) {
        genres.add(genreDataEntity.name);
      }
    });
    return genres;
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
