import 'package:cineville/domain/entity/movie.dart';

class TestMovieBuilder {
  final int _id = 1;
  final String _title = 'Title';
  final String _plotSynopsis = 'Plot synopsis';
  final List<String> _genres = ['Genre 1', 'Genre 2', 'Genre 3'];
  final String _rating = '1.0';
  final String _posterUrl = 'https://example.com/poster.jpg';
  final String _backdropUrl = 'https://example.com/backdrop.jpg';
  final String _releaseDate = '01/01/2000';
  final String _language = 'English';
  final double _popularity = 1.0;

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

  List<Movie> buildMultiple() {
    return [build(), build(), build()];
  }
}
