import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const Navigation(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 32 : 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [theme.colorScheme.background, theme.colorScheme.background]
                            : [AppTheme.primaryOrange, AppTheme.primaryOrange],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Name
                              Text(
                                'Aubertine BIHIBINDI',
                                style: TextStyle(
                                  fontSize: isTablet ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // User Level
                              Text(
                                'Intermediate Level • 45 day streak',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              // Edit Button
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 24 : 20,
                                    vertical: isTablet ? 12 : 10,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.edit, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile Avatar (moved to right)
                        Container(
                          width: isTablet ? 100 : 80,
                          height: isTablet ? 100 : 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            Icons.person,
                            size: isTablet ? 50 : 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats Row
                  Container(
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildStatCard(
                                '2,450',
                                'Total XP',
                                Icons.star_rounded,
                                const Color(0xFFFAD201),
                                isTablet, theme)),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                            child: _buildStatCard(
                                '23/45',
                                'Lessons',
                                Icons.book_rounded,
                                const Color(0xFF00A1DE),
                                isTablet, theme)),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                            child: _buildStatCard(
                                '87%',
                                'Accuracy',
                                Icons.check_circle_rounded,
                                const Color(0xFF00A651),
                                isTablet, theme)),
                      ],
                    ),
                  ),

                  // Menu Items
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isTablet ? 24 : 20),
                    child: Column(
                      children: [
                        _buildMenuItem('Learning Goals', Icons.flag_rounded,
                            () {}, isTablet, theme),
                        _buildMenuItem('Achievement Badges',
                            Icons.emoji_events_rounded, () {}, isTablet, theme),
                        _buildMenuItem('Learning Statistics',
                            Icons.bar_chart_rounded, () {}, isTablet, theme),
                        _buildMenuItem('Cultural Preferences',
                            Icons.language_rounded, () {}, isTablet, theme),
                        _buildMenuItem('Offline Downloads',
                            Icons.download_rounded, () {}, isTablet, theme),
                        _buildMenuItem('Notification Settings',
                            Icons.notifications_rounded, () {}, isTablet, theme),
                        _buildMenuItem('Privacy & Data', Icons.security_rounded,
                            () {}, isTablet, theme),
                        _buildMenuItem('Help & Support', Icons.help_rounded,
                            () {}, isTablet, theme),
                        _buildMenuItem('About KinyaLearn', Icons.info_rounded,
                            () {}, isTablet, theme),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 32 : 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color, bool isTablet, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 24 : 20),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color ?? Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              color: theme.textTheme.bodyMedium?.color ?? Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      String title, IconData icon, VoidCallback onTap, bool isTablet, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 40 : 36,
                height: isTablet ? 40 : 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryOrange,
                  size: isTablet ? 20 : 18,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color ?? Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: isTablet ? 16 : 14,
                color: theme.textTheme.bodySmall?.color ?? Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
