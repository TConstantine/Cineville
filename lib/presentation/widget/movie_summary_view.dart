import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/screen/movie_details_screen.dart';
import 'package:cineville/presentation/widget/movie_genres_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/movie_rating_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/widget_key.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MovieSummaryView extends StatelessWidget {
  final Movie movie;

  MovieSummaryView({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()..height(162.0),
      child: Stack(
        children: [
          Card(
            child: Parent(
              style: ParentStyle()
                ..padding(
                  left: 120.0,
                  right: 8.0,
                  vertical: 8.0,
                )
                ..width(MediaQuery.of(context).size.width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  _buildGenres(),
                ],
              ),
            ),
          ),
          _buildPoster(),
          _buildRating(),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    return Positioned(
      bottom: 12.0,
      left: 12.0,
      child: Parent(
        style: ParentStyle()
          ..borderRadius(all: 4.0)
          ..boxShadow(
            blur: 5.0,
            color: Colors.grey.withOpacity(0.8),
            offset: Offset(5.0, 5.0),
          ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          child: MoviePosterView(
            posterUrl: movie.posterUrl,
          ),
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Positioned(
      bottom: 20.0,
      left: 82.0,
      child: MovieRatingView(
        rating: movie.rating,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '${movie.title} ${movie.releaseYear}',
      key: Key('movieTitle-${movie.id}'),
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGenres() {
    return Parent(
      style: ParentStyle()
        ..padding(top: 4.0)
        ..height(26.0),
      child: MovieGenresView(
        genres: movie.genres,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      right: 12.0,
      child: RaisedButton(
        key: Key('${WidgetKey.DETAILS_BUTTON}_${movie.id}'),
        color: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(movie: movie),
            ),
          );
        },
        child: Text(TranslatableStrings.DETAILS),
      ),
    );
  }
}
