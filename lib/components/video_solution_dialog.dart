import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoSolutionDialog extends StatelessWidget {
  const VideoSolutionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 12),
          Text('Video Playback Information'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How Video Playback Works in KinyaLearn:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            _buildFeatureItem(
              Icons.play_circle_outline,
              'YouTube Videos',
              'Open in your default browser or YouTube app for the best experience',
              Colors.red,
            ),
            SizedBox(height: 12),
            _buildFeatureItem(
              Icons.video_library,
              'Direct Videos',
              'Play directly in the app when available (MP4, WebM)',
              Colors.green,
            ),
            SizedBox(height: 12),
            _buildFeatureItem(
              Icons.phone_android,
              'Mobile & Desktop',
              'Optimized for all platforms - videos will use your device\'s best player',
              Colors.orange,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why External Video Players?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This ensures the best video quality, full-screen support, and reliable playback across all devices.',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Got it!'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _openKinyaLearnSupport();
          },
          child: Text('Contact Support'),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openKinyaLearnSupport() async {
    const url = 'mailto:support@kinyalearn.com?subject=Video Playback Support';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// Helper function to show the dialog
void showVideoSolutionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => VideoSolutionDialog(),
  );
}
