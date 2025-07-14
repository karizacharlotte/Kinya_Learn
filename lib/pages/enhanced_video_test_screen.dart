import 'package:flutter/material.dart';
import '../components/webview_video_player.dart';
import '../components/bottom_nav_bar.dart';

class EnhancedVideoTestScreen extends StatefulWidget {
  const EnhancedVideoTestScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedVideoTestScreen> createState() => _EnhancedVideoTestScreenState();
}

class _EnhancedVideoTestScreenState extends State<EnhancedVideoTestScreen> {
  final List<Map<String, dynamic>> kinyarwandaVideos = [
    {
      'title': 'Kinyarwanda Greetings',
      'subtitle': 'Learn basic greetings in Kinyarwanda',
      'url': 'https://www.youtube.com/watch?v=BZCuHpFhuaQ',
      'narration': 'Muraho ni ukwishimira mu Kinyarwanda. Birasangira cyane.',
      'description': 'This lesson covers the most common greetings used in Rwanda.',
    },
    {
      'title': 'Kinyarwanda Numbers',
      'subtitle': 'Count from 1 to 10 in Kinyarwanda',
      'url': 'https://www.youtube.com/watch?v=n1Y4HROvFME',
      'narration': 'Rimwe, kabiri, gatatu, kane, gatanu, gatandatu, karindwi, umunani, icyenda, icumi.',
      'description': 'Learn how to count numbers in Kinyarwanda from 1 to 10.',
    },
    {
      'title': 'Family Members',
      'subtitle': 'Learn about family in Kinyarwanda',
      'url': 'https://www.youtube.com/watch?v=example3',
      'narration': 'Umuryango, papa, mama, mwene wanjye, mushiki wanjye.',
      'description': 'Discover how to talk about family members in Kinyarwanda.',
    },
    {
      'title': 'Common Phrases',
      'subtitle': 'Essential daily phrases',
      'url': 'https://www.youtube.com/watch?v=example4',
      'narration': 'Murakoze cyane, urabeho, uragenda he, amakuru ki?',
      'description': 'Master the most useful phrases for daily conversations.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enhanced Video Player',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header section
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_filled,
                        color: Colors.orange,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interactive Video Learning',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              'Videos with African voice narration',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.record_voice_over,
                          color: Colors.blue.shade600,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tap the voice icon in each video to hear authentic Kinyarwanda pronunciation',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Video list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: kinyarwandaVideos.length,
                itemBuilder: (context, index) {
                  final video = kinyarwandaVideos[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video title and description
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.video_library,
                                      color: Colors.orange.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          video['title'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          video['subtitle'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                video['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Enhanced video player with African voice
                        WebViewVideoPlayer(
                          videoUrl: video['url'],
                          title: video['title'],
                          subtitle: video['subtitle'],
                          narrationText: video['narration'],
                          enableVoiceNarration: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Default to Home
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Enhanced Video Features'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFeatureItem(
                Icons.record_voice_over,
                'African Voice Narration',
                'Each video includes authentic Kinyarwanda pronunciation with African accent',
                Colors.orange,
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                Icons.play_circle_outline,
                'Interactive Video Player',
                'Tap the video to play in your preferred app while listening to narration',
                Colors.blue,
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                Icons.translate,
                'Pronunciation Guide',
                'Visual phonetic guides help you learn proper pronunciation',
                Colors.green,
              ),
              SizedBox(height: 16),
              _buildFeatureItem(
                Icons.volume_up,
                'Audio Controls',
                'Control playback speed and volume for optimal learning',
                Colors.purple,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!'),
          ),
        ],
      ),
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
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
                  color: Colors.grey.shade800,
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
}
