import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Screen type detection
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool shouldUseSideNavigation(BuildContext context) {
    return isDesktop(context);
  }

  // Responsive values
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getResponsiveSpacing(
    BuildContext context, {
    double? small,
    double? medium,
    double? large,
  }) {
    return getResponsiveValue(
      context,
      mobile: small ?? 16,
      tablet: medium ?? 24,
      desktop: large ?? 32,
    );
  }

  // Font sizes
  static double getResponsiveHeaderFontSize(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );
  }

  static double getResponsiveTitleFontSize(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );
  }

  static double getResponsiveBodyFontSize(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 14,
      tablet: 16,
      desktop: 16,
    );
  }

  // Icon sizes
  static double getResponsiveIconSize(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 28,
    );
  }

  // Padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(getResponsiveValue(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    ));
  }

  static EdgeInsets getResponsiveButtonPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveValue(context, mobile: 16, tablet: 20, desktop: 24),
      vertical: getResponsiveValue(context, mobile: 12, tablet: 16, desktop: 16),
    );
  }

  // Grid
  static int getResponsiveCrossAxisCount(
    BuildContext context, {
    int? mobileCount,
    int? tabletCount,
    int? desktopCount,
  }) {
    if (isMobile(context)) return mobileCount ?? 1;
    if (isTablet(context)) return tabletCount ?? 2;
    return desktopCount ?? 3;
  }

  static double getResponsiveCardAspectRatio(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1.1,
      tablet: 1.2,
      desktop: 1.3,
    );
  }

  // Navigation
  static double getResponsiveNavigationHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 56,
      tablet: 64,
      desktop: 72,
    );
  }

  // Orientation helpers
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Horizontal padding helper
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveValue(
        context,
        mobile: 16,
        tablet: 24,
        desktop: 32,
      ),
    );
  }
}