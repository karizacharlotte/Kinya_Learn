import 'package:flutter/material.dart';
import 'dart:math';
import '../data/language_lessons.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../utils/responsive_layout.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: ResponsiveHelper.getResponsivePadding(context),
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
                        icon: Icon(Icons.arrow_back, 
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveIconSize(context),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 12, large: 16)),
                      Expanded(
                        child: ResponsiveText(
                          'Kinyarwanda Lessons',
                          type: ResponsiveTextType.header,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                  ResponsiveText(
                    'Choose a lesson to start learning Kinyarwanda',
                    type: ResponsiveTextType.body,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                  // Progress indicator
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16)),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? 12 : 8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.school, 
                          color: Colors.white, 
                          size: ResponsiveHelper.getResponsiveIconSize(context) * 0.8
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                'Progress: ${lessons.where((l) => l.isCompleted).length}/${lessons.length} lessons completed',
                                type: ResponsiveTextType.body,
                                customFontSize: ResponsiveHelper.getResponsiveBodyFontSize(context) * 0.85,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 6, large: 8)),
                              LinearProgressIndicator(
                                value: lessons.where((l) => l.isCompleted).length / lessons.length,
                                backgroundColor: Colors.white.withValues(alpha: 0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                minHeight: ResponsiveHelper.getResponsiveValue(context, mobile: 3, tablet: 4, desktop: 5),
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
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: ResponsiveGrid(
                mobileColumns: 2,
                tabletColumns: 3,
                desktopColumns: 4,
                spacing: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16),
                runSpacing: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16),
                childAspectRatio: ResponsiveHelper.getResponsiveValue(context, mobile: 0.9, tablet: 0.8, desktop: 0.85),
                children: lessons.map((lesson) => _buildLessonCard(context, lesson, isDark)).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLessonCard(BuildContext context, lesson, bool isDark) {
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
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
          border: Border.all(
            color: lesson.isCompleted 
                ? AppTheme.primaryOrange.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 10, desktop: 12),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail section with lesson preview
            Container(
              height: ResponsiveHelper.getResponsiveValue(context, mobile: 80, tablet: 90, desktop: 100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getLessonColor(lesson.id).withValues(alpha: 0.1),
                    _getLessonColor(lesson.id).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
                  topRight: Radius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
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
                          width: ResponsiveHelper.getResponsiveValue(context, mobile: 36, tablet: 40, desktop: 44),
                          height: ResponsiveHelper.getResponsiveValue(context, mobile: 36, tablet: 40, desktop: 44),
                          decoration: BoxDecoration(
                            color: _getLessonColor(lesson.id).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getLessonIcon(lesson.id),
                            size: ResponsiveHelper.getResponsiveValue(context, mobile: 20, tablet: 22, desktop: 24),
                            color: _getLessonColor(lesson.id),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 8, desktop: 10),
                            vertical: ResponsiveHelper.getResponsiveValue(context, mobile: 2, tablet: 3, desktop: 4)
                          ),
                          decoration: BoxDecoration(
                            color: _getLessonColor(lesson.id).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 9, desktop: 10)),
                          ),
                          child: ResponsiveText(
                            _getLessonPreviewText(lesson.id),
                            type: ResponsiveTextType.body,
                            customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 9, tablet: 10, desktop: 11),
                            color: _getLessonColor(lesson.id),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Play button overlay
                  Positioned(
                    bottom: ResponsiveHelper.getResponsiveValue(context, mobile: 4, tablet: 6, desktop: 8),
                    right: ResponsiveHelper.getResponsiveValue(context, mobile: 4, tablet: 6, desktop: 8),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(context, mobile: 4, tablet: 5, desktop: 6)),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
                      ),
                    ),
                  ),
                  
                  if (lesson.isCompleted)
                    Positioned(
                      top: ResponsiveHelper.getResponsiveValue(context, mobile: 4, tablet: 6, desktop: 8),
                      right: ResponsiveHelper.getResponsiveValue(context, mobile: 4, tablet: 6, desktop: 8),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(context, mobile: 2, tablet: 3, desktop: 4)),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content section
            Expanded(
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                  top: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
                  bottom: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ResponsiveText(
                            lesson.title,
                            type: ResponsiveTextType.body,
                            customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lesson.isCompleted)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 8, desktop: 10),
                              vertical: ResponsiveHelper.getResponsiveValue(context, mobile: 2, tablet: 3, desktop: 4)
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 9, desktop: 10)),
                            ),
                            child: ResponsiveText(
                              'DONE',
                              type: ResponsiveTextType.body,
                              customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 9, desktop: 10),
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 6, large: 8)),
                    Expanded(
                      child: ResponsiveText(
                        lesson.description,
                        type: ResponsiveTextType.body,
                        customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 11, desktop: 12),
                        color: isDark ? Colors.white70 : AppTheme.textSecondary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 8, desktop: 10),
                            vertical: ResponsiveHelper.getResponsiveValue(context, mobile: 2, tablet: 3, desktop: 4),
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 7, desktop: 8)),
                          ),
                          child: ResponsiveText(
                            'Lesson ${lesson.order}',
                            type: ResponsiveTextType.body,
                            customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 11, desktop: 12),
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            if (lesson.isCompleted)
                              Icon(
                                Icons.check_circle,
                                size: ResponsiveHelper.getResponsiveValue(context, mobile: 14, tablet: 16, desktop: 18),
                                color: Colors.green,
                              )
                            else if (lesson.isUnlocked)
                              Icon(
                                Icons.play_circle_fill,
                                size: ResponsiveHelper.getResponsiveValue(context, mobile: 14, tablet: 16, desktop: 18),
                                color: AppTheme.primaryOrange,
                              )
                            else
                              Icon(
                                Icons.lock,
                                size: ResponsiveHelper.getResponsiveValue(context, mobile: 14, tablet: 16, desktop: 18),
                                color: Colors.grey,
                              ),
                            SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 5, large: 6)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
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
