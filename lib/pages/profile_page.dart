import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../components/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User statistics
  int totalXP = 2450;
  int completedLessons = 23;
  int totalLessons = 45;
  double accuracy = 87.0;
  
  // User preferences
  bool notificationsEnabled = true;
  bool offlineDownloadsEnabled = false;
  String selectedLanguage = 'English';
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalXP = prefs.getInt('totalXP') ?? 2450;
      completedLessons = prefs.getInt('completedLessons') ?? 23;
      accuracy = prefs.getDouble('accuracy') ?? 87.0;
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      offlineDownloadsEnabled = prefs.getBool('offlineDownloadsEnabled') ?? false;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalXP', totalXP);
    await prefs.setInt('completedLessons', completedLessons);
    await prefs.setDouble('accuracy', accuracy);
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setBool('offlineDownloadsEnabled', offlineDownloadsEnabled);
    await prefs.setString('selectedLanguage', selectedLanguage);
    await prefs.setBool('darkModeEnabled', darkModeEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
        foregroundColor: isDark ? Colors.white : AppTheme.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            _buildStatisticsSection(isDark),
            
            const SizedBox(height: 24),
            
            // Profile Options
            _buildProfileOptions(isDark),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildStatisticsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Statistics Cards Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.star,
                iconColor: Colors.amber,
                value: totalXP.toString(),
                label: 'Total XP',
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.book,
                iconColor: Colors.blue,
                value: '$completedLessons/$totalLessons',
                label: 'Lessons',
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                value: '${accuracy.toInt()}%',
                label: 'Accuracy',
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(bool isDark) {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.flag,
          title: 'Learning Goals',
          subtitle: 'Set your daily learning targets',
          onTap: () => _showLearningGoalsDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.military_tech,
          title: 'Achievement Badges',
          subtitle: 'View your earned badges',
          onTap: () => _showAchievementsDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.notes,
          title: 'Learning Notes & Goals',
          subtitle: 'Manage your notes and learning goals',
          onTap: () => Navigator.pushNamed(context, '/learning-notes'),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.bar_chart,
          title: 'Learning Statistics',
          subtitle: 'Detailed progress analytics',
          onTap: () => _showStatisticsDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.language,
          title: 'Cultural Preferences',
          subtitle: 'Customize cultural content',
          onTap: () => _showCulturalPreferencesDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.download,
          title: 'Offline Downloads',
          subtitle: offlineDownloadsEnabled ? 'Enabled' : 'Disabled',
          onTap: () => _showOfflineDownloadsDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.notifications,
          title: 'Notification Settings',
          subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
          onTap: () => _showNotificationSettingsDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.privacy_tip,
          title: 'Privacy & Data',
          subtitle: 'Manage your privacy settings',
          onTap: () => _showPrivacyDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () => _showHelpDialog(),
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.info,
          title: 'About KinyaLearn',
          subtitle: 'App information and credits',
          onTap: () => _showAboutDialog(),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLearningGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Learning Goals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Daily XP Goal'),
              subtitle: const Text('100 XP per day'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Weekly Lessons'),
              subtitle: const Text('5 lessons per week'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Monthly Challenge'),
              subtitle: const Text('Complete 20 lessons'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAchievementsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Achievement Badges'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final badges = [
                {'icon': Icons.star, 'name': 'First Star', 'earned': true},
                {'icon': Icons.fire_extinguisher, 'name': 'Hot Streak', 'earned': true},
                {'icon': Icons.school, 'name': 'Scholar', 'earned': false},
                {'icon': Icons.speed, 'name': 'Speed Demon', 'earned': true},
                {'icon': Icons.favorite, 'name': 'Culture Lover', 'earned': false},
                {'icon': Icons.diamond, 'name': 'Diamond League', 'earned': false},
              ];
              
              final badge = badges[index];
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badge['earned'] as bool ? Colors.amber.shade100 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: badge['earned'] as bool ? Colors.amber : Colors.grey,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      badge['icon'] as IconData,
                      color: badge['earned'] as bool ? Colors.amber.shade700 : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge['name'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: badge['earned'] as bool ? Colors.amber.shade700 : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Learning Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Total Study Time', '47 hours'),
            _buildStatRow('Longest Streak', '12 days'),
            _buildStatRow('Average Session', '15 minutes'),
            _buildStatRow('Favorite Topic', 'Greetings'),
            _buildStatRow('Words Learned', '234 words'),
            _buildStatRow('Pronunciation Score', '92%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showCulturalPreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cultural Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Traditional Stories'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Modern Culture'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Historical Context'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Food & Cooking'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showOfflineDownloadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Downloads'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Enable Offline Downloads'),
              subtitle: const Text('Download lessons for offline use'),
              value: offlineDownloadsEnabled,
              onChanged: (value) {
                setState(() {
                  offlineDownloadsEnabled = value;
                });
                _saveUserData();
              },
            ),
            if (offlineDownloadsEnabled) ...[
              const Divider(),
              ListTile(
                title: const Text('Download Quality'),
                subtitle: const Text('High Quality'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Storage Used'),
                subtitle: const Text('156 MB'),
                trailing: const Icon(Icons.storage),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Get reminded to practice daily'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveUserData();
              },
            ),
            SwitchListTile(
              title: const Text('Streak Notifications'),
              subtitle: const Text('Celebrate your learning streaks'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Achievement Alerts'),
              subtitle: const Text('Get notified about new badges'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Data Usage'),
              subtitle: const Text('See how your data is used'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Export Data'),
              subtitle: const Text('Download your learning data'),
              trailing: const Icon(Icons.download),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Delete Account'),
              subtitle: const Text('Permanently delete your account'),
              trailing: const Icon(Icons.delete, color: Colors.red),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('FAQ'),
              subtitle: const Text('Frequently asked questions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Contact Support'),
              subtitle: const Text('Get help from our team'),
              trailing: const Icon(Icons.email),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Report a Bug'),
              subtitle: const Text('Help us improve the app'),
              trailing: const Icon(Icons.bug_report),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Rate the App'),
              subtitle: const Text('Share your feedback'),
              trailing: const Icon(Icons.star),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About KinyaLearn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KinyaLearn v1.0.0',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Learn Kinyarwanda through interactive lessons, cultural insights, and practice exercises.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Developed with ❤️ for language learners worldwide.',
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 KinyaLearn. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
