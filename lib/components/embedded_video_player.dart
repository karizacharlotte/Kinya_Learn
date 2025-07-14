import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class EmbeddedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? subtitle;
  final bool autoPlay;
  final bool showControls;

  const EmbeddedVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.title,
    this.subtitle,
    this.autoPlay = false,
    this.showControls = true,
  }) : super(key: key);

  @override
  State<EmbeddedVideoPlayer> createState() => _EmbeddedVideoPlayerState();
}

class _EmbeddedVideoPlayerState extends State<EmbeddedVideoPlayer> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isEmbedded = false;
  VideoPlayerController? _videoController;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    if (_isYouTubeUrl(widget.videoUrl)) {
      _initializeYouTubePlayer();
    } else if (_isDirectVideoUrl(widget.videoUrl)) {
      _initializeDirectVideoPlayer();
    } else {
      _initializeWebViewPlayer();
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  bool _isDirectVideoUrl(String url) {
    return url.endsWith('.mp4') || 
           url.endsWith('.webm') || 
           url.endsWith('.mov') ||
           url.endsWith('.avi') ||
           url.contains('.mp4') ||
           url.contains('.webm');
  }

  String _getYouTubeVideoId(String url) {
    if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'] ?? '';
    } else if (url.contains('youtu.be/')) {
      final uri = Uri.parse(url);
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    } else if (url.contains('youtube.com/embed/')) {
      final uri = Uri.parse(url);
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
    }
    return '';
  }

  String _getYouTubeEmbedUrl(String videoId) {
    return 'https://www.youtube.com/embed/$videoId?autoplay=${widget.autoPlay ? 1 : 0}&controls=${widget.showControls ? 1 : 0}&modestbranding=1&rel=0';
  }

  String _getYouTubeThumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  void _initializeYouTubePlayer() {
    try {
      final videoId = _getYouTubeVideoId(widget.videoUrl);
      if (videoId.isNotEmpty) {
        if (kIsWeb) {
          _initializeWebViewPlayer();
        } else {
          _initializeWebViewPlayer();
        }
      } else {
        throw Exception('Invalid YouTube URL');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load YouTube video: $e';
        _isLoading = false;
      });
    }
  }

  void _initializeDirectVideoPlayer() {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _videoController!.initialize().then((_) {
        setState(() {
          _isLoading = false;
          _isEmbedded = true;
        });
        if (widget.autoPlay) {
          _videoController!.play();
        }
      }).catchError((error) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load video: $error';
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize video player: $e';
        _isLoading = false;
      });
    }
  }

  void _initializeWebViewPlayer() {
    try {
      if (_isYouTubeUrl(widget.videoUrl)) {
        final videoId = _getYouTubeVideoId(widget.videoUrl);
        final embedUrl = _getYouTubeEmbedUrl(videoId);
        
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (progress == 100) {
                  setState(() {
                    _isLoading = false;
                    _isEmbedded = true;
                  });
                }
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                  _isEmbedded = true;
                });
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _hasError = true;
                  _errorMessage = 'Failed to load video: ${error.description}';
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(embedUrl));
      } else {
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.videoUrl));
      }
      
      setState(() {
        _isEmbedded = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize web player: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openExternally() async {
    try {
      final url = Uri.parse(widget.videoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Could not launch video URL';
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error opening video: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          if (widget.title != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryOrange, AppTheme.primaryOrange.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                ],
              ),
            ),
          
          // Video content
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: widget.title != null ? Radius.zero : const Radius.circular(16),
                topRight: widget.title != null ? Radius.zero : const Radius.circular(16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: widget.title != null ? Radius.zero : const Radius.circular(16),
                topRight: widget.title != null ? Radius.zero : const Radius.circular(16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
              child: _buildVideoContent(),
            ),
          ),
          
          // Controls and info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isEmbedded ? Icons.play_circle : Icons.video_library,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isEmbedded 
                      ? 'Playing in app' 
                      : 'Ready to play',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!_hasError) ...[
                  TextButton.icon(
                    onPressed: _openExternally,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Open External'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryOrange,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return _buildErrorWidget();
    }
    
    if (_isLoading) {
      return _buildLoadingWidget();
    }
    
    if (_videoController != null && _videoController!.value.isInitialized) {
      return _buildDirectVideoPlayer();
    }
    
    if (_webViewController != null && _isEmbedded) {
      return _buildWebViewPlayer();
    }
    
    return _buildThumbnailPlayer();
  }

  Widget _buildDirectVideoPlayer() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
        if (widget.showControls)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    icon: Icon(
                      _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppTheme.primaryOrange,
                        bufferedColor: Colors.white30,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWebViewPlayer() {
    return WebViewWidget(controller: _webViewController!);
  }

  Widget _buildThumbnailPlayer() {
    String? thumbnailUrl;
    if (_isYouTubeUrl(widget.videoUrl)) {
      final videoId = _getYouTubeVideoId(widget.videoUrl);
      thumbnailUrl = _getYouTubeThumbnailUrl(videoId);
    }
    
    return GestureDetector(
      onTap: _initializePlayer,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: thumbnailUrl != null
                ? Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildVideoIcon(),
                  )
                : _buildVideoIcon(),
          ),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoIcon() {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: Icon(
          Icons.video_library,
          color: Colors.white54,
          size: 64,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black87,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryOrange,
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Video Load Error',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage ?? 'Failed to load video content',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _initializePlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _openExternally,
                  child: const Text('Open External'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
