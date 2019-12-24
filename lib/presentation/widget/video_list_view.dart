import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_videos_event.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/bloc/videos_bloc.dart';
import 'package:cineville/presentation/widget/video_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListView extends StatefulWidget {
  final int movieId;

  VideoListView({Key key, @required this.movieId}) : super(key: key);

  @override
  _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  List<YoutubePlayerController> videoPlayerControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<VideosBloc>(context).dispatch(LoadMovieVideosEvent(widget.movieId));
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerControllers.forEach((videoPlayerController) => videoPlayerController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosBloc, BlocState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _buildLoadingState();
        } else if (state is LoadedState<Video>) {
          return _buildLoadedState(state.entities);
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

  Widget _buildLoadedState(List<Video> videoList) {
    return Parent(
      style: ParentStyle()
        ..height(220.0)
        ..padding(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          videoList.length,
          (index) {
            final YoutubePlayerController videoPlayerController = YoutubePlayerController(
              flags: YoutubePlayerFlags(
                autoPlay: false,
                disableDragSeek: true,
                mute: true,
              ),
              initialVideoId: YoutubePlayer.convertUrlToId(videoList[index].url),
            );
            videoPlayerControllers.add(videoPlayerController);
            return Parent(
              style: ParentStyle()
                ..padding(right: 8.0)
                ..width(MediaQuery.of(context).size.width - 32.0),
              child: VideoView(
                videoPlayerController: videoPlayerController,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Parent(
      style: ParentStyle()..alignment.center(),
      child: Txt(
        '${TranslatableStrings.NO_VIDEOS}',
        style: TxtStyle()
          ..fontSize(20.0)
          ..italic()
          ..opacity(0.8),
      ),
    );
  }
}
