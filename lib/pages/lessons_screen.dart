import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../data/kinyarwanda_lessons.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLessons.getLessons();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const Navigation(),
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : (isTablet ? 32 : 20),
                vertical: isDesktop ? 40 : (isTablet ? 32 : 24),
              ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kinyarwanda Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Master Kinyarwanda step by step',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                    ),
                  ),
                ],
              ),
            ),
            // Lessons List
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
                child: isDesktop
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 20,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: lessons.length,
                        itemBuilder: (context, index) => _buildLessonCard(
                            context, lessons[index], index,
                            isTablet: true),
                      )
                    : ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLessonCard(context, lessons[index], index,
                              isTablet: isTablet),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsGrid(BuildContext context, List<Lesson> lessons,
      bool isTablet, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
      child: isDesktop
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 20,
                childAspectRatio: 3.5,
              ),
              itemCount: lessons.length,
              itemBuilder: (context, index) => _buildLessonCard(
                  context, lessons[index], index,
                  isTablet: true),
            )
          : ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildLessonCard(context, lessons[index], index,
                    isTablet: isTablet),
              ),
            ),
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson, int index,
      {bool isTablet = false}) {
    final colors = [
      const Color.fromARGB(255, 78, 42, 147),
      const Color(0xFF00A1DE),
      const Color(0xFF00A651),
      const Color(0xFFFAD201),
    ];
    final color = colors[index % colors.length];

    final isLocked = !lesson.isUnlocked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Stack(
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: isLocked
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        '/lesson-detail',
                        arguments: lesson,
                      );
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 24 : 20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border, width: 1),
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
                                  color: const Color(0xFFFAD201),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFFFAD201),
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
            ),
          ),
          if (isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Tooltip(
                  message: "Locked. Complete previous lessons to unlock.",
                  child: Container(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
