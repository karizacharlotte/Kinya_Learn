import 'package:flutter/material.dart';
import '../components/navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          // Profile Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 50 : 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: isTablet ? 50 : 40, color: const Color(0xFF8B5CF6)),
                ),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sarah Mukamana',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Intermediate Level • 45 day streak',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit,
                      color: Colors.white, size: isTablet ? 28 : 24),
                ),
              ],
            ),
          ),
          // Stats Cards
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: orientation == Orientation.landscape && !isDesktop
                ? Row(
                    children: [
                      Expanded(
                          child: _buildStatCard('Total XP', '2,450', Icons.star,
                              const Color(0xFFF59E0B), isTablet)),
                      SizedBox(width: isTablet ? 20 : 16),
                      Expanded(
                          child: _buildStatCard('Lessons', '23/45', Icons.book,
                              const Color(0xFF4F46E5), isTablet)),
                      SizedBox(width: isTablet ? 20 : 16),
                      Expanded(
                          child: _buildStatCard(
                              'Accuracy',
                              '87%',
                              Icons.check_circle,
                              const Color(0xFF059669),
                              isTablet)),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: _buildStatCard(
                                  'Total XP',
                                  '2,450',
                                  Icons.star,
                                  const Color(0xFFF59E0B),
                                  isTablet)),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                              child: _buildStatCard(
                                  'Lessons',
                                  '23/45',
                                  Icons.book,
                                  const Color(0xFF4F46E5),
                                  isTablet)),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                              child: _buildStatCard(
                                  'Accuracy',
                                  '87%',
                                  Icons.check_circle,
                                  const Color(0xFF059669),
                                  isTablet)),
                        ],
                      ),
                    ],
                  ),
          ),
          // Profile Sections
          Expanded(
            child: isDesktop
                ? _buildDesktopProfileSections(isTablet)
                : _buildMobileProfileSections(isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProfileSections(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        childAspectRatio: 6,
        children: [
          _buildProfileSection('Learning Goals', Icons.flag, () {}, isTablet),
          _buildProfileSection(
              'Achievement Badges', Icons.emoji_events, () {}, isTablet),
          _buildProfileSection(
              'Learning Statistics', Icons.analytics, () {}, isTablet),
          _buildProfileSection(
              'Cultural Preferences', Icons.language, () {}, isTablet),
          _buildProfileSection(
              'Offline Downloads', Icons.download, () {}, isTablet),
          _buildProfileSection(
              'Notification Settings', Icons.notifications, () {}, isTablet),
          _buildProfileSection(
              'Privacy & Data', Icons.privacy_tip, () {}, isTablet),
          _buildProfileSection('Help & Support', Icons.help, () {}, isTablet),
        ],
      ),
    );
  }

  Widget _buildMobileProfileSections(bool isTablet) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      children: [
        _buildProfileSection('Learning Goals', Icons.flag, () {}, isTablet),
        _buildProfileSection(
            'Achievement Badges', Icons.emoji_events, () {}, isTablet),
        _buildProfileSection(
            'Learning Statistics', Icons.analytics, () {}, isTablet),
        _buildProfileSection(
            'Cultural Preferences', Icons.language, () {}, isTablet),
        _buildProfileSection(
            'Offline Downloads', Icons.download, () {}, isTablet),
        _buildProfileSection(
            'Notification Settings', Icons.notifications, () {}, isTablet),
        _buildProfileSection(
            'Privacy & Data', Icons.privacy_tip, () {}, isTablet),
        _buildProfileSection('Help & Support', Icons.help, () {}, isTablet),
        _buildProfileSection('About KinyaLearn', Icons.info, () {}, isTablet),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: isTablet ? 28 : 24),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
      String title, IconData icon, VoidCallback onTap, bool isTablet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 8 : 4,
        ),
        leading: Icon(icon,
            color: const Color(0xFF4F46E5), size: isTablet ? 28 : 24),
        title: Text(
          title,
          style: TextStyle(fontSize: isTablet ? 18 : 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: isTablet ? 20 : 16),
        onTap: onTap,
      ),
    );
  }
}
