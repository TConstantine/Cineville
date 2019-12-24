import 'package:cineville/data/model/movie_model.dart';

class TestMovieModelBuilder {
  int _id = 1;
  String _title = 'Title';
  String _plotSynopsis = 'Plot synopsis';
  List<int> _genreIds = [1, 2, 3];
  double _rating = 1.0;
  String _posterUrl = '/poster.jpg';
  String _backdropUrl = '/backdrop.jpg';
  String _releaseDate = '2000-01-01';
  String _languageCode = 'en';
  double _popularity = 1.0;
  List<int> _movieIds = [];
  List<double> _multiplePopularity = [];
  List<double> _ratings = [];
  List<String> _releaseDates = [];

  TestMovieModelBuilder withGenreIds(List<int> genreIds) {
    _genreIds = genreIds;
    return this;
  }

  TestMovieModelBuilder withLanguageCode(String languageCode) {
    _languageCode = languageCode;
    return this;
  }

  TestMovieModelBuilder withMovieIds(List<int> movieIds) {
    _movieIds = movieIds;
    return this;
  }

  TestMovieModelBuilder withPopularity(List<double> popularity) {
    _multiplePopularity = popularity;
    return this;
  }

  TestMovieModelBuilder withRatings(List<double> ratings) {
    _ratings = ratings;
    return this;
  }

  TestMovieModelBuilder withReleaseDates(List<String> releaseDates) {
    _releaseDates = releaseDates;
    return this;
  }

  MovieModel build() {
    return MovieModel(
      id: _id,
      title: _title,
      plotSynopsis: _plotSynopsis,
      genreIds: _genreIds,
      rating: _rating,
      posterUrl: _posterUrl,
      backdropUrl: _backdropUrl,
      releaseDate: _releaseDate,
      languageCode: _languageCode,
      popularity: _popularity,
    );
  }

  List<MovieModel> buildMultiple() {
    return List.generate(3, (index) {
      if (_movieIds.isNotEmpty) {
        _id = _movieIds[index];
      }
      if (_multiplePopularity.isNotEmpty) {
        _popularity = _multiplePopularity[index];
      }
      if (_ratings.isNotEmpty) {
        _rating = _ratings[index];
      }
      if (_releaseDates.isNotEmpty) {
        _releaseDate = _releaseDates[index];
      }
      return build();
    });
  }

  Map<String, dynamic> buildJson({
    int rating,
    int popularity,
    String posterUrl = '',
    String backdropUrl = '',
  }) {
    return {
      'popularity': popularity == null ? _popularity : popularity,
      'poster_path': posterUrl == null ? '' : _posterUrl,
      'id': _id,
      'backdrop_path': backdropUrl == null ? '' : _backdropUrl,
      'original_language': _languageCode,
      'genre_ids': _genreIds,
      'title': _title,
      'vote_average': rating == null ? _rating : rating,
      'overview': _plotSynopsis,
      'release_date': _releaseDate,
    };
  }

  List<Map<String, dynamic>> buildMultipleJson() {
    return [buildJson(), buildJson(), buildJson()];
  }
}
