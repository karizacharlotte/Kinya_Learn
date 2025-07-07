import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SimpleVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const SimpleVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<SimpleVideoWidget> createState() => _SimpleVideoWidgetState();
}

class _SimpleVideoWidgetState extends State<SimpleVideoWidget> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _videoId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    if (_isInitialized) return;
    
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      print('Video URL: ${widget.videoUrl}');
      print('Extracted Video ID: $_videoId');
      
      if (_videoId != null && _videoId!.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
            hideControls: false,
            controlsVisibleAtStart: true,
            forceHD: false,
            loop: false,
            isLive: false,
          ),
        );

        _isInitialized = true;
        
        // Give the controller time to initialize
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Video initialization error: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _retry() {
    _isInitialized = false;
    _controller?.dispose();
    _controller = null;
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: _buildVideoContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError || _videoId == null) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                _videoId == null ? "Invalid video URL" : "Failed to load video",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _retry,
                child: const Text("Retry"),
              ),
              const SizedBox(height: 8),
              if (_videoId != null)
                TextButton(
                  onPressed: () {
                    // Open in external browser as fallback
                    // You can implement url_launcher here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Video ID: $_videoId'),
                        action: SnackBarAction(
                          label: 'Copy URL',
                          onPressed: () {
                            // Copy URL to clipboard
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text("Open in Browser"),
                ),
            ],
          ),
        ),
      );
    }

    if (_isLoading || _controller == null) {
      return Container(
        height: 200,
        color: Colors.grey[100],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading video..."),
              SizedBox(height: 8),
              Text(
                "This may take a moment",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).primaryColor,
        onReady: () {
          print('YouTube player ready!');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        onEnded: (data) {
          print('Video ended: ${data.videoId}');
        },
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
    );
  }
}
