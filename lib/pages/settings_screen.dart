import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../components/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  double _textScale = 1.0;

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
                                          const Color(0xFF23262F),
                                          const Color(0xFF23262F)
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
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.person_outline,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Account',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      subtitle: Text(
                                          'Manage your account information',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color)),
                                      onTap: () {
                                        // Navigate to account details
                                      },
                                    ),
                                    SwitchListTile(
                                      secondary: Icon(Icons.notifications_none,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Enable Notifications',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      value: _notificationsEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          _notificationsEnabled = value;
                                        });
                                      },
                                    ),
                                    // Theme Selection
                                    ListTile(
                                      leading: Icon(Icons.palette_outlined,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Theme',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      subtitle: Text(
                                          _getThemeModeName(
                                              themeProvider.themeMode),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color)),
                                      trailing: PopupMenuButton(
                                        icon: Icon(Icons.more_vert,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: const Text('Change Theme'),
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () {
                                                Navigator.pop(context);
                                                _showThemeDialog(
                                                    context, themeProvider);
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading:
                                                  const Icon(Icons.refresh),
                                              title: const Text(
                                                  'Reset Theme Choice'),
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () {
                                                Navigator.pop(context);
                                                _showResetThemeDialog(
                                                    context, themeProvider);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        _showThemeDialog(
                                            context, themeProvider);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.text_fields,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Text Size',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      subtitle: Text(
                                          _textScale == 1.0
                                              ? 'Normal'
                                              : _textScale == 1.2
                                                  ? 'Large'
                                                  : 'Extra Large',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color)),
                                      trailing: DropdownButton<double>(
                                        value: _textScale,
                                        dropdownColor:
                                            Theme.of(context).cardColor,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color),
                                        items: [
                                          DropdownMenuItem(
                                              value: 1.0,
                                              child: Text('Normal',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color))),
                                          DropdownMenuItem(
                                              value: 1.2,
                                              child: Text('Large',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color))),
                                          DropdownMenuItem(
                                              value: 1.4,
                                              child: Text('Extra Large',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color))),
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
                                      leading: Icon(Icons.language,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Language',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      subtitle: Text('Change app language',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color)),
                                      onTap: () {
                                        // Show language selection dialog
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.privacy_tip_outlined,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Privacy Policy',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      onTap: () {
                                        // Open privacy policy
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.logout,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      title: Text('Log Out',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color)),
                                      onTap: () {
                                        _showLogoutConfirmation(context);
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 5),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
      '/auth',
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
