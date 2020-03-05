import 'package:cineville/presentation/widget/movie_genre_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieGenresView extends StatelessWidget {
  final List<String> genres;
  final ParentStyle parentStyle;

  MovieGenresView({Key key, @required this.genres, this.parentStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: parentStyle ?? ParentStyle(),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          genres.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: 6.0),
            child: MovieGenreView(
              genre: genres[index],
              parentStyle: ParentStyle()
                ..padding(horizontal: 6.0)
                ..border(all: 1.0, color: Colors.black.withOpacity(0.5))
                ..borderRadius(all: 16.0),
              txtStyle: TxtStyle()
                ..alignment.center()
                ..opacity(0.6)
                ..textColor(Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
