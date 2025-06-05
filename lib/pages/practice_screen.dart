import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          const Navigation(),
          // Practice Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppTheme.accentGradient,
            ),
            child: const Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice & Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Strengthen your Kinyarwanda skills',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Practice Options
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildPracticeCard(
                    'Speaking Practice',
                    'Pronunciation & Conversation',
                    Icons.mic,
                    AppTheme.primaryBlue,
                  ),
                  _buildPracticeCard(
                    'Listening Exercises',
                    'Comprehension Training',
                    Icons.headphones,
                    AppTheme.primaryGreen,
                  ),
                  _buildPracticeCard(
                    'Quick Review',
                    'Flash Cards & Vocabulary',
                    Icons.quiz,
                    AppTheme.accentPurple,
                  ),
                  _buildPracticeCard(
                    'Translation Practice',
                    'English ↔ Kinyarwanda',
                    Icons.translate,
                    AppTheme.warmOrange,
                  ),
                  _buildPracticeCard(
                    'Grammar Drills',
                    'Sentence Structure',
                    Icons.school,
                    AppTheme.softPink,
                  ),
                  _buildPracticeCard(
                    'Daily Scenarios',
                    'Real-life Conversations',
                    Icons.chat_bubble,
                    AppTheme.accentTeal,
                  ),
                ],
              ),
            ),
          ),
          // Daily Challenge
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentPurple, AppTheme.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Complete today\'s challenge for bonus XP!',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF6B6B),
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to specific practice mode
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
