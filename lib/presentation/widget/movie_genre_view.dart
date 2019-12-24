import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieGenreView extends StatelessWidget {
  final String genre;

  MovieGenreView({Key key, @required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()
        ..padding(horizontal: 6.0)
        ..border(all: 1.0, color: Colors.black.withOpacity(0.5))
        ..borderRadius(all: 16.0),
      child: Txt(
        genre,
        style: TxtStyle()..alignment.center()
          ..opacity(0.6)
          ..textColor(Colors.black),
      ),
    );
  }
}
