import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Theme Section
          _buildSectionTitle('Appearance'),
          _buildSettingsTile(
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              activeColor: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 20),
          
          // Language Section
          _buildSectionTitle('Language'),
          _buildSettingsTile(
            title: 'App Language',
            subtitle: 'English',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          const SizedBox(height: 20),
          
          // Notifications Section
          _buildSectionTitle('Notifications'),
          _buildSettingsTile(
            title: 'Push Notifications',
            subtitle: 'Receive lesson reminders',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement notification settings
              },
              activeColor: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 20),
          
          // Account Section
          _buildSectionTitle('Account'),
          _buildSettingsTile(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          _buildSettingsTile(
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          _buildSettingsTile(
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            trailing: const Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () {
              _showSignOutDialog(context);
            },
          ),
=======
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  double _textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final headerHeight = isTablet ? 180.0 : 140.0;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Navigation Drawer/Menu (permanent on wide screens, modal on mobile)
          if (screenWidth > 700)
            Container(
              width: 120,
              color: Colors.white,
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
                        color: const Color(0xFFB55208),
                        padding: EdgeInsets.only(left: isTablet ? 40 : 20, right: isTablet ? 40 : 20, top: isTablet ? 36 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                if (screenWidth <= 700)
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.15),
                                      padding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                const SizedBox(width: 8),
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
                            Padding(
                              padding: EdgeInsets.only(left: isTablet ? 48 : 44),
                              child: Text(
                                'Manage your preferences and account',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 15,
                                  color: Colors.white.withOpacity(0.95),
                                ),
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
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20, vertical: isTablet ? 32 : 20),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person_outline),
                                title: const Text('Account'),
                                subtitle: const Text('Manage your account information'),
                                onTap: () {
                                  // Navigate to account details
                                },
                              ),
                              SwitchListTile(
                                secondary: const Icon(Icons.notifications_none),
                                title: const Text('Enable Notifications'),
                                value: _notificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                },
                              ),
                              SwitchListTile(
                                secondary: const Icon(Icons.dark_mode_outlined),
                                title: const Text('Dark Mode'),
                                value: isDarkMode,
                                onChanged: (value) {
                                  themeProvider.toggleTheme(value);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.text_fields),
                                title: const Text('Text Size'),
                                subtitle: Text(_textScale == 1.0 ? 'Normal' : _textScale == 1.2 ? 'Large' : 'Extra Large'),
                                trailing: DropdownButton<double>(
                                  value: _textScale,
                                  items: const [
                                    DropdownMenuItem(value: 1.0, child: Text('Normal')),
                                    DropdownMenuItem(value: 1.2, child: Text('Large')),
                                    DropdownMenuItem(value: 1.4, child: Text('Extra Large')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _textScale = value ?? 1.0;
                                      // You can use this value with MediaQuery or a provider for accessibility
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: const Text('Language'),
                                subtitle: const Text('Change app language'),
                                onTap: () {
                                  // Show language selection dialog
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.privacy_tip_outlined),
                                title: const Text('Privacy Policy'),
                                onTap: () {
                                  // Open privacy policy
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Log Out'),
                                onTap: () {
                                  // Handle log out
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
>>>>>>> cd93ff76ad06ceea873f7d098bc4d8f010cbb529
        ],
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth-choice',
                  (route) => false,
                );
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
=======
}

// Side navigation widget for settings screen
class SideNavigation extends StatelessWidget {
  final String selected;
  final void Function(String route)? onNavigate;
  const SideNavigation({required this.selected, this.onNavigate, Key? key}) : super(key: key);

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
              color: isSelected ? const Color(0xFFB55208) : const Color(0xFF131A2A),
              size: 28,
            ),
            title: Text(
              item['label'] as String,
              style: TextStyle(
                color: isSelected ? const Color(0xFFB55208) : const Color(0xFF131A2A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
            selected: isSelected,
            onTap: isSelected
                ? null
                : () {
                    if (onNavigate != null) {
                      onNavigate!(item['route'] as String);
                    } else {
                      Navigator.pushNamed(context, item['route'] as String);
                    }
                  },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 0,
          ),
        );
      }).toList(),
>>>>>>> cd93ff76ad06ceea873f7d098bc4d8f010cbb529
    );
  }
}
