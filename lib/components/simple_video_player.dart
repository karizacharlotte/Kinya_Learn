import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? subtitle;

  const SimpleVideoPlayer({
    super.key,
    required this.videoUrl,
    this.title,
    this.subtitle,
  });

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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

  Future<void> _playVideo() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String urlToOpen = widget.videoUrl;
      
      // Convert embed URLs to watch URLs for better compatibility
      if (widget.videoUrl.contains('embed/')) {
        final videoId = _getVideoId(widget.videoUrl);
        if (videoId.isNotEmpty) {
          urlToOpen = 'https://www.youtube.com/watch?v=$videoId';
        }
      }
      
      final uri = Uri.parse(urlToOpen);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: kIsWeb ? LaunchMode.externalApplication : LaunchMode.externalApplication,
        );
        
        setState(() {
          _isLoading = false;
        });
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(kIsWeb ? 'Video opened in new tab' : 'Video opened in external app'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Cannot open video. Please check your internet connection.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error opening video: ${e.toString()}';
        _isLoading = false;
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
              child: _hasError ? _buildErrorWidget() : _buildVideoThumbnail(),
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
                  Icons.video_library,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    kIsWeb ? 'Click to open in new tab' : 'Click to open in YouTube app',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _playVideo,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow, size: 18),
                  label: Text(_isLoading ? 'Opening...' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    final thumbnailUrl = _getThumbnailUrl(widget.videoUrl);
    
    return GestureDetector(
      onTap: _isLoading ? null : _playVideo,
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
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: thumbnailUrl.isNotEmpty
                ? Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryOrange),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => _buildVideoIcon(),
                  )
                : _buildVideoIcon(),
          ),
          
          // Play button overlay
          if (!_isLoading)
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
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryOrange),
                    SizedBox(height: 16),
                    Text(
                      'Opening video...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _playVideo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
