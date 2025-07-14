import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../components/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _offlineDownloadsEnabled = false;
  double _textScale = 1.0;
  String _selectedLanguage = 'English';
  int _dailyGoalMinutes = 15;
  String _culturalPreference = 'General';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _offlineDownloadsEnabled = prefs.getBool('offline_downloads_enabled') ?? false;
      _textScale = prefs.getDouble('text_scale') ?? 1.0;
      _selectedLanguage = prefs.getString('selected_language') ?? 'English';
      _dailyGoalMinutes = prefs.getInt('daily_goal_minutes') ?? 15;
      _culturalPreference = prefs.getString('cultural_preference') ?? 'General';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('offline_downloads_enabled', _offlineDownloadsEnabled);
    await prefs.setDouble('text_scale', _textScale);
    await prefs.setString('selected_language', _selectedLanguage);
    await prefs.setInt('daily_goal_minutes', _dailyGoalMinutes);
    await prefs.setString('cultural_preference', _culturalPreference);
  }

  double get screenWidth => MediaQuery.of(context).size.width;
  double get headerHeight => screenWidth > 700 ? 200 : 160;
  bool get isTablet => screenWidth > 600;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Navigation Drawer/Menu (permanent on wide screens, modal on mobile)
                if (screenWidth > 700)
                  Container(
                    width: 120,
                    color: Theme.of(context).cardColor,
                    child: SideNavigation(
                      selected: 'Settings',
                      onNavigate: (route) {
                        if (route != '/settings') {
                          Navigator.pushReplacementNamed(context, route);
                        }
                      },
                    ),
                  ),
                Expanded(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero/Header Section (like lessons page)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: headerHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isDarkMode
                                      ? [
                                          Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          Theme.of(context)
                                              .colorScheme
                                              .surface
                                        ]
                                      : [
                                          AppTheme.primaryOrange,
                                          AppTheme.primaryOrange
                                        ],
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  left: isTablet ? 40 : 20,
                                  right: isTablet ? 40 : 20,
                                  top: isTablet ? 36 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Settings',
                                        style: TextStyle(
                                          fontSize: isTablet ? 32 : 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Manage your preferences and account',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 15,
                                      color: Colors.white.withValues(alpha: 0.95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Settings Options below header
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 40 : 20,
                                  vertical: isTablet ? 32 : 20),
                              child: Column(
                                children: [
                                  // Learning Goals
                                  _buildSettingsTile(
                                    icon: Icons.flag_outlined,
                                    title: 'Learning Goals',
                                    subtitle: 'Set your daily learning targets',
                                    trailing: Text('$_dailyGoalMinutes min/day'),
                                    onTap: () => _showLearningGoalsDialog(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Achievement Badges
                                  _buildSettingsTile(
                                    icon: Icons.emoji_events_outlined,
                                    title: 'Achievement Badges',
                                    subtitle: 'View your earned badges',
                                    onTap: () => _showAchievementBadges(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Learning Statistics
                                  _buildSettingsTile(
                                    icon: Icons.bar_chart,
                                    title: 'Learning Statistics',
                                    subtitle: 'Detailed progress analytics',
                                    onTap: () => _showLearningStatistics(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Cultural Preferences
                                  _buildSettingsTile(
                                    icon: Icons.public,
                                    title: 'Cultural Preferences',
                                    subtitle: 'Customize cultural content',
                                    trailing: Text(_culturalPreference),
                                    onTap: () => _showCulturalPreferencesDialog(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Offline Downloads
                                  _buildSwitchTile(
                                    icon: Icons.download_outlined,
                                    title: 'Offline Downloads',
                                    subtitle: _offlineDownloadsEnabled ? 'Enabled' : 'Disabled',
                                    value: _offlineDownloadsEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        _offlineDownloadsEnabled = value;
                                      });
                                      _saveSettings();
                                      if (value) {
                                        _showOfflineDownloadDialog();
                                      }
                                    },
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Notification Settings
                                  _buildSwitchTile(
                                    icon: Icons.notifications_outlined,
                                    title: 'Notification Settings',
                                    subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
                                    value: _notificationsEnabled,
                                    onChanged: (value) {
                                      setState(() {
                                        _notificationsEnabled = value;
                                      });
                                      _saveSettings();
                                    },
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Privacy & Data
                                  _buildSettingsTile(
                                    icon: Icons.privacy_tip_outlined,
                                    title: 'Privacy & Data',
                                    subtitle: 'Manage your privacy settings',
                                    onTap: () => _showPrivacyDataDialog(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // Help & Support
                                  _buildSettingsTile(
                                    icon: Icons.help_outline,
                                    title: 'Help & Support',
                                    subtitle: 'Get help and contact support',
                                    onTap: () => _showHelpSupportDialog(),
                                  ),
                                  
                                  const Divider(height: 1),
                                  
                                  // About KinyaLearn
                                  _buildSettingsTile(
                                    icon: Icons.info_outline,
                                    title: 'About KinyaLearn',
                                    subtitle: 'App information and credits',
                                    onTap: () => _showAboutDialog(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 5),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, 
        color: Theme.of(context).iconTheme.color),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryOrange,
      ),
    );
  }

  void _showLearningGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Learning Goals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Daily study time goal:'),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: _dailyGoalMinutes,
              items: [5, 10, 15, 20, 30, 45, 60].map((minutes) {
                return DropdownMenuItem(
                  value: minutes,
                  child: Text('$minutes minutes'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _dailyGoalMinutes = value ?? 15;
                });
                _saveSettings();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAchievementBadges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Achievement Badges'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBadge('🏆', 'First Lesson', 'Complete your first lesson', true),
              _buildBadge('🔥', '7-Day Streak', 'Study for 7 days in a row', false),
              _buildBadge('🎯', 'Perfect Score', 'Get 100% on a quiz', true),
              _buildBadge('📚', 'Bookworm', 'Complete 10 lessons', false),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String emoji, String title, String description, bool earned) {
    return ListTile(
      leading: Text(emoji, style: TextStyle(fontSize: 24)),
      title: Text(title, style: TextStyle(
        fontWeight: FontWeight.bold,
        color: earned ? AppTheme.primaryOrange : Colors.grey,
      )),
      subtitle: Text(description),
      trailing: earned ? Icon(Icons.check_circle, color: Colors.green) : 
                         Icon(Icons.lock, color: Colors.grey),
    );
  }

  void _showLearningStatistics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Learning Statistics'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatItem('Total Study Time', '2h 45m'),
              _buildStatItem('Lessons Completed', '12'),
              _buildStatItem('Current Streak', '3 days'),
              _buildStatItem('Average Score', '85%'),
              _buildStatItem('Words Learned', '47'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryOrange,
          )),
        ],
      ),
    );
  }

  void _showCulturalPreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cultural Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose your cultural learning focus:'),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _culturalPreference,
              isExpanded: true,
              items: ['General', 'Traditional', 'Modern', 'Business'].map((pref) {
                return DropdownMenuItem(
                  value: pref,
                  child: Text(pref),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _culturalPreference = value ?? 'General';
                });
                _saveSettings();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOfflineDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offline Downloads'),
        content: Text('Download lessons for offline study. This will use device storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Start download process
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting offline downloads...')),
              );
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy & Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• We collect minimal data to improve your learning experience'),
            SizedBox(height: 8),
            Text('• Your progress is stored locally and synced securely'),
            SizedBox(height: 8),
            Text('• You can delete your data at any time'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Clear user data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User data cleared')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Clear My Data'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to FAQ
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact Support'),
              onTap: () {
                Navigator.pop(context);
                // Open email
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Report Bug'),
              onTap: () {
                Navigator.pop(context);
                // Open bug report
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About KinyaLearn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('KinyaLearn v1.0.0'),
            SizedBox(height: 8),
            Text('Learn Kinyarwanda with authentic African voices'),
            SizedBox(height: 16),
            Text('Developed with ❤️ for language learners'),
            SizedBox(height: 16),
            Text('© 2025 KinyaLearn Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Log Out',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to log out? You will need to sign in again to access your account.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Clear any user session data here if you have any
    // For example: SharedPreferences, secure storage, etc.

    // Navigate to auth choice screen and clear the navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/auth-choice',
      (Route<dynamic> route) => false,
    );

    // Optional: Show a brief message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Successfully logged out'),
        backgroundColor: AppTheme.primaryOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Follow System'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResetThemeDialog(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme Choice'),
        content: const Text(
          'This will reset your theme preference and ask you to choose again next time you restart the app. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              themeProvider.resetToFirstTime();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Theme preference reset. You\'ll be asked to choose again on next app start.'),
                  backgroundColor: AppTheme.primaryOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// Side navigation widget for settings screen
class SideNavigation extends StatelessWidget {
  final String selected;
  final void Function(String route)? onNavigate;
  const SideNavigation({required this.selected, this.onNavigate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.home, 'label': 'Home', 'route': '/home'},
      {'icon': Icons.menu_book, 'label': 'Lessons', 'route': '/lessons'},
      {'icon': Icons.sports_kabaddi, 'label': 'Practice', 'route': '/practice'},
      {'icon': Icons.language, 'label': 'Culture', 'route': '/culture'},
      {'icon': Icons.person, 'label': 'Profile', 'route': '/profile'},
      {'icon': Icons.circle, 'label': 'Settings', 'route': '/settings'},
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: navItems.map((item) {
        final isSelected = item['label'] == selected;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: isSelected
                  ? AppTheme.primaryOrange
                  : Theme.of(context).iconTheme.color,
              size: 28,
            ),
            title: Text(
              item['label'] as String,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
            onTap: () => onNavigate?.call(item['route'] as String),
          ),
        );
      }).toList(),
    );
  }
}
