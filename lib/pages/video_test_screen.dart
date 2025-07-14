import 'package:flutter/material.dart';
import '../components/webview_video_player.dart';

class VideoTestScreen extends StatefulWidget {
  const VideoTestScreen({Key? key}) : super(key: key);

  @override
  State<VideoTestScreen> createState() => _VideoTestScreenState();
}

class _VideoTestScreenState extends State<VideoTestScreen> {
  final List<Map<String, String>> testUrls = [
    {
      'title': 'YouTube - Greetings',
      'url': 'https://www.youtube.com/watch?v=BZCuHpFhuaQ',
    },
    {
      'title': 'YouTube - Numbers',
      'url': 'https://www.youtube.com/watch?v=n1Y4HROvFME',
    },
    {
      'title': 'Direct MP4 - Sample',
      'url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    },
    {
      'title': 'Google Cloud - Big Buck Bunny',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Test'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: testUrls.length,
        itemBuilder: (context, index) {
          final item = testUrls[index];
          return Card(
            margin: EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Universal Video Player - Works on all platforms',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  _buildVideoPlayer(item),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer(Map<String, String> item) {
    return Column(
      children: [
        Text('WebView Video Player (Cross-Platform):'),
        SizedBox(height: 8),
        WebViewVideoPlayer(
          videoUrl: item['url']!,
          title: item['title']!,
        ),
      ],
    );
  }
}
