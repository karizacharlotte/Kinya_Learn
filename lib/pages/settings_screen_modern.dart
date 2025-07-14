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
  bool _notifications = true;
  String _textSize = 'Normal';
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('notifications') ?? true;
      _textSize = prefs.getString('text_size') ?? 'Normal';
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notifications);
    await prefs.setString('text_size', _textSize);
    await prefs.setString('language', _language);
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
        centerTitle: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your preferences and account',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Main settings card
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Account
                  _buildSettingItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Account',
                    subtitle: 'Manage your account information',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _buildDivider(context),
                  
                  // Enable Notifications
                  _buildSettingItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Enable Notifications',
                    trailing: Switch(
                      value: _notifications,
                      onChanged: (value) {
                        setState(() {
                          _notifications = value;
                        });
                        _saveSettings();
                      },
                      activeColor: Colors.orange,
                      activeTrackColor: Colors.orange.withValues(alpha: 0.3),
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  _buildDivider(context),
                  
                  // Theme
                  _buildSettingItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: isDarkMode ? 'Dark' : 'Light',
                    trailing: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      onSelected: (value) {
                        if (value == 'light') {
                          themeProvider.setDarkMode(false);
                        } else if (value == 'dark') {
                          themeProvider.setDarkMode(true);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'light',
                          child: Text('Light'),
                        ),
                        const PopupMenuItem(
                          value: 'dark',
                          child: Text('Dark'),
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(context),
                  
                  // Text Size
                  _buildSettingItem(
                    context,
                    icon: Icons.text_fields_outlined,
                    title: 'Text Size',
                    subtitle: _textSize,
                    trailing: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      onSelected: (value) {
                        setState(() {
                          _textSize = value;
                        });
                        _saveSettings();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Small',
                          child: Text('Small'),
                        ),
                        const PopupMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        const PopupMenuItem(
                          value: 'Large',
                          child: Text('Large'),
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(context),
                  
                  // Language
                  _buildSettingItem(
                    context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'Change app language',
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                  _buildDivider(context),
                  
                  // Privacy Policy
                  _buildSettingItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  _buildDivider(context),
                  
                  // Log Out
                  _buildSettingItem(
                    context,
                    icon: Icons.exit_to_app_outlined,
                    title: 'Log Out',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 5),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.grey[600],
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
      height: 1,
      thickness: 1,
      indent: 56,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() {
                  _language = 'English';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Kinyarwanda'),
              onTap: () {
                setState(() {
                  _language = 'Kinyarwanda';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('French'),
              onTap: () {
                setState(() {
                  _language = 'French';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
