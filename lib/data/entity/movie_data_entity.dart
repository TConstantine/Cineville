import 'package:cineville/data/entity/data_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MovieDataEntity extends Equatable implements DataEntity {
  final int id;
  final String title;
  final String plotSynopsis;
  final List<int> genreIds;
  final double rating;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final String languageCode;
  final double popularity;

  MovieDataEntity({
    @required this.id,
    @required this.title,
    @required this.plotSynopsis,
    @required this.genreIds,
    @required this.rating,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.releaseDate,
    @required this.languageCode,
    @required this.popularity,
  });

  factory MovieDataEntity.fromJson(Map<String, dynamic> json) {
    return MovieDataEntity(
      id: json['id'],
      title: json['title'],
      plotSynopsis: json['overview'],
      genreIds: json['genre_ids'].cast<int>(),
      rating: json['vote_average'].toDouble(),
      posterUrl: json['poster_path'] ?? '',
      backdropUrl: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'],
      languageCode: json['original_language'],
      popularity: json['popularity'].toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': plotSynopsis,
      'genre_ids': genreIds,
      'vote_average': rating,
      'poster_path': posterUrl,
      'backdrop_path': backdropUrl,
      'release_date': releaseDate,
      'original_language': languageCode,
      'popularity': popularity
    };
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      plotSynopsis,
      genreIds,
      rating,
      posterUrl,
      backdropUrl,
      releaseDate,
      languageCode,
      popularity,
    ];
  }
}
