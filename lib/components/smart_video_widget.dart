import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SmartVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const SmartVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<SmartVideoWidget> createState() => _SmartVideoWidgetState();
}

class _SmartVideoWidgetState extends State<SmartVideoWidget> {
  YoutubePlayerController? _youtubeController;
  WebViewController? _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _videoId;
  bool _useWebView = false;
  bool _useYouTubePlayer = false;

  @override
  void initState() {
    super.initState();
    _determineVideoStrategy();
  }

  void _determineVideoStrategy() {
    _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (_videoId == null) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    // Determine which video strategy to use based on platform
    if (kIsWeb || (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS))) {
      // Use WebView for desktop platforms and web
      _useWebView = true;
      _initializeWebView();
    } else {
      // Use YouTube player for mobile platforms
      _useYouTubePlayer = true;
      _initializeYouTubePlayer();
    }
  }

  void _initializeWebView() async {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (progress == 100) {
                setState(() {
                  _isLoading = false;
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
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            },
          ),
        );

      // Load YouTube embed URL
      final embedUrl = 'https://www.youtube.com/embed/$_videoId?autoplay=0&rel=0&modestbranding=1';
      await _webViewController!.loadRequest(Uri.parse(embedUrl));
      
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _initializeYouTubePlayer() async {
    try {
      _youtubeController = YoutubePlayerController(
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
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _openInExternalBrowser() async {
    final Uri url = Uri.parse(widget.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open video in browser'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    if (_useWebView) {
      _initializeWebView();
    } else if (_useYouTubePlayer) {
      _initializeYouTubePlayer();
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
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
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: _openInExternalBrowser,
                    tooltip: 'Open in browser',
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _openInExternalBrowser,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text("Open in Browser"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return Container(
        height: 200,
        color: Colors.grey[100],
        child: Stack(
          children: [
            // Show thumbnail while loading
            if (_videoId != null)
              Image.network(
                'https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    height: 200,
                  );
                },
              ),
            // Loading overlay
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading video...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Return appropriate player based on strategy
    if (_useWebView && _webViewController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _webViewController!),
      );
    } else if (_useYouTubePlayer && _youtubeController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
          onReady: () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
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

    // Fallback
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Text("Video player not available"),
      ),
    );
  }
}
