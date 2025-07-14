import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../data/culture_lessons.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = CultureLessons.getLessons();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 60 : (isTablet ? 40 : 24),
              vertical: isDesktop ? 40 : (isTablet ? 32 : 24),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
                      child: Text(
                        'Rwandan Culture & Heritage',
                        style: TextStyle(
                          fontSize: isDesktop ? 32 : (isTablet ? 28 : 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.language,
                      color: Colors.white,
                      size: isDesktop ? 40 : (isTablet ? 36 : 32),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Explore Rwandan culture, traditions, and history',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // Culture Lessons Grid
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                  crossAxisSpacing: isDesktop ? 16 : (isTablet ? 14 : 12),
                  mainAxisSpacing: isDesktop ? 16 : (isTablet ? 14 : 12),
                  childAspectRatio: isDesktop ? 0.85 : (isTablet ? 0.8 : 0.9),
                ),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _buildLessonCard(context, lesson, isTablet, isDark);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildLessonCard(BuildContext context, lesson, bool isTablet, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/lesson-detail',
          arguments: lesson,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header with enhanced preview
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getLessonColor(lesson.id),
                    _getLessonColor(lesson.id).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CulturePatternPainter(Colors.white),
                    ),
                  ),
                  
                  // Main content
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 8 : 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getLessonIcon(lesson.id),
                          color: Colors.white,
                          size: isTablet ? 20 : 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lesson ${lesson.order}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: isTablet ? 10 : 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lesson.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getCulturePreviewText(lesson.id),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lesson Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.description,
                      style: TextStyle(
                        color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.grey[700],
                        fontSize: isTablet ? 11 : 10,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppTheme.primaryOrange,
                          size: isTablet ? 16 : 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Watch & Learn',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: isTablet ? 11 : 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey[400],
                          size: isTablet ? 12 : 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLessonColor(String lessonId) {
    switch (lessonId) {
      case 'proverbs':
        return AppTheme.primaryOrange;
      case 'story_telling':
        return const Color(0xFF00A1DE);
      case 'traditional_celebrations':
        return const Color(0xFF00A651);
      case 'culture_etiquette':
        return const Color(0xFFFAD201);
      case 'rwanda_history':
        return const Color(0xFF8B5CF6);
      case 'modern_rwanda':
        return const Color(0xFF06B6D4);
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getLessonIcon(String lessonId) {
    switch (lessonId) {
      case 'proverbs':
        return Icons.format_quote;
      case 'story_telling':
        return Icons.menu_book;
      case 'traditional_celebrations':
        return Icons.celebration;
      case 'culture_etiquette':
        return Icons.handshake;
      case 'rwanda_history':
        return Icons.account_balance;
      case 'modern_rwanda':
        return Icons.location_city;
      default:
        return Icons.school;
    }
  }

  String _getCulturePreviewText(String lessonId) {
    switch (lessonId) {
      case 'proverbs':
        return 'Ubwoba bukabije...';
      case 'story_telling':
        return 'Gasakara...';
      case 'traditional_celebrations':
        return 'Kwita Izina';
      case 'culture_etiquette':
        return 'Ubushake';
      case 'rwanda_history':
        return '1962';
      case 'modern_rwanda':
        return 'Vision 2050';
      default:
        return 'Culture';
    }
  }
}

// Custom painter for culture lesson background patterns
class _CulturePatternPainter extends CustomPainter {
  final Color color;

  _CulturePatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw a pattern of cultural symbols
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw diamond pattern
    final path = Path();
    path.moveTo(centerX, centerY - 20);
    path.lineTo(centerX + 20, centerY);
    path.lineTo(centerX, centerY + 20);
    path.lineTo(centerX - 20, centerY);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw small cultural dots around
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    final positions = [
      Offset(centerX - 30, centerY - 10),
      Offset(centerX + 30, centerY - 10),
      Offset(centerX - 30, centerY + 10),
      Offset(centerX + 30, centerY + 10),
    ];
    
    for (final pos in positions) {
      canvas.drawCircle(pos, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
