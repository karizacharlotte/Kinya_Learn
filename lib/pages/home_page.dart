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
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          const Navigation(),
          // Progress Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: orientation == Orientation.landscape && !isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('XP', '1,250', Icons.star, isTablet, AppTheme.warmOrange),
                      _buildStatCard('Streak', '5', Icons.local_fire_department, isTablet, AppTheme.primaryGreen),
                      _buildStatCard('Level', '3', Icons.emoji_events, isTablet, AppTheme.accentTeal),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        'Your Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('XP', '1,250', Icons.star, isTablet, AppTheme.warmOrange),
                          _buildStatCard('Streak', '5', Icons.local_fire_department, isTablet, AppTheme.primaryGreen),
                          _buildStatCard('Level', '3', Icons.emoji_events, isTablet, AppTheme.accentTeal),
                        ],
                      ),
                    ],
                  ),
          ),
          // Lessons List
          Expanded(
            child: isDesktop
                ? _buildDesktopLessonGrid(lessons)
                : _buildMobileLessonList(lessons, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isTablet, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: isTablet ? 28 : 24),
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 20 : 18,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLessonGrid(List<Lesson> lessons) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 3,
        ),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return _buildLessonCard(context, lesson, index, isDesktop: true);
        },
      ),
    );
  }

  Widget _buildMobileLessonList(List<Lesson> lessons, bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return _buildLessonCard(context, lesson, index, isTablet: isTablet);
      },
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson, int index, {bool isTablet = false, bool isDesktop = false}) {
    final cardHeight = isDesktop ? null : (isTablet ? 100.0 : 80.0);
    
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 0 : 16),
      height: cardHeight,
      child: Card(
        elevation: isDesktop ? 6 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
        child: InkWell(
          onTap: lesson.isUnlocked
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonPage(lesson: lesson),
                    ),
                  )
              : null,
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                // Lesson Icon
                Container(
                  width: isTablet ? 70 : 60,
                  height: isTablet ? 70 : 60,
                  decoration: BoxDecoration(
                    gradient: lesson.isUnlocked
                        ? _getLessonGradient(index)
                        : null,
                    color: lesson.isUnlocked ? null : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    lesson.isCompleted
                        ? Icons.check
                        : lesson.isUnlocked
                            ? Icons.play_arrow
                            : Icons.lock,
                    color: Colors.white,
                    size: isTablet ? 35 : 30,
                  ),
                ),
                SizedBox(width: isTablet ? 20 : 16),
                // Lesson Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        lesson.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                        maxLines: isDesktop ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Progress indicator
                if (lesson.isCompleted)
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: isTablet ? 24 : 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getLessonGradient(int index) {
    switch (index % 4) {
      case 0:
        return AppTheme.primaryGradient;
      case 1:
        return AppTheme.secondaryGradient;
      case 2:
        return const LinearGradient(
          colors: [AppTheme.accentPurple, AppTheme.softPink],
        );
      default:
        return const LinearGradient(
          colors: [AppTheme.accentTeal, AppTheme.brightCyan],
        );
    }
  }
}
