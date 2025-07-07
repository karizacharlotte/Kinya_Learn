import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class UniversalVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const UniversalVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<UniversalVideoWidget> createState() => _UniversalVideoWidgetState();
}

class _UniversalVideoWidgetState extends State<UniversalVideoWidget> {
  bool _isLoading = false;
  String? _videoId;
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _extractVideoInfo();
  }

  void _extractVideoInfo() {
    // Extract video ID from YouTube URL
    final regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(widget.videoUrl);
    if (match != null) {
      _videoId = match.group(1);
      _thumbnailUrl = 'https://img.youtube.com/vi/$_videoId/maxresdefault.jpg';
    }
  }

  Future<void> _playVideo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Method 1: Try to launch with YouTube app first (mobile)
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final youtubeAppUrl = Platform.isAndroid
            ? 'vnd.youtube://$_videoId'
            : 'youtube://$_videoId';
        
        if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
          await launchUrl(Uri.parse(youtubeAppUrl));
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Method 2: Open in external browser (fallback)
      if (await canLaunchUrl(Uri.parse(widget.videoUrl))) {
        await launchUrl(
          Uri.parse(widget.videoUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError('Could not open video');
      }
    } catch (e) {
      _showError('Error opening video: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _copyVideoUrl() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.videoUrl));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Video URL copied to clipboard!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Could not copy URL');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              child: _buildVideoPlayer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: _thumbnailUrl != null
              ? DecorationImage(
                  image: NetworkImage(_thumbnailUrl!),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // Handle thumbnail load error silently
                  },
                )
              : null,
        ),
        child: Stack(
          children: [
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Video controls
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Large play button
                  GestureDetector(
                    onTap: _isLoading ? null : _playVideo,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        icon: Icons.play_arrow,
                        label: 'Watch Video',
                        onPressed: _isLoading ? null : _playVideo,
                      ),
                      const SizedBox(width: 16),
                      _ActionButton(
                        icon: Icons.copy,
                        label: 'Copy URL',
                        onPressed: _copyVideoUrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Platform-specific hint
                  Text(
                    _getPlatformHint(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlatformHint() {
    if (kIsWeb) {
      return 'Tap to open video in new tab';
    } else if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return 'Tap to open in YouTube app or browser';
    } else {
      return 'Tap to open video in your browser';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
