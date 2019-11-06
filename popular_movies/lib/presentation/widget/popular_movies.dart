import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/event/load_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_bloc.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_state.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/error.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loaded.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loading.dart';
import 'package:popular_movies/presentation/widget/popular_movie_preview.dart';
import 'package:popular_movies/resources/translatable_strings.dart';

class PopularMovies extends StatefulWidget {
  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<PopularMoviesBloc>(context).dispatch(LoadPopularMovies(1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularMoviesBloc, PopularMoviesState>(builder: (context, state) {
      if (state is Loading) {
        return _buildLoading();
      } else if (state is Loaded) {
        return _buildLoaded(state.movies);
      } else if (state is Error) {
        return _buildError(state.message);
      } else {
        return Container();
      }
    });
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(List<Movie> movies) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Text(
                TranslatableStrings.MOST_POPULAR_MOVIES_CATEGORY,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  movies.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                    child: PopularMoviePreview(movie: movies[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Text(message);
  }
}
