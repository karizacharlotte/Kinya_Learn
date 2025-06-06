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
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isMobile = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
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
                          color: AppTheme.primaryPurple,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: isMobile
                      ? _buildMobileNavigation(currentRoute)
                      : _buildDesktopNavigation(currentRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation(String currentRoute) {
    return Row(
      children: navigation
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Builder(
                builder: (context) => GestureDetector(
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
                          ? AppTheme.primaryPurple.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: currentRoute == item.route
                            ? AppTheme.primaryPurple
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMobileNavigation(String currentRoute) {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: AppTheme.primaryPurple),
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
                          color: AppTheme.primaryPurple,
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
      ),
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
