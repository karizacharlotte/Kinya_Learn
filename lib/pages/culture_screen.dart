import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class CultureScreen extends StatelessWidget {
  const CultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          const Navigation(),
          // Cultural Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppTheme.secondaryGradient,
            ),
            child: const Row(
              children: [
                Icon(Icons.language, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Text(
                  'Rwandan Culture & Heritage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Cultural Content Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCultureCard(
                  'Traditional Proverbs',
                  'Imigani n\'Amazina',
                  'Learn wisdom through traditional Rwandan sayings',
                  Icons.format_quote,
                  AppTheme.primaryBlue,
                ),
                _buildCultureCard(
                  'Folktales & Stories',
                  'Ibitekerezo n\'Imigani',
                  'Discover ancient stories and their meanings',
                  Icons.menu_book,
                  AppTheme.primaryGreen,
                ),
                _buildCultureCard(
                  'Traditional Celebrations',
                  'Ibyishimo by\'Igihugu',
                  'Understand Rwandan festivals and ceremonies',
                  Icons.celebration,
                  AppTheme.accentPurple,
                ),
                _buildCultureCard(
                  'Cultural Etiquette',
                  'Ubwiyunge bw\'Umuco',
                  'Learn respectful behavior and social customs',
                  Icons.handshake,
                  AppTheme.warmOrange,
                ),
                _buildCultureCard(
                  'Historical Context',
                  'Amateka y\'u Rwanda',
                  'Understand Rwanda\'s rich history and heritage',
                  Icons.account_balance,
                  AppTheme.softPink,
                ),
                _buildCultureCard(
                  'Modern Rwanda',
                  'U Rwanda rw\'iki gihe',
                  'Contemporary culture and social dynamics',
                  Icons.location_city,
                  AppTheme.accentTeal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCultureCard(String title, String kinyarwandaTitle, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // Navigate to specific cultural content
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        kinyarwandaTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
