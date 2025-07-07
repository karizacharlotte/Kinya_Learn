import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navigation.dart';
import '../data/kinyarwanda_lessons.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
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
            padding: ResponsiveHelper.getResponsiveHorizontalPadding(context)
                .copyWith(
              top: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
              bottom: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [
                        Theme.of(context).colorScheme.background,
                        Theme.of(context).colorScheme.background
                      ]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
              ),
            ),
            child: _buildHeader(context, isDarkMode),
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

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return ResponsiveLayout(
      mobilePortrait: _buildHeaderContent(context, isDarkMode, false),
      mobileLandscape: _buildHeaderContent(context, isDarkMode, true),
      tabletPortrait: _buildHeaderContent(context, isDarkMode, false),
      tabletLandscape: _buildHeaderContent(context, isDarkMode, true),
      desktop: _buildHeaderContent(context, isDarkMode, true),
      fallback: _buildHeaderContent(context, isDarkMode, false),
    );
  }

  Widget _buildHeaderContent(
      BuildContext context, bool isDarkMode, bool isHorizontal) {
    final theme = Theme.of(context);

    final titleWidget = ResponsiveText(
      'Kinyarwanda Lessons',
      type: ResponsiveTextType.header,
      color: isDarkMode ? theme.colorScheme.onSurface : Colors.white,
      fontWeight: FontWeight.bold,
    );

    final subtitleWidget = ResponsiveText(
      'Master Kinyarwanda step by step',
      type: ResponsiveTextType.body,
      color: isDarkMode
          ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
          : Colors.white.withValues(alpha: 0.9),
    );

    final iconWidget = Icon(
      Icons.menu_book,
      color: isDarkMode ? theme.colorScheme.onSurface : Colors.white,
      size: ResponsiveHelper.getResponsiveIconSize(context) * 1.2,
    );

    if (isHorizontal) {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                SizedBox(
                    height:
                        ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                subtitleWidget,
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
          iconWidget,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: titleWidget),
              iconWidget,
            ],
          ),
          SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          subtitleWidget,
        ],
      );
    }
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    final theme = Theme.of(context);

    return ResponsiveCard(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/lesson',
          arguments: lesson.id,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Header
          Row(
            children: [
              Container(
                width: ResponsiveHelper.getResponsiveIconSize(context) * 1.5,
                height: ResponsiveHelper.getResponsiveIconSize(context) * 1.5,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: ResponsiveText(
                    '${lesson.id}',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      lesson.title,
                      type: ResponsiveTextType.title,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(context) *
                            0.25),
                    ResponsiveText(
                      lesson.description,
                      color: theme.textTheme.bodyMedium?.color,
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
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.success),
                  ),
                ),
                SizedBox(
                    width:
                        ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                ResponsiveText(
                  'Complete',
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
            SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          ],

          // Lesson Stats
          Row(
            children: [
              Icon(
                Icons.quiz,
                size: ResponsiveHelper.getResponsiveIconSize(context) * 0.8,
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
              ResponsiveText(
                '${lesson.exercises.length} exercises',
                color: theme.textTheme.bodySmall?.color,
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
              Icon(
                lesson.isUnlocked ? Icons.lock_open : Icons.lock,
                size: ResponsiveHelper.getResponsiveIconSize(context) * 0.8,
                color: lesson.isUnlocked
                    ? AppTheme.success
                    : theme.textTheme.bodySmall?.color,
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
              ResponsiveText(
                lesson.isUnlocked ? 'Available' : 'Locked',
                color: lesson.isUnlocked
                    ? AppTheme.success
                    : theme.textTheme.bodySmall?.color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
