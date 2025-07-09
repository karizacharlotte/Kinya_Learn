import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final bool isLocalAsset;
  final VoidCallback? onVideoCompleted;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.videoTitle,
    this.isLocalAsset = false,
    this.onVideoCompleted,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.isLocalAsset) {
        _videoController = VideoPlayerController.asset(widget.videoUrl);
      } else {
        // Handle various video sources
        if (widget.videoUrl.startsWith('http')) {
          _videoController = VideoPlayerController.network(widget.videoUrl);
        } else {
          // Fallback to asset
          _videoController = VideoPlayerController.asset(widget.videoUrl);
        }
      }

      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: true,
      );

      _videoController.addListener(() {
        if (_videoController.value.position == _videoController.value.duration) {
          widget.onVideoCompleted?.call();
        }
      });

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Video not available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interactive lesson content below',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
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
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _chewieController != null
              ? Chewie(controller: _chewieController!)
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
