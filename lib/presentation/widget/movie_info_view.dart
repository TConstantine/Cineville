import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/videos_bloc.dart';
import 'package:cineville/presentation/widget/movie_backdrop_view.dart';
import 'package:cineville/presentation/widget/movie_genres_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/similar_movies_view.dart';
import 'package:cineville/presentation/widget/video_list_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieInfoView extends StatelessWidget {
  final Movie movie;

  MovieInfoView({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActions(),
          _buildVerticalSpacing(),
          _buildTitle(),
          _buildVerticalSpacing(),
          _buildGenres(),
          _buildVerticalSpacing(),
          _buildRating(),
          _buildVerticalSpacing(),
          _buildPlotSynopsis(),
          _buildVerticalSpacing(),
          _buildVideoListSection(),
          _buildVerticalSpacing(),
          _buildSimilarMoviesSection(),
          _buildVerticalSpacing(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Stack(
      children: [
        MovieBackdropView(
          backdropUrl: movie.backdropUrl,
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          child: MoviePosterView(
            posterUrl: movie.posterUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Parent(
      style: ParentStyle()..padding(horizontal: 16.0),
      child: Txt(
        '${movie.title} ${movie.releaseYear}',
        style: TxtStyle()..fontSize(20.0),
      ),
    );
  }

  Widget _buildGenres() {
    return Parent(
      style: ParentStyle()
        ..padding(horizontal: 16.0)
        ..height(26.0),
      child: MovieGenresView(
        genres: movie.genres,
      ),
    );
  }

  Widget _buildRating() {
    return Parent(
      style: ParentStyle()..padding(horizontal: 16.0),
      child: Row(
        children: [
          RatingBar(
            allowHalfRating: true,
            initialRating: double.parse(movie.rating) / 2,
            itemBuilder: (_, __) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemSize: 30.0,
            onRatingUpdate: (_) {},
            unratedColor: Colors.grey.shade400,
          ),
          SizedBox(
            width: 10.0,
          ),
          Txt(
            '${movie.rating}',
            style: TxtStyle()
              ..fontSize(25.0)
              ..opacity(0.6)
              ..textColor(Colors.amber.shade800),
          ),
          Txt(
            '/10',
            style: TxtStyle()..opacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildPlotSynopsis() {
    return Parent(
      style: ParentStyle()..padding(horizontal: 16.0),
      child: Txt(
        movie.plotSynopsis,
        style: TxtStyle()
          ..fontSize(15.0)
          ..opacity(0.6)
          ..textColor(Colors.black),
      ),
    );
  }

  Widget _buildVideoListSection() {
    return BlocProvider(
      builder: (_) => injector<VideosBloc>(),
      child: VideoListView(
        movieId: movie.id,
      ),
    );
  }

  Widget _buildSimilarMoviesSection() {
    return Parent(
      style: ParentStyle()..padding(horizontal: 16.0),
      child: BlocProvider(
        builder: (_) => injector<MoviesBloc>(),
        child: SimilarMoviesView(
          movieId: movie.id,
        ),
      ),
    );
  }

  Widget _buildVerticalSpacing() {
    return Parent(
      style: ParentStyle()..padding(vertical: 4.0),
    );
  }
}
