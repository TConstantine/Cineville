import 'package:cineville/presentation/widget/shadow_view.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:flutter/material.dart';

class MoviePosterView extends StatelessWidget {
  final String posterUrl;

  MoviePosterView({Key key, @required this.posterUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FadeInImage.assetNetwork(
          image: posterUrl,
          imageScale: 1.5,
          placeholder: UntranslatableStrings.MOVIE_POSTER_PLACEHOLDER_PATH,
          placeholderScale: 1.5,
        ),
      ),
    );
  }
}
