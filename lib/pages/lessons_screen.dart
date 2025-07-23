import 'package:flutter/material.dart';
import 'dart:math';
import '../data/language_lessons.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
              vertical: isDesktop ? 40 : (isTablet ? 32 : 24),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF23262F), const Color(0xFF23262F)]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kinyarwanda Lessons',
                          style: TextStyle(
                            fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose a lesson to start learning Kinyarwanda',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.school, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progress: ${lessons.where((l) => l.isCompleted).length}/${lessons.length} lessons completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: lessons.where((l) => l.isCompleted).length / lessons.length,
                                backgroundColor: Colors.white.withValues(alpha: 0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                minHeight: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Lessons Grid
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                  crossAxisSpacing: isDesktop ? 16 : (isTablet ? 14 : 12),
                  mainAxisSpacing: isDesktop ? 16 : (isTablet ? 14 : 12),
                  childAspectRatio: isDesktop ? 0.85 : (isTablet ? 0.8 : 0.9),
                ),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _buildLessonCard(context, lesson, isTablet, isDark);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLessonCard(BuildContext context, lesson, bool isTablet, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/lesson-detail',
          arguments: lesson,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).colorScheme.surface : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: lesson.isCompleted 
                ? AppTheme.primaryOrange.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail section with lesson preview
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getLessonColor(lesson.id).withValues(alpha: 0.1),
                    _getLessonColor(lesson.id).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _LessonPatternPainter(_getLessonColor(lesson.id)),
                    ),
                  ),
                  
                  // Main lesson illustration
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _getLessonColor(lesson.id).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getLessonIcon(lesson.id),
                            size: 20,
                            color: _getLessonColor(lesson.id),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getLessonColor(lesson.id).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getLessonPreviewText(lesson.id),
                            style: TextStyle(
                              fontSize: 9,
                              color: _getLessonColor(lesson.id),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Play button overlay
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  
                  if (lesson.isCompleted)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lesson.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'DONE',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        lesson.description,
                        style: TextStyle(
                          fontSize: isTablet ? 11 : 10,
                          color: isDark ? Colors.white70 : AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Lesson ${lesson.order}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (lesson.isCompleted)
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.green,
                              )
                            else if (lesson.isUnlocked)
                              Icon(
                                Icons.play_circle_fill,
                                size: 14,
                                color: AppTheme.primaryOrange,
                              )
                            else
                              Icon(
                                Icons.lock,
                                size: 14,
                                color: Colors.grey,
                              ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: isDark ? Colors.white54 : AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for lesson customization
  Color _getLessonColor(String lessonId) {
    switch (lessonId) {
      case 'greetings':
        return AppTheme.primaryOrange;
      case 'alphabet':
        return const Color(0xFF4CAF50); // Green
      case 'introduction':
        return const Color(0xFF2196F3); // Blue
      case 'general_numbers':
        return const Color(0xFF9C27B0); // Purple
      case 'specific_numbers':
        return const Color(0xFF795548); // Brown
      case 'days_weeks_months':
        return const Color(0xFF607D8B); // Blue Grey
      case 'national_anthem':
        return const Color(0xFFFF5722); // Deep Orange
      case 'slang':
        return const Color(0xFF8BC34A); // Light Green
      case 'tell_time':
        return const Color(0xFF03A9F4); // Light Blue
      case 'body_parts':
        return const Color(0xFFE91E63); // Pink
      case 'family_members':
        return const Color(0xFF3F51B5); // Indigo
      case 'rwanda_facts':
        return const Color(0xFF009688); // Teal
      case 'colors':
        return const Color(0xFFFF9800); // Orange
      case 'express_yourself':
        return const Color(0xFF673AB7); // Deep Purple
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getLessonIcon(String lessonId) {
    switch (lessonId) {
      case 'greetings':
        return Icons.waving_hand;
      case 'alphabet':
        return Icons.abc;
      case 'introduction':
        return Icons.person_add;
      case 'general_numbers':
        return Icons.looks_one;
      case 'specific_numbers':
        return Icons.calculate;
      case 'days_weeks_months':
        return Icons.calendar_today;
      case 'national_anthem':
        return Icons.music_note;
      case 'slang':
        return Icons.chat_bubble;
      case 'tell_time':
        return Icons.access_time;
      case 'body_parts':
        return Icons.accessibility;
      case 'family_members':
        return Icons.family_restroom;
      case 'rwanda_facts':
        return Icons.map;
      case 'colors':
        return Icons.palette;
      case 'express_yourself':
        return Icons.sentiment_satisfied;
      default:
        return Icons.school;
    }
  }

  String _getLessonPreviewText(String lessonId) {
    switch (lessonId) {
      case 'greetings':
        return 'Muraho!';
      case 'alphabet':
        return 'A, B, C...';
      case 'introduction':
        return 'Nitwa...';
      case 'general_numbers':
        return '1, 2, 3...';
      case 'specific_numbers':
        return '10, 20, 100...';
      case 'days_weeks_months':
        return 'Ku wa mbere';
      case 'national_anthem':
        return 'Rwanda nziza';
      case 'slang':
        return 'Sawa!';
      case 'tell_time':
        return 'Ni saa...';
      case 'body_parts':
        return 'Umutwe';
      case 'family_members':
        return 'Umuryango';
      case 'rwanda_facts':
        return 'Kigali';
      case 'colors':
        return 'Amabara';
      case 'express_yourself':
        return 'Nishimiye';
      default:
        return 'Learn';
    }
  }
}

// Custom painter for lesson card background patterns
class _LessonPatternPainter extends CustomPainter {
  final Color color;

  _LessonPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw a subtle pattern of circles
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        i * 15.0,
        paint..color = color.withValues(alpha: 0.05 * i),
      );
    }
    
    // Draw small decorative dots
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = centerX + 40 * cos(angle);
      final y = centerY + 40 * sin(angle);
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
