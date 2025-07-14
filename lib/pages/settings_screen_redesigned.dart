import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  int _dailyGoal = 15;
  bool _notificationsEnabled = true;
  bool _offlineDownloads = false;
  String _culturalPreference = 'General';
  bool _soundEffects = true;
  bool _darkMode = false;
  String _language = 'English';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = prefs.getInt('daily_goal') ?? 15;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _offlineDownloads = prefs.getBool('offline_downloads') ?? false;
      _culturalPreference = prefs.getString('cultural_preference') ?? 'General';
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal', _dailyGoal);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('offline_downloads', _offlineDownloads);
    await prefs.setString('cultural_preference', _culturalPreference);
    await prefs.setBool('sound_effects', _soundEffects);
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setString('language', _language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange,
                      Colors.deepOrange,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.settings,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // User Profile Section
                    _buildProfileSection(),
                    
                    SizedBox(height: 24),
                    
                    // Learning Preferences
                    _buildSectionCard(
                      title: 'Learning Preferences',
                      icon: Icons.school,
                      color: Colors.blue,
                      children: [
                        _buildGoalSlider(),
                        SizedBox(height: 16),
                        _buildLanguageSelector(),
                        SizedBox(height: 16),
                        _buildCulturalPreferenceSelector(),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // App Settings
                    _buildSectionCard(
                      title: 'App Settings',
                      icon: Icons.tune,
                      color: Colors.purple,
                      children: [
                        _buildToggleRow(
                          title: 'Sound Effects',
                          subtitle: 'Enable audio feedback',
                          icon: Icons.volume_up,
                          value: _soundEffects,
                          onChanged: (value) {
                            setState(() {
                              _soundEffects = value;
                            });
                            _saveSettings();
                          },
                        ),
                        _buildToggleRow(
                          title: 'Notifications',
                          subtitle: 'Daily reminders and updates',
                          icon: Icons.notifications,
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                            _saveSettings();
                          },
                        ),
                        _buildToggleRow(
                          title: 'Offline Downloads',
                          subtitle: 'Download content for offline use',
                          icon: Icons.download,
                          value: _offlineDownloads,
                          onChanged: (value) {
                            setState(() {
                              _offlineDownloads = value;
                            });
                            _saveSettings();
                            if (value) {
                              _showDownloadDialog();
                            }
                          },
                        ),
                        _buildToggleRow(
                          title: 'Dark Mode',
                          subtitle: 'Use dark theme',
                          icon: Icons.dark_mode,
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = value;
                            });
                            _saveSettings();
                          },
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Progress & Stats
                    _buildSectionCard(
                      title: 'Progress & Statistics',
                      icon: Icons.analytics,
                      color: Colors.green,
                      children: [
                        _buildActionRow(
                          title: 'Achievement Badges',
                          subtitle: 'View your earned badges',
                          icon: Icons.emoji_events,
                          onTap: () => _showAchievements(),
                        ),
                        _buildActionRow(
                          title: 'Learning Statistics',
                          subtitle: 'Detailed progress analytics',
                          icon: Icons.bar_chart,
                          onTap: () => _showStatistics(),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Support & Info
                    _buildSectionCard(
                      title: 'Support & Information',
                      icon: Icons.help_outline,
                      color: Colors.teal,
                      children: [
                        _buildActionRow(
                          title: 'Privacy & Data',
                          subtitle: 'Manage your privacy settings',
                          icon: Icons.privacy_tip,
                          onTap: () => _showPrivacyDialog(),
                        ),
                        _buildActionRow(
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          icon: Icons.support_agent,
                          onTap: () => _showHelpDialog(),
                        ),
                        _buildActionRow(
                          title: 'About KinyaLearn',
                          subtitle: 'App information and credits',
                          icon: Icons.info,
                          onTap: () => _showAboutDialog(),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Danger Zone
                    _buildDangerCard(),
                    
                    SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 5),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KinyaLearn User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Learning Kinyarwanda since 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Level 1',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Goal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_dailyGoal min',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            inactiveTrackColor: Colors.orange.withOpacity(0.3),
            thumbColor: Colors.orange,
            overlayColor: Colors.orange.withOpacity(0.2),
          ),
          child: Slider(
            value: _dailyGoal.toDouble(),
            min: 5,
            max: 120,
            divisions: 23,
            onChanged: (value) {
              setState(() {
                _dailyGoal = value.round();
              });
            },
            onChangeEnd: (value) {
              _saveSettings();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return _buildSelectorRow(
      title: 'App Language',
      value: _language,
      options: ['English', 'Kinyarwanda', 'French', 'Swahili'],
      onChanged: (value) {
        setState(() {
          _language = value;
        });
        _saveSettings();
      },
    );
  }

  Widget _buildCulturalPreferenceSelector() {
    return _buildSelectorRow(
      title: 'Cultural Preference',
      value: _culturalPreference,
      options: ['General', 'Traditional', 'Modern', 'Regional'],
      onChanged: (value) {
        setState(() {
          _culturalPreference = value;
        });
        _saveSettings();
      },
    );
  }

  Widget _buildSelectorRow({
    required String title,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () => _showOptionsDialog(title, value, options, onChanged),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey.shade600,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey.shade600,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Danger Zone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showResetDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Reset All Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(String title, String currentValue, List<String> options, Function(String) onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: currentValue,
            onChanged: (value) {
              onChanged(value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offline Downloads'),
        content: Text('Download lessons and audio for offline use. This will use device storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Downloads starting...')),
              );
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _showAchievements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Achievement Badges'),
        content: Text('Your earned badges will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStatistics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Learning Statistics'),
        content: Text('Detailed progress analytics will be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy & Data'),
        content: Text('Manage your privacy settings and data preferences.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support'),
        content: Text('Need help? Contact our support team or check our FAQ.'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('KinyaLearn v1.0.0'),
            SizedBox(height: 8),
            Text('Learn Kinyarwanda with authentic African voices and interactive exercises.'),
            SizedBox(height: 8),
            Text('© 2024 KinyaLearn Team'),
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

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Settings'),
        content: Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await _loadSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings reset successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
