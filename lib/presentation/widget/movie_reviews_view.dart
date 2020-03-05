import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_reviews_event.dart';
import 'package:cineville/presentation/bloc/reviews_bloc.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/widget/movie_review_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieReviewsView extends StatefulWidget {
  final int movieId;

  MovieReviewsView({Key key, @required this.movieId}) : super(key: key);

  @override
  _MovieReviewsViewState createState() => _MovieReviewsViewState();
}

class _MovieReviewsViewState extends State<MovieReviewsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ReviewsBloc>(context).dispatch(LoadMovieReviewsEvent(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<List<Review>>) {
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

  Widget _buildLoadedState(List<Review> reviews) {
    return ListView(
      children: List.generate(
        reviews.length,
        (index) {
          return Parent(
            style: ParentStyle()..padding(all: 4.0),
            child: MovieReviewView(
              review: reviews[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final Widget image = _mapMessageToImage(message);
    if (message == TranslatableStrings.NO_DATA_FAILURE_MESSAGE) {
      message = '${TranslatableStrings.NO_REVIEWS}';
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
          Icons.rate_review,
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
