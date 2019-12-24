import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  final YoutubePlayerController videoPlayerController;

  VideoView({Key key, @required this.videoPlayerController}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: widget.videoPlayerController,
    );
  }
}
