import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1600;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeDesktopBreakpoint;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 60);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 40);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
  }

  /// Get responsive font size for headers
  static double getResponsiveHeaderFontSize(BuildContext context) {
    if (isDesktop(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 36;
    } else {
      return isLandscape(context) ? 32 : 28;
    }
  }

  /// Get responsive font size for titles
  static double getResponsiveTitleFontSize(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    } else if (isTablet(context)) {
      return 28;
    } else {
      return isLandscape(context) ? 26 : 24;
    }
  }

  /// Get responsive font size for body text
  static double getResponsiveBodyFontSize(BuildContext context) {
    if (isDesktop(context)) {
      return 18;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return isLandscape(context) ? 15 : 14;
    }
  }

  /// Get responsive grid columns
  static int getResponsiveGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return isLandscape(context) ? 3 : 2;
    } else {
      return isLandscape(context) ? 2 : 1;
    }
  }

  /// Get responsive button padding
  static EdgeInsets getResponsiveButtonPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 18);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  /// Get responsive card aspect ratio
  static double getResponsiveCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) {
      return 1.2;
    } else if (isTablet(context)) {
      return isLandscape(context) ? 1.1 : 1.0;
    } else {
      return isLandscape(context) ? 1.8 : 1.5;
    }
  }

  /// Get responsive hero section height
  static double getResponsiveHeroHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);

    if (isDesktop(context)) {
      return screenHeight * 0.6;
    } else if (isTablet(context)) {
      return isLandscape(context) ? screenHeight * 0.7 : screenHeight * 0.5;
    } else {
      return isLandscape(context) ? screenHeight * 0.8 : screenHeight * 0.4;
    }
  }

  /// Get responsive navigation height
  static double getResponsiveNavigationHeight(BuildContext context) {
    if (isDesktop(context)) {
      return 80;
    } else if (isTablet(context)) {
      return 70;
    } else {
      return isLandscape(context) ? 60 : 65;
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context,
      {double factor = 1.0}) {
    if (isDesktop(context)) {
      return 24 * factor;
    } else if (isTablet(context)) {
      return 20 * factor;
    } else {
      return isLandscape(context) ? 18 * factor : 16 * factor;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    } else if (isTablet(context)) {
      return 28;
    } else {
      return isLandscape(context) ? 26 : 24;
    }
  }

  /// Check if should use side navigation
  static bool shouldUseSideNavigation(BuildContext context) {
    return isDesktop(context) || (isTablet(context) && isLandscape(context));
  }

  /// Get responsive layout type
  static ResponsiveLayoutType getLayoutType(BuildContext context) {
    if (isDesktop(context)) {
      return ResponsiveLayoutType.desktop;
    } else if (isTablet(context)) {
      return isLandscape(context)
          ? ResponsiveLayoutType.tabletLandscape
          : ResponsiveLayoutType.tabletPortrait;
    } else {
      return isLandscape(context)
          ? ResponsiveLayoutType.mobileLandscape
          : ResponsiveLayoutType.mobilePortrait;
    }
  }

  /// Get responsive cross axis count for grid
  static int getResponsiveCrossAxisCount(BuildContext context,
      {int? mobileCount, int? tabletCount, int? desktopCount}) {
    if (isDesktop(context)) {
      return desktopCount ?? 4;
    } else if (isTablet(context)) {
      return tabletCount ?? (isLandscape(context) ? 3 : 2);
    } else {
      return mobileCount ?? (isLandscape(context) ? 2 : 1);
    }
  }
}

enum ResponsiveLayoutType {
  mobilePortrait,
  mobileLandscape,
  tabletPortrait,
  tabletLandscape,
  desktop,
}

/// A responsive widget that adapts its child based on screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? mobileLandscape;
  final Widget? tabletLandscape;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.mobileLandscape,
    this.tabletLandscape,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop ?? tablet ?? mobile ?? Container();
    } else if (ResponsiveHelper.isTablet(context)) {
      if (ResponsiveHelper.isLandscape(context)) {
        return tabletLandscape ?? tablet ?? desktop ?? mobile ?? Container();
      } else {
        return tablet ?? mobile ?? Container();
      }
    } else {
      if (ResponsiveHelper.isLandscape(context)) {
        return mobileLandscape ?? mobile ?? tablet ?? Container();
      } else {
        return mobile ?? Container();
      }
    }
  }
}

/// A responsive container that adapts its properties based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final bool useResponsivePadding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.useResponsivePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ??
          (useResponsivePadding
              ? ResponsiveHelper.getResponsivePadding(context)
              : null),
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}
