import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io' show Platform;

class PlatformVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const PlatformVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<PlatformVideoWidget> createState() => _PlatformVideoWidgetState();
}

class _PlatformVideoWidgetState extends State<PlatformVideoWidget> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _videoId;
  bool _isPlatformSupported = true;

  @override
  void initState() {
    super.initState();
    _checkPlatformSupport();
  }

  void _checkPlatformSupport() {
    // Check if current platform supports YouTube player
    if (kIsWeb || (!kIsWeb && (Platform.isLinux || Platform.isWindows))) {
      setState(() {
        _isPlatformSupported = false;
        _isLoading = false;
      });
      return;
    }
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      
      if (_videoId != null && _videoId!.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
            hideControls: false,
            controlsVisibleAtStart: true,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1000));
        
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
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _openInBrowser() async {
    // Copy URL to clipboard and show instructions
    await Clipboard.setData(ClipboardData(text: widget.videoUrl));
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Video URL copied to clipboard! Open your browser and paste it.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
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
    // Platform not supported - show thumbnail with external link
    if (!_isPlatformSupported) {
      return _buildThumbnailView();
    }

    // Error state
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
                onPressed: _initializeVideo,
                child: const Text("Retry"),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _openInBrowser,
                child: const Text("Open in Browser"),
              ),
            ],
          ),
        ),
      );
    }

    // Loading state
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
            ],
          ),
        ),
      );
    }

    // YouTube player (mobile/supported platforms)
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).primaryColor,
        onReady: () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildThumbnailView() {
    return GestureDetector(
      onTap: _openInBrowser,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          image: _videoId != null 
            ? DecorationImage(
                image: NetworkImage(
                  'https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
                ),
                fit: BoxFit.cover,
              )
            : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dark overlay
            Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            // Play button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kIsWeb ? 'Click to watch on YouTube' : 'Video not supported on this platform',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to open in browser',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
