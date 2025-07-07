import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';

class NavigationItem {
  final String name;
  final String route;

  NavigationItem({required this.name, required this.route});
}

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  static final List<NavigationItem> navigation = [
    NavigationItem(name: 'Home', route: '/'),
    NavigationItem(name: 'Lessons', route: '/lessons'),
    NavigationItem(name: 'Practice', route: '/practice'),
    NavigationItem(name: 'Culture', route: '/culture'),
    NavigationItem(name: 'Profile', route: '/profile'),
    NavigationItem(name: 'Settings', route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final isTablet = ResponsiveHelper.isTablet(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              ResponsiveHelper.getResponsiveHorizontalPadding(context).copyWith(
            top: 12,
            bottom: 12,
          ),
          child: SizedBox(
            height: ResponsiveHelper.getResponsiveNavigationHeight(context),
            child: Row(
              children: [
                // Logo with brand styling
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Row(
                    children: [
                      Container(
                        width: isDesktop ? 40 : (isTablet ? 36 : 32),
                        height: isDesktop ? 40 : (isTablet ? 36 : 32),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                          size: isDesktop ? 24 : (isTablet ? 20 : 18),
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      if (!isMobile ||
                          !isLandscape) 
                        Text(
                          'KinyaLearn',
                          style: TextStyle(
                            fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 24),
                Expanded(
                  child: _buildResponsiveNavigation(context, currentRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveNavigation(BuildContext context, String currentRoute) {
    // Use hamburger menu for mobile or tablet portrait
    if (ResponsiveHelper.isMobile(context) ||
        (ResponsiveHelper.isTablet(context) &&
            ResponsiveHelper.isPortrait(context))) {
      return _buildMobileNavigation(context, currentRoute);
    } else {
      return _buildDesktopNavigation(context, currentRoute);
    }
  }

  Widget _buildDesktopNavigation(BuildContext context, String currentRoute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Row(
      children: navigation
          .map(
            (item) => Padding(
              padding:
                  EdgeInsets.only(right: isDesktop ? 32 : (isTablet ? 24 : 16)),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  item.route,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 20 : (isTablet ? 16 : 12),
                    vertical: isDesktop ? 12 : (isTablet ? 10 : 8),
                  ),
                  decoration: BoxDecoration(
                    color: currentRoute == item.route
                        ? (isDark
                            ? AppTheme.primaryOrange.withOpacity(0.2)
                            : AppTheme.textPrimary.withOpacity(0.1))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: currentRoute == item.route
                        ? Border.all(
                            color: AppTheme.primaryOrange.withOpacity(0.3))
                        : null,
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : (isTablet ? 15 : 14),
                      fontWeight: currentRoute == item.route
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: currentRoute == item.route
                          ? (isDark
                              ? AppTheme.primaryOrange
                              : AppTheme.primaryOrange)
                          : (isDark ? Colors.white : AppTheme.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMobileNavigation(BuildContext context, String currentRoute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Show current page indicator on landscape
        if (isLandscape) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
            ),
            child: Text(
              navigation.firstWhere((item) => item.route == currentRoute).name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryOrange,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        PopupMenuButton<String>(
          icon: Icon(
            Icons.menu,
            color: isDark ? Colors.white : AppTheme.textPrimary,
            size: ResponsiveHelper.getResponsiveIconSize(context),
          ),
          onSelected: (route) => Navigator.pushReplacementNamed(context, route),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          color: isDark ? AppTheme.darkCardBackground : Colors.white,
          itemBuilder: (context) => navigation
              .map(
                (item) => PopupMenuItem<String>(
                  value: item.route,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: currentRoute == item.route
                                ? AppTheme.primaryOrange.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconForRoute(item.route),
                            color: currentRoute == item.route
                                ? AppTheme.primaryOrange
                                : (isDark
                                    ? Colors.white70
                                    : AppTheme.textSecondary),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: currentRoute == item.route
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: currentRoute == item.route
                                  ? AppTheme.primaryOrange
                                  : (isDark
                                      ? Colors.white
                                      : AppTheme.textPrimary),
                            ),
                          ),
                        ),
                        if (currentRoute == item.route)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  IconData _getIconForRoute(String route) {
    switch (route) {
      case '/':
        return Icons.home_rounded;
      case '/lessons':
        return Icons.book_rounded;
      case '/practice':
        return Icons.fitness_center_rounded;
      case '/culture':
        return Icons.language_rounded;
      case '/profile':
        return Icons.person_rounded;
      case '/settings':
        return Icons.settings_rounded;
      default:
        return Icons.circle;
    }
  }
}
