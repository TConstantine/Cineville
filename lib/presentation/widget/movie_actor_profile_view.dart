import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineville/resources/asset_path.dart';
import 'package:flutter/material.dart';

class MovieActorProfileView extends StatelessWidget {
  final String profileUrl;

  MovieActorProfileView({Key key, @required this.profileUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4.0),
        topRight: Radius.circular(4.0),
      ),
      child: CachedNetworkImage(
        errorWidget: (_, __, ___) => Image.asset(AssetPath.MISSING_ACTOR_PROFILE_PLACEHOLDER),
        imageUrl: profileUrl,
        placeholder: (_, __) => Image.asset(AssetPath.LOADING_ACTOR_PROFILE_PLACEHOLDER),
      ),
    );
  }
}
