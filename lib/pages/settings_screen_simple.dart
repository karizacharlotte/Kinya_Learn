import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _dailyGoal = 45;
  String _appLanguage = 'English';
  String _culturalPreference = 'General';
  bool _soundEffects = true;
  bool _notifications = true;
  bool _offlineDownloads = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = prefs.getInt('daily_goal') ?? 45;
      _appLanguage = prefs.getString('app_language') ?? 'English';
      _culturalPreference = prefs.getString('cultural_preference') ?? 'General';
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
      _offlineDownloads = prefs.getBool('offline_downloads') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal', _dailyGoal);
    await prefs.setString('app_language', _appLanguage);
    await prefs.setString('cultural_preference', _culturalPreference);
    await prefs.setBool('sound_effects', _soundEffects);
    await prefs.setBool('notifications', _notifications);
    await prefs.setBool('offline_downloads', _offlineDownloads);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daily Goal Section
            _buildSection(
              title: 'Daily Goal',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minutes per day',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          '$_dailyGoal min',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.orange,
                        inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                        thumbColor: Colors.orange,
                        overlayColor: Colors.orange.withValues(alpha: 0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        trackHeight: 4,
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
                          _saveSettings();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // App Language Section
            _buildSection(
              title: 'App Language',
              child: _buildDropdownTile(
                icon: Icons.language,
                value: _appLanguage,
                items: ['English', 'Kinyarwanda', 'French'],
                onChanged: (value) {
                  setState(() {
                    _appLanguage = value!;
                  });
                  _saveSettings();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Cultural Preference Section
            _buildSection(
              title: 'Cultural Preference',
              child: _buildDropdownTile(
                icon: Icons.public,
                value: _culturalPreference,
                items: ['General', 'Traditional', 'Modern'],
                onChanged: (value) {
                  setState(() {
                    _culturalPreference = value!;
                  });
                  _saveSettings();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Sound Effects Section
            _buildSection(
              title: 'Sound Effects',
              child: _buildSwitchTile(
                icon: Icons.volume_up,
                title: 'Sound Effects',
                value: _soundEffects,
                onChanged: (value) {
                  setState(() {
                    _soundEffects = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Notifications Section
            _buildSection(
              title: 'Notifications',
              child: _buildSwitchTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                value: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Offline Downloads Section
            _buildSection(
              title: 'Offline Downloads',
              child: _buildSwitchTile(
                icon: Icons.download,
                title: 'Auto Download Lessons',
                value: _offlineDownloads,
                onChanged: (value) {
                  setState(() {
                    _offlineDownloads = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Dark Mode Section
            _buildSection(
              title: 'Dark Mode',
              child: _buildSwitchTile(
                icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'Dark Mode',
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.setDarkMode(value);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 5),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
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
          Icon(
            icon,
            color: theme.iconTheme.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange,
            activeTrackColor: Colors.orange.withValues(alpha: 0.3),
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
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
          Icon(
            icon,
            color: theme.iconTheme.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: theme.iconTheme.color,
                ),
                dropdownColor: theme.cardColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
