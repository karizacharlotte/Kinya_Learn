import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../components/reliable_video_widget.dart';
import '../utils/responsive_helper.dart';
import 'enhanced_practice_quiz_screen.dart';


class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool isContentCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(

      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          widget.lesson.title,
          style: TextStyle(
            color: theme.appBarTheme.titleTextStyle?.color ??
                theme.colorScheme.onSurface,
            fontSize: ResponsiveHelper.getResponsiveTitleFontSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.appBarTheme.iconTheme?.color ??
                  theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lesson.title,
                    style: TextStyle(
                      color: isDarkMode
                          ? theme.colorScheme.onSurface
                          : Colors.white,
                      fontSize:
                          ResponsiveHelper.getResponsiveHeaderFontSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height:
                          ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                  Text(
                    widget.lesson.description,
                    style: TextStyle(

                      color: isDarkMode
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                      fontSize: ResponsiveHelper.isTablet(context) ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),

            // Video Section 
            if (widget.lesson.videoUrl != null) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveHelper.isTablet(context) ? 24 : 20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson Video',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.isTablet(context) ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ReliableVideoWidget(
                      videoUrl: widget.lesson.videoUrl!,
                      videoTitle: widget.lesson.videoTitle,
                    ),
                  ],
                ),
              ),
            ],


            // Lesson Content
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson Content',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.getResponsiveTitleFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(context)),
                  Text(
                    widget.lesson.description,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.getResponsiveBodyFontSize(context),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(context,
                          factor: 1.25)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isContentCompleted
                          ? null
                          : () {
                              setState(() {
                                isContentCompleted = true;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.white : AppTheme.primaryOrange,
                        foregroundColor:
                            isDarkMode ? AppTheme.primaryOrange : Colors.white,
                        padding: ResponsiveHelper.getResponsiveButtonPadding(
                            context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isContentCompleted
                            ? '✓ Content Completed'
                            : 'Mark as Complete',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveBodyFontSize(
                              context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isContentCompleted
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnhancedPracticeQuizScreen(lesson: widget.lesson),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? theme.colorScheme.primary
                          : AppTheme.primaryBlue,
                      foregroundColor: isDarkMode
                          ? theme.colorScheme.onPrimary
                          : Colors.white,
                      padding:
                          ResponsiveHelper.getResponsiveButtonPadding(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Take Practice Quiz'),
                  ),
                ),
                SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isContentCompleted
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: widget.lesson,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.white : AppTheme.primaryOrange,
                      foregroundColor:
                          isDarkMode ? AppTheme.primaryOrange : Colors.white,
                      padding:
                          ResponsiveHelper.getResponsiveButtonPadding(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Final Quiz & Certificate - \$9.99'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
