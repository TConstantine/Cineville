import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesView extends StatefulWidget {
  final BlocEvent event;

  MoviesView({Key key, @required this.event}) : super(key: key);

  @override
  _MoviesViewState createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  Widget build(BuildContext context) {
    _loadMovies();
    return BlocBuilder<MoviesBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<Movie>) {
          return _buildLoadedState(state.entities);
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
    final Widget image = _mapMessageToImage(message);
    if (message == TranslatableStrings.NO_DATA_FAILURE_MESSAGE) {
      message = '${TranslatableStrings.NO_MOVIES}';
    }
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
            child: image,
          ),
          Txt(
            message,
            style: TxtStyle()..fontSize(18.0),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _mapMessageToImage(String message) {
    switch (message) {
      case TranslatableStrings.SERVER_FAILURE_MESSAGE:
        return Icon(
          Icons.cloud_off,
          size: 100.0,
        );
      case TranslatableStrings.NETWORK_FAILURE_MESSAGE:
        return Icon(
          Icons.signal_wifi_off,
          size: 100.0,
        );
      case TranslatableStrings.NO_DATA_FAILURE_MESSAGE:
        return Icon(
          Icons.local_movies,
          size: 100.0,
        );
      default:
        return Icon(
          Icons.error,
          size: 100.0,
        );
    }
  }

  void _loadMovies() {
    BlocProvider.of<MoviesBloc>(context).dispatch(widget.event);
  }
}
