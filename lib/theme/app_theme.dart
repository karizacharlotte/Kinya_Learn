import 'package:flutter/material.dart';

class AppTheme {
  // Colors from Figma design
  static const Color background = Color(0xFFF8FAFC);
  static const Color foreground = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Primary brand colors from Figma
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color primaryBlue = Color(0xFF8B5CF6); // Light purple
  static const Color primaryGreen = Color(0xFF800020); // Maroon color
  static const Color primaryOrange = Color(0xFFEA580C);
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryTeal = Color(0xFF0891B2);

  // Accent colors from design
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentIndigo = Color(0xFF6366F1); // Medium purple
  static const Color accentEmerald = Color(0xFF800020); // Maroon color

  // Neutral colors from Figma
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color surface = Color(0xFFF1F5F9);

  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        surface: background,
        onSurface: foreground,
        primary: primaryPurple,
        onPrimary: Colors.white,
        secondary: primaryGreen,
        onSecondary: Colors.white,
        tertiary: Color(0xFF8B5CF6), // Light purple instead of blue
        onTertiary: Colors.white,
        error: error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  // Gradients from Figma design
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, Color(0xFF8B5CF6)], // Purple to light purple
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryRed], // Maroon to red gradient
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, primaryRed],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPink, accentIndigo],
  );

  // Rwanda flag colors for splash screen
  static const Color rwandaBlue = Color(0xFF00A1DE);
  static const Color rwandaYellow = Color(0xFFFAD201);
  static const Color rwandaGreen = Color(0xFF00A651);

  // Splash screen gradient
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF8C42), // Orange from your splash screen
      Color(0xFFFF6B1A), // Deeper orange
    ],
  );
}
