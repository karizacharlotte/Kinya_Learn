import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navigation.dart';
import '../data/kinyarwanda_lessons.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../theme/theme_helper.dart';
import '../utils/responsive_helper.dart';
import '../utils/responsive_layout.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLessons.getLessons();
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return ResponsiveScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
            const Navigation(),
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isDesktop(context) ? 40 : (ResponsiveHelper.isTablet(context) ? 32 : 20),
                vertical: ResponsiveHelper.isDesktop(context) ? 40 : (ResponsiveHelper.isTablet(context) ? 32 : 24),
              ),
              decoration: BoxDecoration(
                gradient: ThemeHelper.getHeroGradient(context),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kinyarwanda Lessons',
                          style: TextStyle(
                            color: ThemeHelper.getAppBarForegroundColor(context),
                            fontSize: ResponsiveHelper.isDesktop(context) ? 32 : (ResponsiveHelper.isTablet(context) ? 28 : 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Master Kinyarwanda step by step',
                          style: TextStyle(
                            color: ThemeHelper.getAppBarForegroundColor(context).withValues(alpha: 0.9),
                            fontSize: ResponsiveHelper.isDesktop(context) ? 18 : (ResponsiveHelper.isTablet(context) ? 16 : 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.menu_book,
                      color: ThemeHelper.getAppBarForegroundColor(context), 
                      size: ResponsiveHelper.isTablet(context) ? 36 : 28),
                ],
              ),
            ),
          // Lessons Grid
          Expanded(
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                child: ResponsiveGrid(
                  mobileColumns: 1,
                  tabletColumns: ResponsiveHelper.isLandscape(context) ? 2 : 1,
                  desktopColumns: 3,
                  spacing: ResponsiveHelper.getResponsiveSpacing(context),
                  runSpacing: ResponsiveHelper.getResponsiveSpacing(context),
                  children: lessons
                      .map((lesson) => _buildLessonCard(context, lesson))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    final theme = Theme.of(context);
    
    // Define color based on lesson state
    final Color color = lesson.isCompleted
        ? AppTheme.success
        : lesson.isUnlocked
            ? AppTheme.primaryOrange
            : theme.disabledColor;

    return Card(
      margin: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),        child: InkWell(
          onTap: lesson.isUnlocked
              ? () {
                  Navigator.pushNamed(
                    context,
                    '/lesson-detail',
                    arguments: lesson,
                  );
                }
              : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lesson Header
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.isTablet(context) ? 64 : 56,
                    height: ResponsiveHelper.isTablet(context) ? 64 : 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      lesson.isCompleted
                          ? Icons.check_circle_rounded
                          : lesson.isUnlocked
                              ? Icons.play_circle_rounded
                              : Icons.lock_rounded,
                      color: color,
                      size: ResponsiveHelper.isTablet(context) ? 32 : 28,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.isTablet(context) ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
                        Text(
                          lesson.description,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.isTablet(context) ? 14 : 12,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Progress Bar
              if (lesson.isCompleted) ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: theme.colorScheme.surface,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.success),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                    Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.isTablet(context) ? 12 : 10,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
              ],

              // Lesson Stats
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    size: ResponsiveHelper.isTablet(context) ? 16 : 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
                  Text(
                    '${lesson.exercises.length} exercises',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.isTablet(context) ? 12 : 10,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                  Icon(
                    lesson.isUnlocked ? Icons.lock_open : Icons.lock,
                    size: ResponsiveHelper.isTablet(context) ? 16 : 14,
                    color: lesson.isUnlocked ? AppTheme.success : theme.textTheme.bodySmall?.color,
                  ),
                  SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
                  Text(
                    lesson.isUnlocked ? 'Available' : 'Locked',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.isTablet(context) ? 12 : 10,
                      color: lesson.isUnlocked ? AppTheme.success : theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
