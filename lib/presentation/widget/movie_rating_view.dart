import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieRatingView extends StatelessWidget {
  final String rating;

  MovieRatingView({Key key, @required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()
        ..alignmentContent.center()
        ..background.color(Colors.teal.shade300)
        ..circle()
        ..height(40.0)
        ..width(40.0),
      child: Txt(
        rating,
        style: TxtStyle()
          ..bold()
          ..fontSize(16.0)
          ..textColor(Colors.white),
      ),
    );
  }
}
