import 'package:cineville/presentation/widget/movie_genre_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieGenresView extends StatelessWidget {
  final List<String> genres;

  MovieGenresView({Key key, @required this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        genres.length,
        (index) => Parent(
          style: ParentStyle()..padding(right: 4.0),
          child: MovieGenreView(
            genre: genres[index],
          ),
        ),
      ),
    );
  }
}
