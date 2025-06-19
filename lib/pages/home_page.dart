import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;
    final isMobile = screenWidth < 768; // Fix: Use local context instead

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const Navigation(),
          Expanded(
            child: SingleChildScrollView(
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
                        colors: [
                          Color.fromARGB(255, 78, 42, 147),
                          Color.fromARGB(255, 78, 42, 147),
                        ],
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
                                      fontSize:
                                          isDesktop ? 48 : (isTablet ? 36 : 28),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 20 : 16),
                                  Text(
                                    'Master Rwanda\'s beautiful language through interactive lessons, cultural insights, and certified achievements.',
                                    style: TextStyle(
                                      fontSize:
                                          isDesktop ? 20 : (isTablet ? 18 : 16),
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 32 : 24),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/lessons'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color.fromARGB(
                                          255,
                                          78,
                                          42,
                                          147), // changed from 158,74,21
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
                            if (!isMobile) ...[
                              const SizedBox(width: 40),
                              Container(
                                width: isDesktop ? 300 : 200,
                                height: isDesktop ? 200 : 133,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
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
                                          color: const Color.fromARGB(255, 162, 143, 49),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          color: const Color.fromARGB(255, 59, 117, 87),
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
                    padding:
                        EdgeInsets.all(isDesktop ? 60 : (isTablet ? 40 : 24)),
                    child: Column(
                      children: [
                        Text(
                          'Why Choose KinyaLearn?',
                          style: TextStyle(
                            fontSize: isDesktop ? 36 : (isTablet ? 28 : 24),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet ? 40 : 32),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio:
                              isDesktop ? 1.2 : (isTablet ? 1.1 : 1.5),
                          children: [
                            _buildFeatureCard(
                              'Interactive Lessons',
                              'Learn through engaging exercises and real-world scenarios',
                              Icons.school_rounded,
                              const Color.fromARGB(
                                  255, 78, 42, 147), // changed from 158,74,21
                              isTablet,
                            ),
                            _buildFeatureCard(
                              'Cultural Integration',
                              'Understand Rwandan culture and context behind the language',
                              Icons.language_rounded,
                              const Color(0xFF00A1DE),
                              isTablet,
                            ),
                            _buildFeatureCard(
                              'Certified Learning',
                              'Earn certificates and showcase your achievements',
                              Icons.emoji_events_rounded,
                              const Color(0xFF00A651),
                              isTablet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // CTA Section
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.all(isDesktop ? 60 : (isTablet ? 40 : 24)),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(
                              255, 78, 42, 147), // changed from 95,72,60
                          Color.fromARGB(
                              255, 78, 42, 147), // changed from 158,74,21
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ready to Start Learning?',
                          style: TextStyle(
                            fontSize: isDesktop ? 32 : (isTablet ? 24 : 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        Text(
                          'Join thousands of learners mastering Kinyarwanda',
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isTablet ? 32 : 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/lessons'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color.fromARGB(
                                    255, 78, 42, 147), // changed from 158,74,21
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 32 : 24,
                                  vertical: isTablet ? 20 : 16,
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
                            if (!isMobile) ...[
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/culture'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 32 : 24,
                                    vertical: isTablet ? 20 : 16,
                                  ),
                                ),
                                child: Text(
                                  'Explore Culture',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon,
      Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: isTablet ? 64 : 56,
            height: isTablet ? 64 : 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: isTablet ? 32 : 28,
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            description,
            style: TextStyle(
              fontSize: isTablet ? 14 : 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
