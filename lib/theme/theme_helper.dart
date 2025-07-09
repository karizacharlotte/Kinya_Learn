import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Theme helper to ensure consistent theming across all screens
class ThemeHelper {
  /// Get the appropriate background color for the current theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get the appropriate surface color for cards and containers
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Get the appropriate text color for primary text
  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Get the appropriate text color for secondary text
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.color ?? 
           Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
  }

  /// Get the appropriate text color for muted text
  static Color getMutedTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.color ?? 
           Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  }

  /// Get the appropriate primary color that adapts to theme
  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.primaryOrange : AppTheme.primaryPurple;
  }

  /// Get the appropriate card color
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface;
  }

  /// Get the appropriate divider color
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  /// Get appropriate app bar colors for different themes
  static Color getAppBarBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.primaryOrange : AppTheme.primaryOrange;
  }

  static Color getAppBarForegroundColor(BuildContext context) {
    return Colors.white;
  }

  /// Get appropriate button colors
  static Color getButtonBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.primaryOrange : AppTheme.primaryPurple;
  }

  static Color getButtonForegroundColor(BuildContext context) {
    return Colors.white;
  }

  /// Get appropriate border color
  static Color getBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.darkBorder : AppTheme.border;
  }

  /// Get appropriate icon color
  static Color getIconColor(BuildContext context) {
    return Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurface;
  }

  /// Get appropriate gradient for hero sections
  static LinearGradient getHeroGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surface,
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryOrange,
          AppTheme.primaryOrange,
        ],
      );
    }
  }

  /// Get appropriate container color with alpha
  static Color getContainerColor(BuildContext context, {double alpha = 0.1}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark 
        ? Colors.white.withValues(alpha: alpha)
        : AppTheme.primaryOrange.withValues(alpha: alpha);
  }

  /// Get appropriate accent color
  static Color getAccentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.primaryOrange : AppTheme.primaryBlue;
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get appropriate text style for headers
  static TextStyle getHeaderTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: getAppBarForegroundColor(context),
      fontWeight: FontWeight.bold,
    ) ?? TextStyle(
      color: getAppBarForegroundColor(context),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  /// Get appropriate text style for subtitles
  static TextStyle getSubtitleTextStyle(BuildContext context) {
    return TextStyle(
      color: getAppBarForegroundColor(context).withValues(alpha: 0.9),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
  }
}
