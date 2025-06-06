import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1200;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          const Navigation(),
          // Cultural Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: const BoxDecoration(
              gradient: AppTheme.successGradient,
            ),
            child: Row(
              children: [
                Icon(Icons.language,
                    color: Colors.white, size: isTablet ? 36 : 32),
                SizedBox(width: isTablet ? 20 : 16),
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
              ],
            ),
          ),
          // Cultural Content Sections
          Expanded(
            child: isDesktop
                ? _buildDesktopGrid(isTablet)
                : _buildMobileList(isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid(bool isTablet) {
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
            AppTheme.primaryBlue,
            isTablet: true,
          ),
          _buildCultureCard(
            'Folktales & Stories',
            'Ibitekerezo n\'Imigani',
            'Discover ancient stories and their meanings',
            Icons.menu_book,
            AppTheme.primaryGreen,
            isTablet: true,
          ),
          _buildCultureCard(
            'Traditional Celebrations',
            'Ibyishimo by\'Igihugu',
            'Understand Rwandan festivals and ceremonies',
            Icons.celebration,
            AppTheme.primaryPurple,
            isTablet: true,
          ),
          _buildCultureCard(
            'Cultural Etiquette',
            'Ubwiyunge bw\'Umuco',
            'Learn respectful behavior and social customs',
            Icons.handshake,
            AppTheme.primaryOrange,
            isTablet: true,
          ),
          _buildCultureCard(
            'Historical Context',
            'Amateka y\'u Rwanda',
            'Understand Rwanda\'s rich history and heritage',
            Icons.account_balance,
            AppTheme.primaryRed,
            isTablet: true,
          ),
          _buildCultureCard(
            'Modern Rwanda',
            'U Rwanda rw\'iki gihe',
            'Contemporary culture and social dynamics',
            Icons.location_city,
            AppTheme.primaryTeal,
            isTablet: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(bool isTablet) {
    return ListView(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      children: [
        _buildCultureCard(
          'Traditional Proverbs',
          'Imigani n\'Amazina',
          'Learn wisdom through traditional Rwandan sayings',
          Icons.format_quote,
          AppTheme.primaryBlue,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Folktales & Stories',
          'Ibitekerezo n\'Imigani',
          'Discover ancient stories and their meanings',
          Icons.menu_book,
          AppTheme.primaryGreen,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Traditional Celebrations',
          'Ibyishimo by\'Igihugu',
          'Understand Rwandan festivals and ceremonies',
          Icons.celebration,
          AppTheme.primaryPurple,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Cultural Etiquette',
          'Ubwiyunge bw\'Umuco',
          'Learn respectful behavior and social customs',
          Icons.handshake,
          AppTheme.primaryOrange,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Historical Context',
          'Amateka y\'u Rwanda',
          'Understand Rwanda\'s rich history and heritage',
          Icons.account_balance,
          AppTheme.primaryRed,
          isTablet: isTablet,
        ),
        _buildCultureCard(
          'Modern Rwanda',
          'U Rwanda rw\'iki gihe',
          'Contemporary culture and social dynamics',
          Icons.location_city,
          AppTheme.primaryTeal,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildCultureCard(String title, String kinyarwandaTitle,
      String description, IconData icon, Color color,
      {bool isTablet = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Card(
        elevation: isTablet ? 6 : 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12)),
        child: InkWell(
          onTap: () {
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
