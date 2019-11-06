import 'package:flutter/material.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/resources/images.dart';

class PopularMoviePreview extends StatelessWidget {
  final Movie movie;

  PopularMoviePreview({Key key, @required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      image: movie.posterUrl,
      imageScale: 1.5,
      placeholder: Images.transparent,
    );
  }
}
