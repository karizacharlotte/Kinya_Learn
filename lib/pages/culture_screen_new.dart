import 'package:flutter/material.dart';
import '../components/navigation.dart';
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
          const Navigation(),
          
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
                  crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                  crossAxisSpacing: isDesktop ? 24 : (isTablet ? 20 : 16),
                  mainAxisSpacing: isDesktop ? 24 : (isTablet ? 20 : 16),
                  childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.1 : 1.3),
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
            // Lesson Header
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
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
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getLessonIcon(lesson.id),
                      color: Colors.white,
                      size: isTablet ? 32 : 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson ${lesson.order}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Lesson Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.description,
                      style: TextStyle(
                        color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.grey[700],
                        fontSize: isTablet ? 16 : 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppTheme.primaryOrange,
                          size: isTablet ? 24 : 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Watch & Learn',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey[400],
                          size: isTablet ? 20 : 16,
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
}
