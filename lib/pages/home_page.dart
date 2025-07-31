import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_layout.dart';
import '../utils/responsive_helper.dart';
import '../widgets/rwandan_flag.dart';
import 'notes_page.dart';
import 'learning_goals_page.dart';
import 'vocabulary_page.dart';
import 'student_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ResponsiveScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Welcome Section
                      if (authProvider.isLoggedIn) ...[ 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveText(
                                    'Welcome back, ${authProvider.displayName}!',
                                    type: ResponsiveTextType.header,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                                  ResponsiveText(
                                    'Continue your Kinyarwanda learning journey',
                                    type: ResponsiveTextType.body,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 24, medium: 28, large: 32)),
                                  Center(
                                    child: RwandanFlag(
                                      width: 120,
                                      height: 80,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showLogoutDialog(context),
                              icon: const Icon(Icons.logout, color: Colors.white),
                              tooltip: 'Logout',
                            ),
                          ],
                        ),
                        // ...removed stats and grid, replaced with flag above...
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveText(
                                    'Learn Kinyarwanda\nwith KinyaLearn',
                                    type: ResponsiveTextType.header,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 28, tablet: 36, desktop: 48),
                                  ),
                                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 16, medium: 18, large: 20)),
                                  ResponsiveText(
                                    'Master the beautiful language of Rwanda through interactive lessons, cultural insights, and practical exercises.',
                                    type: ResponsiveTextType.body,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 16, tablet: 18, desktop: 20),
                                  ),
                                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 24, medium: 28, large: 32)),
                                  // Sign In Button for guests
                                  ResponsiveButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/auth');
                                    },
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppTheme.primaryOrange,
                                    child: ResponsiveText(
                                      'Sign In to Track Progress',
                                      type: ResponsiveTextType.body,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (ResponsiveHelper.isDesktop(context))
                              Expanded(
                                child: Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                  child: const Center(
                                    child: RwandanFlag(
                                      width: 200,
                                      height: 133,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],

                      SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 24, medium: 28, large: 32)),
                    ],
                  ),
                ),

                // Student Tools Section (for logged-in users)
                if (authProvider.isLoggedIn) ...[
                  Container(
                    width: double.infinity,
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      color: isDark ? Theme.of(context).colorScheme.surface : Colors.grey[50],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          'Study Tools',
                          type: ResponsiveTextType.title,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                        ),
                        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16)),
                        // Quick Dashboard Button
                        ResponsiveButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StudentDashboard()),
                          ),
                          backgroundColor: AppTheme.primaryOrange,
                          foregroundColor: Colors.white,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.dashboard),
                              SizedBox(width: 8),
                              ResponsiveText('View Student Dashboard', type: ResponsiveTextType.body),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16)),
                        ResponsiveGrid(
                          mobileColumns: 2,
                          tabletColumns: 3,
                          desktopColumns: 4,
                          children: [
                            _buildStudentToolCard(
                              context,
                              Icons.note_alt_outlined,
                              'My Notes',
                              'Personal lesson notes',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NotesPage()),
                              ),
                            ),
                            _buildStudentToolCard(
                              context,
                              Icons.track_changes,
                              'Learning Goals',
                              'Set & track goals',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LearningGoalsPage()),
                              ),
                            ),
                            _buildStudentToolCard(
                              context,
                              Icons.book_outlined,
                              'Vocabulary',
                              'Personal word list',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const VocabularyPage()),
                              ),
                            ),
                            _buildStudentToolCard(
                              context,
                              Icons.bookmark_outline,
                              'Bookmarks',
                              'Saved lessons',
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Bookmarks feature coming soon!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // Features Section
                Container(
                  width: double.infinity,
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Column(
                    children: [
                      ResponsiveText(
                        'Why Choose KinyaLearn?',
                        type: ResponsiveTextType.header,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textPrimary,
                      ),
                      SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 32, medium: 40, large: 48)),
                      ResponsiveGrid(
                        mobileColumns: 1,
                        tabletColumns: 2,
                        desktopColumns: 3,
                        children: [
                          _buildFeatureCard(
                            context,
                            Icons.video_library,
                            'Interactive Videos',
                            'Learn with authentic Kinyarwanda videos and interactive content',
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.quiz,
                            'Practice Quizzes',
                            'Test your knowledge with engaging quizzes and exercises',
                          ),
                          _buildFeatureCard(
                            context,
                            Icons.volume_up,
                            'Perfect Pronunciation',
                            'Master authentic Kinyarwanda pronunciation with TTS support',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Quick Start Section
                Container(
                  width: double.infinity,
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).colorScheme.surface
                        : AppTheme.cardBackground,
                  ),
                  child: Column(
                    children: [
                      ResponsiveText(
                        'Quick Start',
                        type: ResponsiveTextType.header,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textPrimary,
                      ),
                      SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 32, medium: 40, large: 48)),
                      ResponsiveGrid(
                        mobileColumns: 1,
                        tabletColumns: 2,
                        desktopColumns: 3,
                        children: [
                          _buildQuickStartCard(
                            context,
                            'Lessons',
                            'Start with structured lessons',
                            Icons.book,
                            '/lessons',
                          ),
                          _buildQuickStartCard(
                            context,
                            'Practice',
                            'Test your skills',
                            Icons.quiz,
                            '/practice',
                          ),
                          _buildQuickStartCard(
                            context,
                            'Settings',
                            'Customize your learning',
                            Icons.settings,
                            '/settings',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return ResponsiveCard(
      color: Colors.white.withValues(alpha: 0.2),
      child: Column(
        children: [
          Icon(
            icon, 
            color: Colors.white, 
            size: ResponsiveHelper.getResponsiveIconSize(context)
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 6, large: 8)),
          ResponsiveText(
            value,
            type: ResponsiveTextType.body,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ResponsiveText(
            label,
            type: ResponsiveTextType.body,
            customFontSize: ResponsiveHelper.getResponsiveBodyFontSize(context) * 0.8,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveCard(
      color: isDark ? Theme.of(context).colorScheme.surface : AppTheme.cardBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: ResponsiveHelper.getResponsivePadding(context),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: ResponsiveHelper.getResponsiveIconSize(context) * 1.5,
              color: AppTheme.primaryOrange,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
          ResponsiveText(
            title,
            type: ResponsiveTextType.title,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textPrimary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 12, large: 16)),
          ResponsiveText(
            description,
            type: ResponsiveTextType.body,
            color: isDark ? Colors.white70 : AppTheme.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(BuildContext context, String title, String description, IconData icon, String route) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: ResponsiveCard(
        color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: ResponsiveHelper.getResponsivePadding(context),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: ResponsiveHelper.getResponsiveIconSize(context) * 1.5,
                color: Colors.white,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            ResponsiveText(
              title,
              type: ResponsiveTextType.title,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 12, large: 16)),
            ResponsiveText(
              description,
              type: ResponsiveTextType.body,
              color: isDark ? Colors.white70 : AppTheme.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentToolCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ResponsiveCard(
        color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: ResponsiveHelper.getResponsivePadding(context),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: ResponsiveHelper.getResponsiveIconSize(context),
                color: AppTheme.primaryOrange,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            ResponsiveText(
              title,
              type: ResponsiveTextType.body,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 6, medium: 8, large: 10)),
            ResponsiveText(
              description,
              type: ResponsiveTextType.body,
              customFontSize: ResponsiveHelper.getResponsiveBodyFontSize(context) * 0.9,
              color: isDark ? Colors.white70 : AppTheme.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/auth');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}