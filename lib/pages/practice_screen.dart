import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../utils/responsive_layout.dart';
import 'practice_selection_screen.dart';
import 'speaking_practice_screen.dart';
import 'listening_exercises_screen.dart';
import 'quick_review_screen.dart';
import 'translation_practice_screen.dart';
import 'grammar_drills_screen.dart';
import 'daily_scenarios_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ResponsiveScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Practice Header
          Container(
            padding: ResponsiveHelper.getResponsivePadding(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [theme.colorScheme.surface, theme.colorScheme.surface]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          'Practice & Review',
                          type: ResponsiveTextType.header,
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                        ResponsiveText(
                          'Strengthen your Kinyarwanda skills',
                          type: ResponsiveTextType.body,
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.fitness_center,
                      color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                      size: ResponsiveHelper.getResponsiveIconSize(context) * 1.5),
                ],
              ),
            ),
          ),
          // Practice Options
          Expanded(
            child: Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: ResponsiveGrid(
                mobileColumns: 2,
                tabletColumns: 2,
                desktopColumns: 3,
                spacing: ResponsiveHelper.getResponsiveSpacing(context),
                runSpacing: ResponsiveHelper.getResponsiveSpacing(context),
                childAspectRatio: ResponsiveHelper.getResponsiveValue(context, mobile: 1.0, tablet: 1.1, desktop: 1.2),
                children: [
                  _buildPracticeCard(
                    context,
                    'Lesson Quizzes',
                    'Test your knowledge',
                    Icons.quiz,
                    const Color(0xFF4CAF50),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PracticeSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Speaking Practice',
                    'Pronunciation & Conversation',
                    Icons.mic,
                    AppTheme.primaryOrange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpeakingPracticeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Listening Exercises',
                    'Comprehension Training',
                    Icons.headphones,
                    const Color(0xFF00A1DE),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListeningExercisesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Quick Review',
                    'Flash Cards & Vocabulary',
                    Icons.quiz,
                    const Color(0xFF00A651),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuickReviewScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Translation Practice',
                    'English ↔ Kinyarwanda',
                    Icons.translate,
                    const Color(0xFFFAD201),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TranslationPracticeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Grammar Drills',
                    'Sentence Structure',
                    Icons.school,
                    AppTheme.primaryOrange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GrammarDrillsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildPracticeCard(
                    context,
                    'Daily Scenarios',
                    'Real-life Conversations',
                    Icons.chat_bubble,
                    const Color(0xFF00A1DE),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyScenariosScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Daily Challenge
          Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final isDark = theme.brightness == Brightness.dark;
              return Container(
                margin: ResponsiveHelper.getResponsivePadding(context),
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface
                      : AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                        size: ResponsiveHelper.getResponsiveIconSize(context) * 1.5),
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            'Daily Challenge',
                            type: ResponsiveTextType.title,
                            color: isDark ? theme.colorScheme.onSurface : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 6, large: 8)),
                          ResponsiveText(
                            'Complete today\'s challenge for bonus XP!',
                            type: ResponsiveTextType.body,
                            color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          ),
                        ],
                      ),
                    ),
                    ResponsiveButton(
                      onPressed: () {},
                      backgroundColor: isDark ? theme.cardColor : Colors.white,
                      foregroundColor: isDark ? Colors.white : AppTheme.primaryOrange,
                      child: ResponsiveText(
                        'Start',
                        type: ResponsiveTextType.body,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildPracticeCard(BuildContext context, String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ResponsiveCard(
      onTap: onTap,
      color: theme.cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ResponsiveHelper.getResponsiveValue(context, mobile: 50, tablet: 60, desktop: 70),
            height: ResponsiveHelper.getResponsiveValue(context, mobile: 50, tablet: 60, desktop: 70),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 16, tablet: 18, desktop: 20)),
            ),
            child: Icon(
              icon, 
              color: color, 
              size: ResponsiveHelper.getResponsiveValue(context, mobile: 24, tablet: 28, desktop: 32)
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 16, large: 20)),
          ResponsiveText(
            title,
            type: ResponsiveTextType.body,
            customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 6, large: 8)),
          ResponsiveText(
            subtitle,
            type: ResponsiveTextType.body,
            customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
