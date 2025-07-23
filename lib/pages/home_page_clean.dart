import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
                vertical: isDesktop ? 80 : (isTablet ? 60 : 40),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primaryOrange, AppTheme.primaryOrange],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learn Kinyarwanda\nwith KinyaLearn',
                              style: TextStyle(
                                fontSize: isDesktop ? 48 : (isTablet ? 36 : 28),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            Text(
                              'Master the beautiful language of Rwanda through interactive lessons, cultural insights, and practical exercises.',
                              style: TextStyle(
                                fontSize: isDesktop ? 20 : (isTablet ? 18 : 16),
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            SizedBox(height: isTablet ? 32 : 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/lessons');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryOrange,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 32 : 24,
                                  vertical: isTablet ? 20 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Start Learning',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isDesktop)
                        Expanded(
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.language,
                                size: 120,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
                vertical: isDesktop ? 80 : (isTablet ? 60 : 40),
              ),
              child: Column(
                children: [
                  Text(
                    'Why Choose KinyaLearn?',
                    style: TextStyle(
                      fontSize: isDesktop ? 36 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: isTablet ? 48 : 32),
                  GridView.count(
                    crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: isDesktop ? 40 : (isTablet ? 30 : 20),
                    crossAxisSpacing: isDesktop ? 40 : (isTablet ? 30 : 20),
                    childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.1 : 1.5),
                    children: [
                      _buildFeatureCard(
                        context,
                        Icons.video_library,
                        'Interactive Videos',
                        'Learn with authentic Kinyarwanda videos and interactive content',
                        isTablet,
                      ),
                      _buildFeatureCard(
                        context,
                        Icons.quiz,
                        'Practice Quizzes',
                        'Test your knowledge with engaging quizzes and exercises',
                        isTablet,
                      ),
                      _buildFeatureCard(
                        context,
                        Icons.volume_up,
                        'Perfect Pronunciation',
                        'Master authentic Kinyarwanda pronunciation with TTS support',
                        isTablet,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Start Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
                vertical: isDesktop ? 80 : (isTablet ? 60 : 40),
              ),
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).colorScheme.surface : AppTheme.cardBackground,
              ),
              child: Column(
                children: [
                  Text(
                    'Quick Start',
                    style: TextStyle(
                      fontSize: isDesktop ? 36 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: isTablet ? 48 : 32),
                  GridView.count(
                    crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: isDesktop ? 40 : (isTablet ? 30 : 20),
                    crossAxisSpacing: isDesktop ? 40 : (isTablet ? 30 : 20),
                    childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.1 : 1.5),
                    children: [
                      _buildQuickStartCard(
                        context,
                        'Lessons',
                        'Start with structured lessons',
                        Icons.book,
                        '/lessons',
                        isTablet,
                      ),
                      _buildQuickStartCard(
                        context,
                        'Practice',
                        'Test your skills',
                        Icons.quiz,
                        '/practice',
                        isTablet,
                      ),
                      _buildQuickStartCard(
                        context,
                        'Settings',
                        'Customize your learning',
                        Icons.settings,
                        '/settings',
                        isTablet,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String description, bool isTablet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surface : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: isTablet ? 48 : 40,
              color: AppTheme.primaryOrange,
            ),
          ),
          SizedBox(height: isTablet ? 24 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: isDark ? Colors.white70 : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(BuildContext context, String title, String description, IconData icon, String route, bool isTablet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: isTablet ? 48 : 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: isDark ? Colors.white70 : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
