import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/theme/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    setUp(() {
      // Reset the static variables before each test
      ThemeProvider.resetForTesting();
    });

    test('Theme persistence works correctly', () {
      // Create first provider instance
      var provider1 = ThemeProvider();

      // Initially should be light theme (default)
      expect(provider1.themeMode, ThemeMode.light);

      // Set to dark mode
      provider1.setThemeMode(ThemeMode.dark);
      expect(provider1.themeMode, ThemeMode.dark);
      expect(provider1.isDarkMode, true);

      // Create second provider instance (simulating app restart)
      var provider2 = ThemeProvider();

      // Should remember the dark mode setting
      expect(provider2.themeMode, ThemeMode.dark);
      expect(provider2.isDarkMode, true);

      // Switch to light mode
      provider2.setThemeMode(ThemeMode.light);
      expect(provider2.themeMode, ThemeMode.light);
      expect(provider2.isDarkMode, false);

      // Create third provider instance
      var provider3 = ThemeProvider();

      // Should remember the light mode setting
      expect(provider3.themeMode, ThemeMode.light);
      expect(provider3.isDarkMode, false);
    });

    test('Toggle theme works correctly', () {
      var provider = ThemeProvider();

      // Toggle to dark
      provider.toggleTheme(true);
      expect(provider.themeMode, ThemeMode.dark);

      // Toggle to light
      provider.toggleTheme(false);
      expect(provider.themeMode, ThemeMode.light);

      // Create new provider to verify persistence
      var newProvider = ThemeProvider();
      expect(newProvider.themeMode, ThemeMode.light);
    });

    test('Theme stays the same until manually changed', () {
      var provider = ThemeProvider();

      // Set to dark mode
      provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);

      // Simulate app restart - should stay dark
      var provider2 = ThemeProvider();
      expect(provider2.themeMode, ThemeMode.dark);

      // Simulate another restart - should still be dark
      var provider3 = ThemeProvider();
      expect(provider3.themeMode, ThemeMode.dark);

      // Only changes when user explicitly changes it
      provider3.setThemeMode(ThemeMode.light);
      expect(provider3.themeMode, ThemeMode.light);

      // Verify persistence of the new choice
      var provider4 = ThemeProvider();
      expect(provider4.themeMode, ThemeMode.light);
    });
  });
}
