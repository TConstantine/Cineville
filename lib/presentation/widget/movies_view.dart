import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/movies_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_view.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesView extends StatefulWidget {
  final String title;

  MoviesView({Key key, @required this.title}) : super(key: key);

  @override
  _MoviesViewState createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  final double _containerHeight = 235.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState) {
          return _buildLoadedState(state.movies);
        } else if (state is ErrorState) {
          return _buildErrorState(state.message);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.only(
        left: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMovieCategoryTitle(),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildLoadedState(List<Movie> movies) {
    return Container(
      height: _containerHeight,
      padding: const EdgeInsets.only(
        left: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMovieCategoryTitle(),
          _buildMovieList(movies),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMovieCategoryTitle(),
          Row(
            children: [
              Expanded(
                child: _buildErrorMessageDisplay(message),
              ),
              _buildRefreshButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: _containerHeight - 45.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildMovieCategoryTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          movies.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
            child: MovieView(movie: movies[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessageDisplay(String message) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        key: Key(UntranslatableStrings.REFRESH_BUTTON_KEY),
        elevation: 0.0,
        onPressed: () {
          _loadMovies();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _loadMovies() {
    BlocProvider.of<MoviesBloc>(context).dispatch(LoadMoviesEvent(1));
  }
}
