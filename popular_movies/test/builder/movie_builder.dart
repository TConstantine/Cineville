import 'package:popular_movies/domain/entity/movie.dart';

class MovieBuilder {
  int _id = 1;
  String _title = 'Title';
  String _plotSynopsis = 'Plot synopsis';
  List<String> _genres = ['Genre 1', 'Genre 2', 'Genre 3'];
  double _rating = 1.0;
  String _posterUrl = 'https://example.com/poster.jpg';
  String _backdropUrl = 'https://example.com/backdrop.jpg';
  String _releaseDate = '01/01/2000';
  String _language = 'English';
  double _popularity = 1.0;

  Movie build() {
    return Movie(
      id: _id,
      title: _title,
      plotSynopsis: _plotSynopsis,
      genres: _genres,
      rating: _rating,
      posterUrl: _posterUrl,
      backdropUrl: _backdropUrl,
      releaseDate: _releaseDate,
      language: _language,
      popularity: _popularity,
    );
  }
}
