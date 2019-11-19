import 'package:cineville/data/model/movie_model.dart';

class TestMovieModelBuilder {
  int _id = 1;
  String _title = 'Title';
  String _plotSynopsis = 'Plot synopsis';
  List<int> _genreIds = [1, 2, 3];
  double _rating = 1.0;
  String _posterUrl = '/poster.jpg';
  String _backdropUrl = '/backdrop.jpg';
  String _releaseDate = '01/01/2000';
  String _languageCode = 'en';
  double _popularity = 1.0;

  TestMovieModelBuilder withGenreIds(List<int> genreIds) {
    _genreIds = genreIds;
    return this;
  }

  TestMovieModelBuilder withLanguageCode(String languageCode) {
    _languageCode = languageCode;
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
    return [build(), build(), build()];
  }

  Map<String, dynamic> buildJson({int rating, int popularity}) {
    return {
      'popularity': popularity == null ? _popularity : popularity,
      'poster_path': _posterUrl,
      'id': _id,
      'backdrop_path': _backdropUrl,
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
