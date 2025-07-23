import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? subtitle;
  final double? height;
  final Color? primaryColor;
  final Color? accentColor;
  final BorderRadius? borderRadius;
  final bool showYoutubeBranding;
  final String? customPlayText;
  final double? aspectRatio;

  const InAppVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.title,
    this.subtitle,
    this.height,
    this.primaryColor,
    this.accentColor,
    this.borderRadius,
    this.showYoutubeBranding = true,
    this.customPlayText,
    this.aspectRatio,
  }) : super(key: key);

  @override
  State<InAppVideoPlayer> createState() => _InAppVideoPlayerState();
}

class _InAppVideoPlayerState extends State<InAppVideoPlayer> {
  bool _hasError = false;
  String? _errorMessage;
  bool _isVideoLoaded = false;

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

  String _getEmbedUrl(String videoUrl) {
    final videoId = _getVideoId(videoUrl);
    if (videoId.isNotEmpty) {
      return 'https://www.youtube.com/embed/$videoId?autoplay=0&controls=1&modestbranding=1&rel=0&fs=1&playsinline=1&enablejsapi=1&origin=${Uri.base.origin}';
    }
    return videoUrl;
  }

  String _getThumbnailUrl(String videoUrl) {
    final videoId = _getVideoId(videoUrl);
    if (videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return '';
  }

  String _getVideoHtml(String embedUrl) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                margin: 0;
                padding: 0;
                background-color: #000;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                font-family: Arial, sans-serif;
            }
            .video-container {
                position: relative;
                width: 100%;
                height: 100%;
                max-width: 100%;
                max-height: 100%;
            }
            iframe {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: none;
                background: #000;
            }
            .loading {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: white;
                font-size: 16px;
                z-index: 10;
            }
        </style>
    </head>
    <body>
        <div class="video-container">
            <div class="loading" id="loading">Loading video...</div>
            <iframe 
                src="$embedUrl"
                allowfullscreen
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                loading="lazy"
                onload="document.getElementById('loading').style.display='none';"
                onerror="document.getElementById('loading').innerHTML='Error loading video';"
            ></iframe>
        </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    final accentColor = widget.accentColor ?? Colors.deepOrange;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final videoHeight = widget.height ?? (widget.aspectRatio != null 
        ? MediaQuery.of(context).size.width / widget.aspectRatio! 
        : 300.0);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          if (widget.title != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius.topLeft.x),
                  topRight: Radius.circular(borderRadius.topRight.x),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_fill, color: Colors.white),
                  const SizedBox(width: 8),
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
                  if (_isVideoLoaded)
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                ],
              ),
            ),
          
          // Video player
          Container(
            height: videoHeight,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: widget.title != null ? Radius.zero : Radius.circular(borderRadius.topLeft.x),
                topRight: widget.title != null ? Radius.zero : Radius.circular(borderRadius.topRight.x),
                bottomLeft: Radius.circular(borderRadius.bottomLeft.x),
                bottomRight: Radius.circular(borderRadius.bottomRight.x),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: widget.title != null ? Radius.zero : Radius.circular(borderRadius.topLeft.x),
                topRight: widget.title != null ? Radius.zero : Radius.circular(borderRadius.topRight.x),
                bottomLeft: Radius.circular(borderRadius.bottomLeft.x),
                bottomRight: Radius.circular(borderRadius.bottomRight.x),
              ),
              child: _hasError ? _buildErrorWidget() : _buildVideoPlayer(),
            ),
          ),
          
          // Progress bar
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: _isVideoLoaded ? primaryColor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          
          // Info section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius.bottomLeft.x),
                bottomRight: Radius.circular(borderRadius.bottomRight.x),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.video_library,
                  color: theme.brightness == Brightness.dark 
                      ? Colors.grey.shade400 
                      : Colors.grey.shade600,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isVideoLoaded 
                      ? 'Video loaded and ready!'
                      : 'Ready to play in app',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (_isVideoLoaded)
                  Icon(
                    Icons.check_circle,
                    color: primaryColor,
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
    if (!_isVideoLoaded) {
      return _buildThumbnailView();
    }

    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _getVideoHtml(_getEmbedUrl(widget.videoUrl)),
            mimeType: 'text/html',
            encoding: 'utf-8',
          ),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            transparentBackground: true,
            supportZoom: false,
            javaScriptEnabled: true,
            domStorageEnabled: true,
            allowFileAccess: true,
            allowContentAccess: true,
            allowsBackForwardNavigationGestures: false,
            disableContextMenu: true,
            clearCache: false,
            cacheEnabled: true,
            // Performance optimizations
            useOnLoadResource: false,
            useShouldOverrideUrlLoading: false,
            // Faster loading
            allowsLinkPreview: false,
            isFraudulentWebsiteWarningEnabled: false,
            allowsAirPlayForMediaPlayback: true,
          ),
          onWebViewCreated: (controller) {
            // Web view controller ready
          },
          onReceivedError: (controller, request, error) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Failed to load video: ${error.description}';
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print('Console: ${consoleMessage.message}');
          },
        ),
      ],
    );
  }

  Widget _buildThumbnailView() {
    final thumbnailUrl = _getThumbnailUrl(widget.videoUrl);
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    final playText = widget.customPlayText ?? 'Tap to Play Video';
    
    return GestureDetector(
      onTap: () {
        // Just load the video immediately without loading overlay
        setState(() {
          _isVideoLoaded = true;
        });
      },
      child: Stack(
        children: [
          // Background thumbnail
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a1a1a),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: thumbnailUrl.isNotEmpty
                ? Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
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
          
          // Play button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor,
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
                    playText,
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
                  child: const Text(
                    'Plays instantly in app',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // YouTube branding
          if (widget.showYoutubeBranding && 
              (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')))
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                  _isVideoLoaded = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
