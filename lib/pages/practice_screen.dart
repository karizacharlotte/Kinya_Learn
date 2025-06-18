import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const Navigation(),
          // Practice Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 78, 42, 147),
                  Color.fromARGB(255, 78, 42, 147),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fitness_center,
                    color: Colors.white, size: isTablet ? 36 : 32),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Practice & Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Strengthen your Kinyarwanda skills',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Practice Options
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: GridView.count(
                crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 2),
                crossAxisSpacing: isTablet ? 20 : 16,
                mainAxisSpacing: isTablet ? 20 : 16,
                childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.1 : 1.0),
                children: [
                  _buildPracticeCard(
                    'Speaking Practice',
                    'Pronunciation & Conversation',
                    Icons.mic,
                    const Color.fromARGB(255, 78, 42, 147),
                    isTablet,
                  ),
                  _buildPracticeCard(
                    'Listening Exercises',
                    'Comprehension Training',
                    Icons.headphones,
                    const Color(0xFF00A1DE),
                    isTablet,
                  ),
                  _buildPracticeCard(
                    'Quick Review',
                    'Flash Cards & Vocabulary',
                    Icons.quiz,
                    const Color(0xFF00A651),
                    isTablet,
                  ),
                  _buildPracticeCard(
                    'Translation Practice',
                    'English ↔ Kinyarwanda',
                    Icons.translate,
                    const Color(0xFFFAD201),
                    isTablet,
                  ),
                  _buildPracticeCard(
                    'Grammar Drills',
                    'Sentence Structure',
                    Icons.school,
                    const Color.fromARGB(255, 78, 42, 147),
                    isTablet,
                  ),
                  _buildPracticeCard(
                    'Daily Scenarios',
                    'Real-life Conversations',
                    Icons.chat_bubble,
                    const Color(0xFF00A1DE),
                    isTablet,
                  ),
                ],
              ),
            ),
          ),
          // Daily Challenge
          Container(
            margin: EdgeInsets.all(isTablet ? 20 : 16),
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 78, 42, 147),
                  Color.fromARGB(255, 78, 42, 147),
                ],
              ),
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department,
                    color: Colors.white, size: isTablet ? 36 : 32),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Complete today\'s challenge for bonus XP!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryPurple,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 12 : 8,
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(String title, String subtitle, IconData icon,
      Color color, bool isTablet) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to specific practice mode
          },
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isTablet ? 60 : 50,
                  height: isTablet ? 60 : 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: isTablet ? 28 : 24),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: isTablet ? 14 : 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
