import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late String? _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (_videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_videoId != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return const Scaffold(
        body: Center(child: Text("Invalid YouTube URL")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Video")),
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) {
            return Column(
              mainAxisSize: MainAxisSize.min, // Avoid infinite height
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9, // Maintain video aspect ratio
                  child: player,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
