import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/app_theme.dart';
import '../data/culture_lessons.dart';
import '../utils/responsive_helper.dart';
import '../utils/responsive_layout.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = CultureLessons.getLessons();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
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
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ResponsiveText(
                          'Rwandan Culture & Heritage',
                          type: ResponsiveTextType.header,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.language,
                        color: Colors.white,
                        size: ResponsiveHelper.getResponsiveIconSize(context) * 1.5,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                  ResponsiveText(
                    'Explore Rwandan culture, traditions, and history',
                    type: ResponsiveTextType.body,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
          ),
          
          // Culture Lessons Grid
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: ResponsiveGrid(
                mobileColumns: 2,
                tabletColumns: 3,
                desktopColumns: 4,
                spacing: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16),
                runSpacing: ResponsiveHelper.getResponsiveSpacing(context, small: 12, medium: 14, large: 16),
                childAspectRatio: ResponsiveHelper.getResponsiveValue(context, mobile: 0.9, tablet: 0.8, desktop: 0.85),
                children: lessons.map((lesson) => _buildLessonCard(context, lesson, isDark)).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildLessonCard(BuildContext context, lesson, bool isDark) {
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
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withValues(alpha: 0.2),
              blurRadius: ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 10, desktop: 12),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header with enhanced preview
            Container(
              padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                top: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
                bottom: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getLessonColor(lesson.id),
                    _getLessonColor(lesson.id).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
                  topRight: Radius.circular(ResponsiveHelper.isDesktop(context) ? 16 : 12),
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
                        padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 8, desktop: 10)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 9, desktop: 10)),
                        ),
                        child: Icon(
                          _getLessonIcon(lesson.id),
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveValue(context, mobile: 16, tablet: 20, desktop: 24),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveText(
                              'Lesson ${lesson.order}',
                              type: ResponsiveTextType.body,
                              customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 9, tablet: 10, desktop: 11),
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 2, medium: 3, large: 4)),
                            ResponsiveText(
                              lesson.title,
                              type: ResponsiveTextType.body,
                              customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 12, tablet: 14, desktop: 16),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, small: 2, medium: 3, large: 4)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 7, desktop: 8),
                                vertical: ResponsiveHelper.getResponsiveValue(context, mobile: 1, tablet: 2, desktop: 3)
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(context, mobile: 6, tablet: 7, desktop: 8)),
                              ),
                              child: ResponsiveText(
                                _getCulturePreviewText(lesson.id),
                                type: ResponsiveTextType.body,
                                customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 8, tablet: 9, desktop: 10),
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
                padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                  top: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
                  bottom: ResponsiveHelper.getResponsiveSpacing(context, small: 8, medium: 10, large: 12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      lesson.description,
                      type: ResponsiveTextType.body,
                      customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 11, desktop: 12),
                      color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.grey[700],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppTheme.primaryOrange,
                          size: ResponsiveHelper.getResponsiveValue(context, mobile: 14, tablet: 16, desktop: 18),
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, small: 4, medium: 5, large: 6)),
                        ResponsiveText(
                          'Watch & Learn',
                          type: ResponsiveTextType.body,
                          customFontSize: ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 11, desktop: 12),
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey[400],
                          size: ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 12, desktop: 14),
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
