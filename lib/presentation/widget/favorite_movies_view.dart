import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_favorite_movies_event.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMoviesView extends StatefulWidget {
  @override
  _FavoriteMoviesViewState createState() => _FavoriteMoviesViewState();
}

class _FavoriteMoviesViewState extends State<FavoriteMoviesView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<FavoriteListBloc>(context).dispatch(LoadFavoriteMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteListBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<List<Movie>>) {
          return _buildLoadedState(state.loadedData);
        } else if (state is ErrorState) {
          return _buildErrorState(state.message);
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
    return ListView(
      children: List.generate(
        movies.length,
        (index) => Padding(
          padding: EdgeInsets.all(8.0),
          child: MovieSummaryView(
            movie: movies[index],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Parent(
      style: ParentStyle()
        ..padding(horizontal: 32.0)
        ..opacity(0.5),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Parent(
            style: ParentStyle()
              ..opacity(0.5)
              ..padding(all: 8.0),
            child: Icon(
              Icons.favorite,
              size: 100.0,
            ),
          ),
          Text(
            message,
            key: Key('errorMessage'),
            style: TextStyle(fontSize: 18.0),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
