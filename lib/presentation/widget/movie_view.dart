import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:flutter/material.dart';

class MovieView extends StatelessWidget {
  final Movie movie;

  MovieView({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoviePosterView(
      posterUrl: movie.posterUrl,
    );
  }
}
