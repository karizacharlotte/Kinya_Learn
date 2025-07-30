import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

// Platform-specific video player widget
class WebViewVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? title;

  const WebViewVideoPlayer({
    super.key,
    required this.videoUrl,
    this.title,
  });

  @override
  State<WebViewVideoPlayer> createState() => _WebViewVideoPlayerState();
}

class _WebViewVideoPlayerState extends State<WebViewVideoPlayer> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    setState(() {
      _isLoading = false;
      _hasError = false;
    });
  }

  String _getVideoId(String videoUrl) {
    if (videoUrl.contains('youtube.com/watch')) {
      final uri = Uri.parse(videoUrl);
      return uri.queryParameters['v'] ?? '';
    } else if (videoUrl.contains('youtu.be/')) {
      final uri = Uri.parse(videoUrl);
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    } else if (videoUrl.contains('youtube.com/embed/')) {
      final uri = Uri.parse(videoUrl);
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
    }
    return '';
  }

  String _getThumbnailUrl(String videoUrl) {
    final videoId = _getVideoId(videoUrl);
    if (videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return '';
  }

  Future<void> _openVideo() async {
    if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // For YouTube videos, open in new tab/window for web, or external app for mobile
        final videoId = _getVideoId(widget.videoUrl);
        String finalUrl = widget.videoUrl;
        
        // Convert to YouTube watch URL if it's an embed URL
        if (widget.videoUrl.contains('embed/') && videoId.isNotEmpty) {
          finalUrl = 'https://www.youtube.com/watch?v=$videoId';
        }
        
        final url = Uri.parse(finalUrl);
        if (await canLaunchUrl(url)) {
          if (kIsWeb) {
            // On web, open in new tab
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            // On mobile, open in YouTube app or browser
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
          
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _errorMessage = 'Could not launch video URL';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Error opening video: $e';
          _isLoading = false;
        });
      }
    } else {
      // For non-YouTube videos, fallback to external app
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          if (widget.title != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
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
                topLeft: widget.title != null ? Radius.zero : Radius.circular(12),
                topRight: widget.title != null ? Radius.zero : Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: widget.title != null ? Radius.zero : Radius.circular(12),
                topRight: widget.title != null ? Radius.zero : Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: _hasError ? _buildErrorWidget() : _buildVideoPlayer(),
            ),
          ),
          
          // Info section
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.video_library,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Click to open video ${kIsWeb ? 'in new tab' : 'in YouTube app'}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (!_hasError && !_isLoading)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    // Show thumbnail with play button that opens video externally
    final thumbnailUrl = _getThumbnailUrl(widget.videoUrl);
    
    return GestureDetector(
      onTap: _openVideo,
      child: Stack(
        children: [
          // Background thumbnail or gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: thumbnailUrl.isNotEmpty
                ? Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            Icons.video_library,
                            color: Colors.white54,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Icon(
                        Icons.video_library,
                        color: Colors.white54,
                        size: 48,
                      ),
                    ),
                  ),
          ),
          
          // Dark overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          
          // Play button and info
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
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
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    kIsWeb ? 'Open Video' : 'Play Video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    kIsWeb ? 'Opens in new tab' : 'Opens in YouTube app',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // YouTube branding
          if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be'))
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'YouTube',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
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
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Video Load Error',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage ?? 'Failed to load video content',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _initializePlayer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
