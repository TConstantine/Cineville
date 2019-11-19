import 'package:flutter/material.dart';

class MovieRatingView extends StatelessWidget {
  final String rating;

  MovieRatingView({Key key, @required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
      height: 40.0,
      width: 40.0,
      child: Center(
        child: Text(
          rating,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
