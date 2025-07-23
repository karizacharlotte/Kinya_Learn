import 'package:flutter/material.dart';
import '../components/in_app_video_player.dart';

class DynamicVideoUsageExample extends StatelessWidget {
  const DynamicVideoUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Video Players')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Basic usage (static-like)
            const InAppVideoPlayer(
              videoUrl: 'https://www.youtube.com/watch?v=BZCuHpFhuaQ',
              title: 'Basic Greetings',
              subtitle: 'Learn Kinyarwanda greetings',
            ),
            
            const SizedBox(height: 24),
            
            // Custom themed video player
            InAppVideoPlayer(
              videoUrl: 'https://www.youtube.com/watch?v=tV0metUxKFo',
              title: 'Cultural Context',
              subtitle: 'Understanding Rwandan culture',
              height: 250,
              primaryColor: const Color(0xFF00A651), // Rwanda green
              accentColor: const Color(0xFF1E88E5),
              borderRadius: BorderRadius.circular(20),
              customPlayText: 'Start Cultural Lesson',
              showYoutubeBranding: false,
            ),
            
            const SizedBox(height: 24),
            
            // Responsive video with aspect ratio
            InAppVideoPlayer(
              videoUrl: 'https://www.youtube.com/watch?v=bFEK5uUkwS8',
              title: 'Numbers & Age',
              aspectRatio: 16/9, // Dynamic height based on screen width
              primaryColor: Colors.purple,
              accentColor: Colors.indigo,
              borderRadius: BorderRadius.circular(16),
              customPlayText: 'Learn Numbers',
            ),
            
            const SizedBox(height: 24),
            
            // Compact video player
            InAppVideoPlayer(
              videoUrl: 'https://www.youtube.com/watch?v=xTkw_dSy6zU',
              title: 'Quick Review',
              height: 200,
              primaryColor: Colors.orange,
              accentColor: Colors.deepOrange,
              borderRadius: BorderRadius.circular(8),
              customPlayText: 'Quick Play',
              showYoutubeBranding: false,
            ),
          ],
        ),
      ),
    );
  }
}

// Example of how to use with Provider for theme-aware colors
class ThemedVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final String title;
  
  const ThemedVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InAppVideoPlayer(
      videoUrl: videoUrl,
      title: title,
      primaryColor: theme.primaryColor,
      accentColor: theme.colorScheme.secondary,
      height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
      borderRadius: BorderRadius.circular(
        theme.brightness == Brightness.dark ? 20 : 12
      ),
      customPlayText: theme.brightness == Brightness.dark 
          ? 'Play in Dark Mode' 
          : 'Play Lesson',
      showYoutubeBranding: true,
    );
  }
}
