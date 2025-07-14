import 'package:flutter/material.dart';
import '../components/embedded_video_player.dart';
import '../theme/app_theme.dart';

class VideoTestPage extends StatelessWidget {
  const VideoTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player Test'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YouTube Video Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            EmbeddedVideoPlayer(
              videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
              title: 'Sample YouTube Video',
              subtitle: 'Testing embedded video playback',
              autoPlay: false,
              showControls: true,
            ),
            const SizedBox(height: 32),
            const Text(
              'Direct Video URL Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            EmbeddedVideoPlayer(
              videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              title: 'Sample Direct Video',
              subtitle: 'Testing direct video file playback',
              autoPlay: false,
              showControls: true,
            ),
            const SizedBox(height: 32),
            const Text(
              'Video Player Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '• Embedded YouTube video playback\n'
              '• Direct video file support (MP4, WebM)\n'
              '• Automatic thumbnail generation\n'
              '• Play/pause controls\n'
              '• Full screen support\n'
              '• External app fallback\n'
              '• Error handling and retry options',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
