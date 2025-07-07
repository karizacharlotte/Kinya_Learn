import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Start with light theme as default, but user can change it
  ThemeMode _themeMode = ThemeMode.light;
  bool _isFirstTime = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isFirstTime => _isFirstTime;

  // Static variable for persistent storage across app sessions
  static ThemeMode? _persistedTheme;
  static bool? _hasUserSetTheme;

  ThemeProvider() {
    _loadTheme();
  }

  /// Toggle between dark and light mode only (not system)
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _isFirstTime = false;
    _saveTheme();
    notifyListeners();
  }

  /// Set specific theme mode (system, light, or dark)
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _isFirstTime = false;
    _saveTheme();
    notifyListeners();
  }

  /// Check if user has ever set a theme preference
  bool hasUserSetTheme() {
    return _hasUserSetTheme ?? false;
  }

  /// Load saved theme preference
  void _loadTheme() {
    // Load the persisted theme if it exists
    if (_persistedTheme != null) {
      _themeMode = _persistedTheme!;
    }

    // Load the first-time status
    if (_hasUserSetTheme != null) {
      _isFirstTime = !_hasUserSetTheme!;
    }

    // Debug output
    print('Theme loaded: $_themeMode, isFirstTime: $_isFirstTime');
  }

  /// Save theme preference for persistence
  void _saveTheme() {
    _persistedTheme = _themeMode;
    _hasUserSetTheme = true;
    print('Theme saved: $_themeMode, hasUserSetTheme: true');
  }

  /// Show theme selection dialog for first-time users
  void promptThemeSelection(BuildContext context) {
    if (_isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInitialThemeDialog(context);
      });
    }
  }

  void _showInitialThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Choose Your Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Welcome to KinyaLearn! Please select your preferred theme:'),
            const SizedBox(height: 20),
            RadioListTile<ThemeMode>(
              title: const Text('Follow System'),
              subtitle: const Text('Matches your device theme'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              subtitle: const Text('Always light theme'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              subtitle: const Text('Always dark theme'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Reset to allow user to choose theme again
  void resetToFirstTime() {
    _isFirstTime = true;
    _hasUserSetTheme = false;
    _persistedTheme = null;
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Reset static variables for testing
  static void resetForTesting() {
    _persistedTheme = null;
    _hasUserSetTheme = null;
  }
}
