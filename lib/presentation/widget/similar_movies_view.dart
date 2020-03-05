import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_similar_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarMoviesView extends StatefulWidget {
  final int movieId;

  SimilarMoviesView({Key key, @required this.movieId}) : super(key: key);

  @override
  _SimilarMoviesViewState createState() => _SimilarMoviesViewState();
}

class _SimilarMoviesViewState extends State<SimilarMoviesView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<MoviesBloc>(context).dispatch(LoadSimilarMoviesEvent(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<List<Movie>>) {
          return _buildLoadedState(state.loadedData);
        } else if (state is ErrorState) {
          return _buildErrorState();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedState(List<Movie> movies) {
    return Column(
      children: [
        Txt(
          '${TranslatableStrings.CATEGORY_SIMILAR} ${TranslatableStrings.MOVIES}',
          style: TxtStyle()
            ..fontSize(18.0)
            ..opacity(0.6),
        ),
        Container(
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              movies.length,
              (index) => Parent(
                style: ParentStyle()..padding(right: 8.0),
                child: MoviePosterView(
                  posterUrl: movies[index].posterUrl,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Parent(
      style: ParentStyle()..alignment.center(),
      child: Txt(
        '${TranslatableStrings.NO_SIMILAR_MOVIES}',
        style: TxtStyle()
          ..fontSize(20.0)
          ..italic()
          ..opacity(0.8),
      ),
    );
  }
}
