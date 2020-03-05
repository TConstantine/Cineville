import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/add_movie_to_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/event/is_favorite_movie_event.dart';
import 'package:cineville/presentation/bloc/event/remove_movie_from_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/favorite_movie_bloc.dart';
import 'package:cineville/presentation/bloc/state/added_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/removed_state.dart';
import 'package:cineville/resources/widget_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMovieButtonView extends StatefulWidget {
  final int movieId;

  FavoriteMovieButtonView({this.movieId});

  @override
  _FavoriteMovieButtonViewState createState() => _FavoriteMovieButtonViewState();
}

class _FavoriteMovieButtonViewState extends State<FavoriteMovieButtonView> {
  FavoriteMovieBloc _favoriteMovieBloc;
  bool isFavorite;

  @override
  void initState() {
    super.initState();
    _favoriteMovieBloc = BlocProvider.of<FavoriteMovieBloc>(context);
    _favoriteMovieBloc.dispatch(IsFavoriteMovieEvent(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteMovieBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadedState<bool>) {
          return _buildLoadedState(state.loadedData);
        } else if (state is AddedState) {
          return _buildAddedState(state.message);
        } else if (state is RemovedState) {
          return _buildRemovedState(state.message);
        } else if (state is ErrorState) {
          return _buildErrorState(state.message);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadedState(bool isFavorite) {
    this.isFavorite = isFavorite;
    return _buildFloatingActionButton();
  }

  Widget _buildAddedState(String message) {
    isFavorite = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    });
    return _buildFloatingActionButton();
  }

  Widget _buildRemovedState(String message) {
    isFavorite = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    });
    return _buildFloatingActionButton();
  }

  Widget _buildErrorState(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    });
    return _buildFloatingActionButton();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      key: Key('${WidgetKey.FAVORITE_BUTTON}'),
      onPressed: () {
        isFavorite
            ? _favoriteMovieBloc.dispatch(RemoveMovieFromFavoriteListEvent(widget.movieId))
            : _favoriteMovieBloc.dispatch(AddMovieToFavoriteListEvent(widget.movieId));
      },
      child: Icon(
        Icons.favorite,
        color: isFavorite ? Colors.red : Colors.black.withOpacity(0.5),
      ),
    );
  }
}
