import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/reviews_bloc.dart';
import 'package:cineville/presentation/widget/movie_actors_view.dart';
import 'package:cineville/presentation/widget/movie_details_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/movie_info_view.dart';
import 'package:cineville/presentation/widget/movie_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailsScreen({Key key, @required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  int currentIndex;
  Widget currentView;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    currentView = MovieInfoView(
      movie: widget.movie,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: MovieDetailsNavigationBarView(
        currentIndex: currentIndex,
        onTap: _handleTap,
      ),
      body: currentView,
    );
  }

  void _handleTap(int index) {
    if (index != currentIndex) {
      currentIndex = index;
      switch (index) {
        case 0:
          currentView = MovieInfoView(
            movie: widget.movie,
          );
          break;
        case 1:
          currentView = BlocProvider(
            builder: (_) => injector<ActorsBloc>(),
            child: MovieActorsView(
              movieId: widget.movie.id,
            ),
          );
          break;
        case 2:
          currentView = BlocProvider(
            builder: (_) => injector<ReviewsBloc>(),
            child: MovieReviewsView(
              movieId: widget.movie.id,
            ),
          );
          break;
      }
      setState(() {});
    }
  }
}
