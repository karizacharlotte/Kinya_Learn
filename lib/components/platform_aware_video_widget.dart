import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class PlatformAwareVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const PlatformAwareVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<PlatformAwareVideoWidget> createState() => _PlatformAwareVideoWidgetState();
}

class _PlatformAwareVideoWidgetState extends State<PlatformAwareVideoWidget> {
  bool _isLoading = false;
  String? _videoId;
  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _extractVideoInfo();
  }

  void _extractVideoInfo() {
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

  Future<void> _openVideo({bool forceNewTab = false}) async {
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse(widget.videoUrl);
      
      // Platform-specific behavior
      if (kIsWeb) {
        // Web: Always open in new tab
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _showSuccessMessage('🌐 Video opened in new tab');
      } else if (Platform.isAndroid || Platform.isIOS) {
        // Mobile: Try YouTube app first, then browser
        if (!forceNewTab) {
          String youtubeAppUrl = Platform.isAndroid
              ? 'vnd.youtube://$_videoId'
              : 'youtube://www.youtube.com/watch?v=$_videoId';
          
          if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
            await launchUrl(Uri.parse(youtubeAppUrl));
            _showSuccessMessage('📱 Video opened in YouTube app');
            return;
          }
        }
        
        // Fallback to browser
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _showSuccessMessage('🌐 Video opened in browser');
      } else {
        // Desktop: Open in default browser
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _showSuccessMessage('💻 Video opened in browser');
      }
    } catch (e) {
      _showErrorMessage('Could not open video: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _copyVideoUrl() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.videoUrl));
      _showSuccessMessage('📋 Video URL copied to clipboard!');
    } catch (e) {
      _showErrorMessage('Could not copy URL');
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
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
                    Icons.video_library,
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
          _buildVideoCard(),
        ],
      ),
    );
  }

  Widget _buildVideoCard() {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: _thumbnailUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_thumbnailUrl!),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {},
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Dark overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Play button
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                      ),
                      const SizedBox(height: 20),
                      // Action buttons
                      _buildActionButtons(),
                      const SizedBox(height: 12),
                      // Platform info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getPlatformMessage(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (kIsWeb) {
      // Web: Single watch button
      return _VideoActionButton(
        onPressed: _isLoading ? null : () => _openVideo(),
        icon: Icons.open_in_new,
        label: 'Watch in New Tab',
        isPrimary: true,
      );
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Mobile: YouTube app + browser options
      return Column(
        children: [
          _VideoActionButton(
            onPressed: _isLoading ? null : () => _openVideo(),
            icon: Icons.play_arrow,
            label: 'Open in YouTube App',
            isPrimary: true,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _VideoActionButton(
                onPressed: _isLoading ? null : () => _openVideo(forceNewTab: true),
                icon: Icons.open_in_browser,
                label: 'Browser',
                isPrimary: false,
              ),
              const SizedBox(width: 12),
              _VideoActionButton(
                onPressed: _copyVideoUrl,
                icon: Icons.copy,
                label: 'Copy',
                isPrimary: false,
              ),
            ],
          ),
        ],
      );
    } else {
      // Desktop: Browser + copy options
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _VideoActionButton(
            onPressed: _isLoading ? null : () => _openVideo(),
            icon: Icons.play_arrow,
            label: 'Watch Video',
            isPrimary: true,
          ),
          const SizedBox(width: 12),
          _VideoActionButton(
            onPressed: _copyVideoUrl,
            icon: Icons.copy,
            label: 'Copy Link',
            isPrimary: false,
          ),
        ],
      );
    }
  }

  String _getPlatformMessage() {
    if (kIsWeb) {
      return '🌐 Opens in new browser tab';
    } else if (Platform.isAndroid) {
      return '📱 Best experience in YouTube app';
    } else if (Platform.isIOS) {
      return '📱 Best experience in YouTube app';
    } else {
      return '💻 Opens in your default browser';
    }
  }
}

class _VideoActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _VideoActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary 
            ? Colors.red 
            : Colors.white.withValues(alpha: 0.9),
        foregroundColor: isPrimary 
            ? Colors.white 
            : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 3,
      ),
    );
  }
}
