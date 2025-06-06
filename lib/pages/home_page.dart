import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../data/kinyarwanda_lessons.dart';
import '../models/lesson.dart';
import 'lesson_page.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLessons.getLessons();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const Navigation(),
          // Welcome Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : (isTablet ? 32 : 20),
              vertical: isDesktop ? 40 : (isTablet ? 32 : 24),
            ),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Sarah! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  'Continue your Kinyarwanda learning journey',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: isDesktop ? 32 : (isTablet ? 24 : 20)),
                _buildStatsRow(isTablet, isDesktop),
              ],
            ),
          ),
          // Lessons Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Lessons',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isTablet ? 24 : 20,
                            ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/lessons'),
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildLessonsGrid(lessons, isTablet, isDesktop),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isTablet, bool isDesktop) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total XP',
            '2,450',
            Icons.star_rounded,
            AppTheme.primaryOrange,
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            'Day Streak',
            '12',
            Icons.local_fire_department_rounded,
            AppTheme.primaryRed,
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            'Level',
            '5',
            Icons.emoji_events_rounded,
            AppTheme.primaryGreen,
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: isTablet ? 24 : 20,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsGrid(
      List<Lesson> lessons, bool isTablet, bool isDesktop) {
    if (isDesktop) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 20,
          childAspectRatio: 3.5,
        ),
        itemCount: lessons.length,
        itemBuilder: (context, index) =>
            _buildModernLessonCard(lessons[index], index, isTablet: true),
      );
    } else {
      return ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child:
              _buildModernLessonCard(lessons[index], index, isTablet: isTablet),
        ),
      );
    }
  }

  Widget _buildModernLessonCard(Lesson lesson, int index,
      {bool isTablet = false}) {
    final colors = [
      AppTheme.primaryPurple,   // Deep purple
      AppTheme.primaryGreen,    // Maroon
      Color(0xFF8B5CF6),        // Light purple
      AppTheme.primaryOrange,   // Orange
    ];
    final color = colors[index % colors.length];

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: isTablet ? 64 : 56,
              height: isTablet ? 64 : 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                lesson.isCompleted
                    ? Icons.check_circle_rounded
                    : lesson.isUnlocked
                        ? Icons.play_circle_rounded
                        : Icons.lock_rounded,
                color: color,
                size: isTablet ? 32 : 28,
              ),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.description,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (lesson.isCompleted) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppTheme.primaryOrange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (lesson.isUnlocked)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.textMuted,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
