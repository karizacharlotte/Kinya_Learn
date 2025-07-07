import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class EnhancedVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;

  const EnhancedVideoWidget({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
  }) : super(key: key);

  @override
  State<EnhancedVideoWidget> createState() => _EnhancedVideoWidgetState();
}

class _EnhancedVideoWidgetState extends State<EnhancedVideoWidget> {
  YoutubePlayerController? _youtubeController;
  WebViewController? _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _videoId;
  bool _isInitialized = false;
  
  // Platform detection
  bool get _isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool get _isDesktop => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  bool get _isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (_videoId == null) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    try {
      if (_isMobile) {
        await _initializeYouTubePlayer();
      } else if (_isDesktop || _isWeb) {
        await _initializeWebView();
      } else {
        // Fallback for unknown platforms
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

  Future<void> _initializeYouTubePlayer() async {
    try {
      _youtubeController = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          hideControls: false,
          controlsVisibleAtStart: true,
          forceHD: false,
          useHybridComposition: true,
        ),
      );

      // Wait for controller to be ready
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('YouTube player initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeWebView() async {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Don't update loading state on progress, wait for page finished
            },
            onPageStarted: (String url) {
              // Keep loading state
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _isInitialized = true;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              print('WebView error: ${error.description}');
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              // Allow YouTube navigation
              return NavigationDecision.navigate;
            },
          ),
        );

      // Create embed URL with autoplay disabled and other parameters
      final embedUrl = 'https://www.youtube.com/embed/$_videoId?'
          'autoplay=0&'
          'rel=0&'
          'modestbranding=1&'
          'playsinline=1&'
          'enablejsapi=1&'
          'origin=${Uri.base.origin}';
      
      await _webViewController!.loadRequest(Uri.parse(embedUrl));
      
    } catch (e) {
      print('WebView initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _openInExternalBrowser() async {
    try {
      final Uri url = Uri.parse(widget.videoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorMessage('Could not open video in browser');
      }
    } catch (e) {
      _showErrorMessage('Error opening video: $e');
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isInitialized = false;
    });
    _initializeVideo();
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
                textAlign: TextAlign.center,
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
                      "Loading video player...",
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

    // Return appropriate player based on platform
    if (_isMobile && _youtubeController != null && _isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
          onReady: () {
            print('YouTube player ready');
          },
          onEnded: (metaData) {
            print('Video ended');
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
    } else if ((_isDesktop || _isWeb) && _webViewController != null && _isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _webViewController!),
      );
    }

    // Fallback loading state
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Initializing video player..."),
          ],
        ),
      ),
    );
  }
}
