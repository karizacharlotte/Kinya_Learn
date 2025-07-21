import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';

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
<<<<<<< HEAD
                  // Hero Section

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop(context)
                          ? 60
                          : (isTablet(context) ? 40 : 24),
                      vertical: isDesktop(context)
                          ? 80
                          : (isTablet(context) ? 60 : 40),
                    ),
                    decoration: BoxDecoration(
                      gradient: ThemeHelper.getHeroGradient(context),
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
                                      fontSize: isDesktop(context)
                                          ? 48
                                          : (isTablet(context) ? 36 : 28),
                                      fontWeight: FontWeight.bold,
                                      color:
                                          ThemeHelper.getAppBarForegroundColor(
                                              context),
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: isTablet(context) ? 20 : 16),
                                  Text(
                                    'Master Rwanda\'s beautiful language through interactive lessons, cultural insights, and certified achievements.',
                                    style: TextStyle(
                                      fontSize: isDesktop(context)
                                          ? 20
                                          : (isTablet(context) ? 18 : 16),
                                      color:
                                          ThemeHelper.getAppBarForegroundColor(
                                                  context)
                                              .withValues(alpha: 0.9),
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: isTablet(context) ? 32 : 24),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/lessons'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isDark ? Colors.white : Colors.white,
                                      foregroundColor: isDark
                                          ? Colors.black
                                          : AppTheme.primaryOrange,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet(context) ? 32 : 24,
                                        vertical: isTablet(context) ? 20 : 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Start Learning',
                                      style: TextStyle(
                                        fontSize: isTablet(context) ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.black
                                            : AppTheme.primaryOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isMobile(context)) ...[
                              const SizedBox(width: 40),
                              Container(
                                width: isDesktop(context) ? 300 : 200,
                                height: isDesktop(context) ? 200 : 133,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color(0xFF00A1DE),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color.fromARGB(
                                              255, 162, 143, 49),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color.fromARGB(
                                              255, 59, 117, 87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Features Section
                  Padding(
                    padding: EdgeInsets.all(isDesktop(context)
                        ? 60
                        : (isTablet(context) ? 40 : 24)),
                    child: Column(
                      children: [
                        Text(
                          'Why Choose KinyaLearn?',
                          style: TextStyle(
                            fontSize: isDesktop(context)
                                ? 36
                                : (isTablet(context) ? 28 : 24),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet(context) ? 40 : 32),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop(context)
                              ? 3
                              : (isTablet(context) ? 2 : 1),
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: isDesktop(context)
                              ? 1.2
                              : (isTablet(context) ? 1.1 : 1.5),
                          children: [
                            _buildFeatureCard(
                              'Interactive Lessons',
                              'Learn through engaging exercises and real-world scenarios',
                              Icons.school_rounded,
                              AppTheme.primaryOrange,
                              context,
                            ),
                            _buildFeatureCard(
                              'Cultural Integration',
                              'Understand Rwandan culture and context behind the language',
                              Icons.language_rounded,
                              const Color(0xFF00A1DE),
                              context,
                            ),
                            _buildFeatureCard(
                              'Certified Learning',
                              'Earn certificates and showcase your achievements',
                              Icons.emoji_events_rounded,
                              const Color(0xFF00A651),
                              context,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // CTA Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isDesktop(context)
                        ? 60
                        : (isTablet(context) ? 40 : 24)),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.surface
                          : AppTheme.primaryOrange,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ready to Start Learning?',
                          style: TextStyle(
                            fontSize: isDesktop(context)
                                ? 32
                                : (isTablet(context) ? 24 : 20),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet(context) ? 20 : 16),
                        Text(
                          'Join thousands of learners mastering Kinyarwanda',
                          style: TextStyle(
                            fontSize: isDesktop(context)
                                ? 18
                                : (isTablet(context) ? 16 : 14),
                            color: isDark
                                ? Colors.white70
                                : Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet(context) ? 32 : 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
=======
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
>>>>>>> 9fe180cf77d9f06061edd0cd9eea09ab64d7e0a1
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
<<<<<<< HEAD
                            if (!isMobile(context)) ...[
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/culture'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      ThemeHelper.getAppBarForegroundColor(
                                          context),
                                  side: BorderSide(
                                      color:
                                          ThemeHelper.getAppBarForegroundColor(
                                              context),
                                      width: 2),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet(context) ? 32 : 24,
                                    vertical: isTablet(context) ? 20 : 16,
                                  ),
                                ),
                                child: Text(
                                  'Explore Culture',
                                  style: TextStyle(
                                    fontSize: isTablet(context) ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
=======
>>>>>>> 9fe180cf77d9f06061edd0cd9eea09ab64d7e0a1
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
<<<<<<< HEAD
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildRwandaFlag(context),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroText(context),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              Center(child: _buildRwandaFlag(context)),
            ],
          ),
      ],
    );
  }

  Widget _buildHeroText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn Kinyarwanda\nwith KinyaLearn',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveHeaderFontSize(context),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.white,
            height: 1.2,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
        Text(
          'Master Rwanda\'s beautiful language through interactive lessons, cultural insights, and certified achievements.',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
            color: isDark ? Colors.white70 : Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        SizedBox(
            height:
                ResponsiveHelper.getResponsiveSpacing(context, factor: 1.5)),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/lessons'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.white,
            foregroundColor: isDark ? Colors.black : AppTheme.primaryOrange,
            padding: ResponsiveHelper.getResponsiveButtonPadding(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Start Learning',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRwandaFlag(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveHelper.isDesktop(context) ? 200 : 150,
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF00A1DE),
=======
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
>>>>>>> 9fe180cf77d9f06061edd0cd9eea09ab64d7e0a1
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
