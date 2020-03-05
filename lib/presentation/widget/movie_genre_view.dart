import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieGenreView extends StatelessWidget {
  final String genre;
  final ParentStyle parentStyle;
  final TxtStyle txtStyle;

  MovieGenreView({
    Key key,
    @required this.genre,
    this.parentStyle,
    this.txtStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: parentStyle ?? ParentStyle(),
      child: Txt(
        genre,
        style: txtStyle ?? TxtStyle(),
      ),
    );
  }
}
