import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isMobile = screenWidth < 600;

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
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 20,
            vertical: 12,
          ),
          child: SizedBox(
            height: isMobile ? 56 : 64,
            child: Row(
              children: [
                // Logo with brand styling
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'KinyaLearn',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: isMobile
                      ? _buildMobileNavigation(context, currentRoute)
                      : _buildDesktopNavigation(context, currentRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation(BuildContext context, String currentRoute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: navigation
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 32),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  item.route,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: currentRoute == item.route
                        ? AppTheme.textPrimary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white
                          : (currentRoute == item.route
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: isDark ? Colors.white : AppTheme.textPrimary),
          onSelected: (route) =>
              Navigator.pushReplacementNamed(context, route),
          itemBuilder: (context) => navigation
              .map(
                (item) => PopupMenuItem<String>(
                  value: item.route,
                  child: Row(
                    children: [
                      Icon(
                        _getIconForRoute(item.route),
                        color: isDark ? Colors.white : AppTheme.textPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(item.name),
                    ],
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
        return Icons.home;
      case '/lessons':
        return Icons.book;
      case '/practice':
        return Icons.fitness_center;
      case '/culture':
        return Icons.language;
      case '/profile':
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}
