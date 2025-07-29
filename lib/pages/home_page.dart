import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
=======
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;
>>>>>>> 9fe180cf77d9f06061edd0cd9eea09ab64d7e0a1

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
                    vertical: isDesktop ? 80 : (isTablet ? 60 : 40),
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
                                  Text(
                                    'Welcome back, ${authProvider.displayName}!',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 12 : 8),
                                  Text(
                                    'Continue your Kinyarwanda learning journey',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                                      color: Colors.white.withValues(alpha: 0.9),
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
                        SizedBox(height: isTablet ? 32 : 24),
                        // User Stats
                        Row(
                          children: [
                            _buildStatCard(
                              context,
                              'XP',
                              '${authProvider.totalXP}',
                              Icons.star,
                              isTablet,
                            ),
                            SizedBox(width: isTablet ? 16 : 12),
                            _buildStatCard(
                              context,
                              'Streak',
                              '${authProvider.currentStreak} days',
                              Icons.local_fire_department,
                              isTablet,
                            ),
                            SizedBox(width: isTablet ? 16 : 12),
                            _buildStatCard(
                              context,
                              'Lessons',
                              '${authProvider.lessonsCompleted}',
                              Icons.book,
                              isTablet,
                            ),
                          ],
                        ),
                      ] else ...[
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
                                  
                                  // Sign In Button for guests
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/auth');
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
                                      'Sign In to Track Progress',
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
                      
                      SizedBox(height: isTablet ? 32 : 24),
                      
                      // Debug: Firebase Test Button (remove in production)
                      if (const bool.fromEnvironment('dart.vm.product') == false)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/firebase-test');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 24 : 20,
                                vertical: isTablet ? 16 : 12,
                              ),
                            ),
                            child: Text('🔧 Test Backend Connection'),
                          ),
                        ),
                      
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
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, bool isTablet) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: isTablet ? 24 : 20),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
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
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
