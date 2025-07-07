import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';
import '../data/kinyarwanda_lessons.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const Navigation(),
          // Cultural Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        theme.colorScheme.surface,
                        theme.colorScheme.surface
                      ]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Rwandan Culture & Heritage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.language,
                    color: Colors.white, size: isTablet ? 36 : 32),
              ],
            ),
          ),
          // Cultural Content Sections
          Expanded(
            child: isDesktop
                ? _buildDesktopGrid(isTablet, context)
                : _buildMobileList(isTablet, context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid(bool isTablet, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
        children: [
          _buildCultureCard(
            'Traditional Proverbs',
            'Imigani n\'Amazina',
            'Learn wisdom through traditional Rwandan sayings',
            Icons.format_quote,
            AppTheme.primaryOrange,
            onTap: () => Navigator.pushNamed(
              context,
              '/lesson-detail',
              arguments: KinyarwandaLessons.getLessons()
                  .firstWhere((lesson) => lesson.id == 'traditional-proverbs'),
            ),
            isTablet: true,
          ),
          _buildCultureCard(
            'Folktales & Stories',
            'Ibitekerezo n\'Imigani',
            'Discover ancient stories and their meanings',
            Icons.menu_book,
            const Color(0xFF00A1DE),
            isTablet: true,
          ),
          _buildCultureCard(
            'Traditional Celebrations',
            'Ibyishimo by\'Igihugu',
            'Understand Rwandan festivals and ceremonies',
            Icons.celebration,
            const Color(0xFF00A651),
            isTablet: true,
          ),
          _buildCultureCard(
            'Cultural Etiquette',
            'Ubwiyunge bw\'Umuco',
            'Learn respectful behavior and social customs',
            Icons.handshake,
            const Color(0xFFFAD201),
            isTablet: true,
          ),
          _buildCultureCard(
            'Historical Context',
            'Amateka y\'u Rwanda',
            'Understand Rwanda\'s rich history and heritage',
            Icons.account_balance,
            AppTheme.primaryOrange,
            isTablet: true,
          ),
          _buildCultureCard(
            'Modern Rwanda',
            'U Rwanda rw\'iki gihe',
            'Contemporary culture and social dynamics',
            Icons.location_city,
            const Color(0xFF00A1DE),
            isTablet: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(bool isTablet, BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      children: [
        _buildCultureCard(
          'Traditional Proverbs',
          'Imigani n\'Amazina',
          'Learn wisdom through traditional Rwandan sayings',
          Icons.format_quote,
          AppTheme.primaryOrange,
          onTap: () => Navigator.pushNamed(
            context,
            '/lesson-detail',
            arguments: KinyarwandaLessons.getLessons()
                .firstWhere((lesson) => lesson.id == 'traditional-proverbs'),
          ),
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Folktales & Stories',
          'Ibitekerezo n\'Imigani',
          'Discover ancient stories and their meanings',
          Icons.menu_book,
          const Color(0xFF00A1DE),
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Traditional Celebrations',
          'Ibyishimo by\'Igihugu',
          'Understand Rwandan festivals and ceremonies',
          Icons.celebration,
          const Color(0xFF00A651),
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Cultural Etiquette',
          'Ubwiyunge bw\'Umuco',
          'Learn respectful behavior and social customs',
          Icons.handshake,
          const Color(0xFFFAD201),
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Historical Context',
          'Amateka y\'u Rwanda',
          'Understand Rwanda\'s rich history and heritage',
          Icons.account_balance,
          AppTheme.primaryOrange,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Modern Rwanda',
          'U Rwanda rw\'iki gihe',
          'Contemporary culture and social dynamics',
          Icons.location_city,
          const Color(0xFF00A1DE),
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildCultureCard(String title, String kinyarwandaTitle,
      String description, IconData icon, Color color,
      {bool isTablet = false, VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Card(
        elevation: isTablet ? 6 : 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
        child: InkWell(
          onTap: onTap ??
              () {
                // Navigate to specific cultural content
              },
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 70 : 60,
                  height: isTablet ? 70 : 60,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isTablet ? 35 : 30,
                  ),
                ),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        kinyarwandaTitle,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontStyle: FontStyle.italic,
                          color: color,
                        ),
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: isTablet ? 20 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}