import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineville/presentation/widget/diagonal_view.dart';
import 'package:cineville/resources/asset_path.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieBackdropView extends StatelessWidget {
  final String backdropUrl;

  MovieBackdropView({Key key, @required this.backdropUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()..padding(bottom: 32.0, top: 24.0),
      child: DiagonalView(
        clipHeight: 30.0,
        child: CachedNetworkImage(
          errorWidget: (_, __, ___) => Image.asset(AssetPath.MISSING_MOVIE_BACKDROP_PLACEHOLDER),
          imageUrl: backdropUrl,
          placeholder: (_, __) => Image.asset(AssetPath.LOADING_MOVIE_BACKDROP_PLACEHOLDER),
        ),
      ),
    );
  }
}
