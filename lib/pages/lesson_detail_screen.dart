import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinya_learn/video.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../utils/responsive_helper.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool isContentCompleted = false;
  bool isVideoFullscreen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // If video is in fullscreen mode, show only the video
    if (isVideoFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            VideoPlayerScreen(
              videoUrl: "https://www.youtube.com/watch?v=dVqm40wcnL4",
              // autoPlay: true,
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  setState(() {
                    isVideoFullscreen = false;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

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
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.9),
                      fontSize:
                          ResponsiveHelper.getResponsiveBodyFontSize(context),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context,
                    factor: 1.5)),

            // Lesson Content
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

            // Video Section with Fullscreen Button
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getResponsiveSpacing(context,
                      factor: 1.5)),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayerScreen(
                        videoUrl: "https://www.youtube.com/watch?v=dVqm40wcnL4",
                      ),
                      Positioned.fill(
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 50),
                            onPressed: () {
                              setState(() {
                                isVideoFullscreen = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('Open Video in Fullscreen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: ResponsiveHelper.getResponsiveButtonPadding(
                            context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isVideoFullscreen = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context,
                    factor: 1.5)),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isContentCompleted
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/practice-quiz',
                              arguments: widget.lesson,
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
