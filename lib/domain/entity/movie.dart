import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String plotSynopsis;
  final List<String> genres;
  final String rating;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final String language;
  final double popularity;

  Movie({
    @required this.id,
    @required this.title,
    @required this.plotSynopsis,
    @required this.genres,
    @required this.rating,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.releaseDate,
    @required this.language,
    @required this.popularity,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      plotSynopsis,
      genres,
      rating,
      posterUrl,
      backdropUrl,
      releaseDate,
      language,
      popularity,
    ];
  }
}
