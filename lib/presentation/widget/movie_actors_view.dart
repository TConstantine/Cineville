import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_actors_event.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_actor_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieActorsView extends StatefulWidget {
  final int movieId;

  MovieActorsView({Key key, @required this.movieId}) : super(key: key);

  @override
  _MovieActorsViewState createState() => _MovieActorsViewState();
}

class _MovieActorsViewState extends State<MovieActorsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ActorsBloc>(context).dispatch(LoadMovieActorsEvent(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActorsBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<List<Actor>>) {
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

  Widget _buildLoadedState(List<Actor> actors) {
    return Parent(
      style: ParentStyle()..padding(all: 4.0),
      child: GridView.count(
        childAspectRatio: 0.47,
        crossAxisCount: 3,
        children: List.generate(
          actors.length,
          (index) => MovieActorView(
            actor: actors[index],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final Widget image = _mapMessageToImage(message);
    if (message == TranslatableStrings.NO_DATA_FAILURE_MESSAGE) {
      message = '${TranslatableStrings.NO_ACTORS}';
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
          Icons.account_circle,
          size: 100.0,
        );
      default:
        return Icon(
          Icons.error,
          size: 100.0,
        );
    }
  }
}
