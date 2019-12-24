import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/presentation/widget/movie_actor_profile_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieActorView extends StatelessWidget {
  final Actor actor;

  MovieActorView({Key key, @required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()..width(MediaQuery.of(context).size.width / 3 - 8),
      child: Card(
        child: Column(
          children: [
            MovieActorProfileView(
              profileUrl: actor.profileUrl,
            ),
            Parent(
              style: ParentStyle()..padding(all: 8.0),
              child: Txt(
                actor.name,
                style: TxtStyle()..maxLines(2),
              ),
            ),
            Flexible(
              child: Parent(
                style: ParentStyle()
                  ..alignment.centerLeft()
                  ..opacity(0.5)
                  ..padding(horizontal: 8.0),
                child: Text(
                  actor.character,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
