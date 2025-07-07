import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLessonWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;
  final bool autoPlay;

  const VideoLessonWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<VideoLessonWidget> createState() => _VideoLessonWidgetState();
}

class _VideoLessonWidgetState extends State<VideoLessonWidget> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _isPlayerReady = false;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      
      if (_videoId != null && _videoId!.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false, // Always start with autoPlay false to avoid loading issues
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
            hideControls: false,
            controlsVisibleAtStart: true,
            useHybridComposition: true, // Better performance on Android
          ),
        );
        
        _controller!.addListener(_listener);
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _listener() {
    if (_controller != null && mounted) {
      if (_controller!.value.isReady && !_isPlayerReady) {
        setState(() {
          _isPlayerReady = true;
          _isLoading = false;
          _hasError = false;
        });
      } else if (_controller!.value.hasError) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.removeListener(_listener);
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                _hasError ? "Failed to load video" : "Invalid video URL",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isLoading = true;
                  });
                  _initializePlayer();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.videoTitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_fill,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.videoTitle!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: YoutubePlayerBuilder(
                onExitFullScreen: () {
                  // Handle exit fullscreen if needed
                },
                player: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Theme.of(context).primaryColor,
                  topActions: <Widget>[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _controller?.metadata.title ?? widget.videoTitle ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                  onReady: () {
                    setState(() {
                      _isPlayerReady = true;
                      _isLoading = false;
                    });
                  },
                  onEnded: (data) {
                    // Handle video end if needed
                  },
                ),
                builder: (context, player) {
                  return Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: player,
                      ),
                      if (_isLoading) ...[
                        Positioned.fill(
                          child: Container(
                            color: Colors.black54,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
