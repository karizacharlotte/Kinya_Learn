import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/lesson_service.dart';
import '../models/app_models.dart';
import 'enhanced_lessons_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> userStats = {};
  List<LessonModel> recentLessons = [];
  List<LessonModel> recommendedLessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.isLoggedIn) {
        // Load user progress statistics
        userStats = await LessonService.getUserOverallProgress();
        
        // Load recent lessons
        List<LessonModel> allLessons = await LessonService.getAllLessons();
        
        // Get user's current lesson (first incomplete lesson)
        recentLessons = allLessons.take(3).toList();
        
        // Recommend next lessons based on progress
        recommendedLessons = allLessons.where((lesson) => 
          lesson.order <= (userStats['completedLessons'] ?? 0) + 2
        ).take(4).toList();
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: isTablet ? 280 : 220,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? theme.colorScheme.surface : AppTheme.primaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            theme.colorScheme.surface,
                            theme.colorScheme.surface.withValues(alpha: 0.8),
                          ]
                        : [
                            AppTheme.primaryOrange,
                            AppTheme.primaryOrange.withValues(alpha: 0.8),
                            AppTheme.primaryGreen.withValues(alpha: 0.3),
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isTablet ? 12 : 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                              ),
                              child: Icon(
                                Icons.translate,
                                size: isTablet ? 32 : 24,
                                color: isDark ? theme.colorScheme.onSurface : Colors.white,
                              ),
                            ),
                            SizedBox(width: isTablet ? 16 : 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KinyaLearn',
                                    style: TextStyle(
                                      fontSize: isTablet ? 32 : 28,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? theme.colorScheme.onSurface : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Master Kinyarwanda with confidence',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 16,
                                      color: isDark 
                                        ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                                        : Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pushNamed(context, '/profile'),
                              icon: CircleAvatar(
                                backgroundColor: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                                child: Icon(
                                  Icons.person,
                                  color: isDark ? theme.colorScheme.onSurface : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 24 : 16),
                        if (authProvider.isLoggedIn) ...[
                          Text(
                            'Welcome back, ${authProvider.user?.displayName ?? 'Learner'}!',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? theme.colorScheme.onSurface : Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 4),
                          Text(
                            'Continue your Kinyarwanda journey',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: isDark 
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Start your Kinyarwanda journey today',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? theme.colorScheme.onSurface : Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/auth'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryOrange,
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 24 : 20,
                                vertical: isTablet ? 16 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                              ),
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User progress stats (if logged in)
                  if (authProvider.isLoggedIn && !isLoading && userStats.isNotEmpty) ...[
                    _buildProgressStats(isTablet, theme),
                    SizedBox(height: isTablet ? 32 : 24),
                  ],

                  // Quick actions
                  _buildQuickActions(isTablet, theme, authProvider.isLoggedIn),
                  SizedBox(height: isTablet ? 32 : 24),

                  // Featured content
                  _buildFeaturedContent(isTablet, theme),
                  SizedBox(height: isTablet ? 32 : 24),

                  // Recent/Recommended lessons
                  if (authProvider.isLoggedIn && !isLoading) ...[
                    if (recentLessons.isNotEmpty) ...[
                      _buildLessonSection(
                        'Continue Learning',
                        recentLessons,
                        isTablet,
                        theme,
                        Icons.play_circle_outline,
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                    ],
                    if (recommendedLessons.isNotEmpty) ...[
                      _buildLessonSection(
                        'Recommended for You',
                        recommendedLessons,
                        isTablet,
                        theme,
                        Icons.lightbulb_outline,
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                    ],
                  ],

                  // App features
                  _buildAppFeatures(isTablet, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStats(bool isTablet, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Lessons\nCompleted',
                  '${userStats['completedLessons'] ?? 0}',
                  Icons.school,
                  AppTheme.primaryGreen,
                  isTablet,
                  theme,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildStatCard(
                  'Total\nScore',
                  '${userStats['totalScore'] ?? 0}',
                  Icons.star,
                  AppTheme.primaryOrange,
                  isTablet,
                  theme,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildStatCard(
                  'Streak\nDays',
                  '${userStats['streakDays'] ?? 0}',
                  Icons.local_fire_department,
                  Colors.red,
                  isTablet,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isTablet, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: isTablet ? 32 : 24,
            color: color,
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 4 : 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isTablet, ThemeData theme, bool isLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isTablet ? 22 : 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isTablet ? 4 : 2,
          mainAxisSpacing: isTablet ? 16 : 12,
          crossAxisSpacing: isTablet ? 16 : 12,
          childAspectRatio: isTablet ? 1.2 : 1.1,
          children: [
            _buildActionCard(
              'Lessons',
              Icons.book,
              AppTheme.primaryOrange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EnhancedLessonsScreen()),
              ),
              isTablet,
              theme,
            ),
            _buildActionCard(
              'Practice',
              Icons.fitness_center,
              AppTheme.primaryGreen,
              () {
                if (isLoggedIn) {
                  Navigator.pushNamed(context, '/practice');
                } else {
                  Navigator.pushNamed(context, '/auth');
                }
              },
              isTablet,
              theme,
            ),
            _buildActionCard(
              'Dictionary',
              Icons.translate,
              Colors.blue,
              () => Navigator.pushNamed(context, '/dictionary'),
              isTablet,
              theme,
            ),
            _buildActionCard(
              'Culture',
              Icons.public,
              Colors.purple,
              () => Navigator.pushNamed(context, '/culture'),
              isTablet,
              theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap, bool isTablet, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 32 : 24,
                  color: color,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent(bool isTablet, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Content',
          style: TextStyle(
            fontSize: isTablet ? 22 : 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        SizedBox(
          height: isTablet ? 200 : 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeatureCard(
                'Daily Conversations',
                'Learn everyday phrases and expressions',
                Icons.chat_bubble_outline,
                AppTheme.primaryOrange,
                isTablet,
                theme,
              ),
              SizedBox(width: isTablet ? 16 : 12),
              _buildFeatureCard(
                'Cultural Insights',
                'Discover Rwanda\'s rich heritage',
                Icons.museum,
                Colors.purple,
                isTablet,
                theme,
              ),
              SizedBox(width: isTablet ? 16 : 12),
              _buildFeatureCard(
                'Pronunciation Guide',
                'Perfect your Kinyarwanda accent',
                Icons.record_voice_over,
                AppTheme.primaryGreen,
                isTablet,
                theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color, bool isTablet, ThemeData theme) {
    return Container(
      width: isTablet ? 280 : 240,
      margin: EdgeInsets.only(right: isTablet ? 16 : 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 12 : 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                  child: Icon(
                    icon,
                    size: isTablet ? 24 : 20,
                    color: color,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonSection(String title, List<LessonModel> lessons, bool isTablet, ThemeData theme, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: isTablet ? 24 : 20,
              color: AppTheme.primaryOrange,
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 16 : 12),
        SizedBox(
          height: isTablet ? 140 : 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              return _buildLessonCard(lessons[index], isTablet, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(LessonModel lesson, bool isTablet, ThemeData theme) {
    return Container(
      width: isTablet ? 200 : 160,
      margin: EdgeInsets.only(right: isTablet ? 16 : 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnhancedLessonsScreen()),
          ),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 32 : 24,
                        height: isTablet ? 32 : 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        child: Center(
                          child: Text(
                            '${lesson.order}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 8 : 6),
                      Expanded(
                        child: Text(
                          lesson.title,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  Text(
                    lesson.description,
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: isTablet ? 14 : 12,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      SizedBox(width: isTablet ? 4 : 2),
                      Text(
                        '${lesson.estimatedDuration}min',
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppFeatures(bool isTablet, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Choose KinyaLearn?',
          style: TextStyle(
            fontSize: isTablet ? 22 : 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        _buildFeatureItem(
          'Interactive Lessons',
          'Engage with multimedia content designed for effective learning',
          Icons.play_circle_filled,
          isTablet,
          theme,
        ),
        _buildFeatureItem(
          'Cultural Context',
          'Learn not just the language, but Rwanda\'s rich cultural heritage',
          Icons.language,
          isTablet,
          theme,
        ),
        _buildFeatureItem(
          'Progress Tracking',
          'Monitor your learning journey with detailed analytics',
          Icons.trending_up,
          isTablet,
          theme,
        ),
        _buildFeatureItem(
          'Audio Pronunciation',
          'Perfect your accent with native speaker recordings',
          Icons.volume_up,
          isTablet,
          theme,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon, bool isTablet, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 8 : 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
            ),
            child: Icon(
              icon,
              size: isTablet ? 20 : 16,
              color: AppTheme.primaryOrange,
            ),
          ),
          SizedBox(width: isTablet ? 12 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: isTablet ? 4 : 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
