import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
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
                      children: [
                        // Profile Avatar
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
                        SizedBox(height: isTablet ? 16 : 12),
                        // User Name
                        Text(
                          'Aubert BIHIBINDI',
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
                            side:
                                const BorderSide(color: Colors.white, width: 2),
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
                                isTablet)),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                            child: _buildStatCard(
                                '23/45',
                                'Lessons',
                                Icons.book_rounded,
                                const Color(0xFF00A1DE),
                                isTablet)),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                            child: _buildStatCard(
                                '87%',
                                'Accuracy',
                                Icons.check_circle_rounded,
                                const Color(0xFF00A651),
                                isTablet)),
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
                            () {}, isTablet),
                        _buildMenuItem('Achievement Badges',
                            Icons.emoji_events_rounded, () {}, isTablet),
                        _buildMenuItem('Learning Statistics',
                            Icons.bar_chart_rounded, () {}, isTablet),
                        _buildMenuItem('Cultural Preferences',
                            Icons.language_rounded, () {}, isTablet),
                        _buildMenuItem('Offline Downloads',
                            Icons.download_rounded, () {}, isTablet),
                        _buildMenuItem('Notification Settings',
                            Icons.notifications_rounded, () {}, isTablet),
                        _buildMenuItem('Privacy & Data', Icons.security_rounded,
                            () {}, isTablet),
                        _buildMenuItem('Help & Support', Icons.help_rounded,
                            () {}, isTablet),
                        _buildMenuItem('About KinyaLearn', Icons.info_rounded,
                            () {}, isTablet),
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
      String value, String label, IconData icon, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
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
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      String title, IconData icon, VoidCallback onTap, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 14),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 40 : 36,
                height: isTablet ? 40 : 36,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 78, 42, 147).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 78, 42, 147),
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
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: isTablet ? 16 : 14,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
