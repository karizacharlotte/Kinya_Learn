import 'package:flutter/material.dart';

class AppTheme {
  // Rwandan-inspired color palette from the provided colors
  static const Color background = Color(0xFFF7F8FA);
  static const Color foreground = Color(0xFF0F172A);

  // Primary colors from the palette
  static const Color primaryBlue = Color(0xFF6600ff); // Deep purple-blue
  static const Color primaryGreen = Color(0xFF66ff00); // Bright green
  static const Color accentPurple = Color(0xFF990099); // Rich purple
  static const Color accentTeal = Color(0xFF66cccc); // Soft teal
  static const Color warmOrange = Color(0xFF996600); // Warm brown-orange
  static const Color lightGreen = Color(0xFF99ff99); // Light green

  // Additional accent colors
  static const Color darkPurple = Color(0xFF663366); // Dark purple
  static const Color brightCyan = Color(0xFF66ffff); // Bright cyan
  static const Color deepGreen = Color(0xFF669966); // Deep green
  static const Color softPink = Color(0xFF9966cc); // Soft pink-purple

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: background,
        onSurface: foreground,
        primary: primaryBlue,
        onPrimary: Colors.white,
        secondary: primaryGreen,
        onSecondary: Colors.white,
        tertiary: accentPurple,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: foreground),
        bodyMedium: TextStyle(color: foreground),
        bodySmall: TextStyle(color: foreground),
      ),
    );
  }

  // Gradient combinations for beautiful UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, accentPurple],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, accentTeal],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warmOrange, lightGreen],
  );
}
