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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 16,
            vertical: 8,
          ),
          child: SizedBox(
            height: isMobile ? 56 : 64,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Text(
                    'KinyaLearn',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
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
                      horizontal: 4,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: currentRoute == item.route
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: currentRoute == item.route
                            ? Colors.grey[900]
                            : Colors.grey[500],
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
            icon: const Icon(Icons.menu, color: AppTheme.primaryBlue),
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
                          color: AppTheme.primaryBlue,
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
