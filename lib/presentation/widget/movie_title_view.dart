import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieTitleView extends StatelessWidget {
  final String title;
  final ParentStyle parentStyle;
  final TxtStyle txtStyle;

  MovieTitleView({
    Key key,
    @required this.title,
    this.parentStyle,
    this.txtStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: parentStyle ?? ParentStyle(),
      child: Txt(
        title,
        style: txtStyle ?? TxtStyle(),
      ),
    );
  }
}
