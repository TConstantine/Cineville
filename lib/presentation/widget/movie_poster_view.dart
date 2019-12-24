import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineville/resources/asset_path.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MoviePosterView extends StatelessWidget {
  final String posterUrl;

  MoviePosterView({Key key, @required this.posterUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()..width(92.0),
      child: CachedNetworkImage(
        errorWidget: (_, __, ___) => Image.asset(AssetPath.MISSING_MOVIE_POSTER_PLACEHOLDER),
        imageUrl: posterUrl,
        placeholder: (_, __) => Image.asset(AssetPath.LOADING_MOVIE_POSTER_PLACEHOLDER),
      ),
    );
  }
}
