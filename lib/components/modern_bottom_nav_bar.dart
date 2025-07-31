import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const ModernBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: isDark ? AppTheme.darkCardBackground : Colors.white,
        shadowColor: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: isDark 
                ? [
                    AppTheme.darkCardBackground,
                    AppTheme.darkCardBackground.withValues(alpha: 0.9),
                  ]
                : [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernNavItem(
                    context,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    route: '/',
                  ),
                  _buildModernNavItem(
                    context,
                    icon: Icons.menu_book_rounded,
                    label: 'Lessons',
                    index: 1,
                    route: '/lessons',
                  ),
                  _buildModernNavItem(
                    context,
                    icon: Icons.psychology_rounded,
                    label: 'Practice',
                    index: 2,
                    route: '/practice',
                  ),
                  _buildModernNavItem(
                    context,
                    icon: Icons.public_rounded,
                    label: 'Culture',
                    index: 3,
                    route: '/culture',
                  ),
                  _buildModernNavItem(
                    context,
                    icon: Icons.account_circle_rounded,
                    label: 'Profile',
                    index: 4,
                    route: '/profile-page',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(
            colors: [
              AppTheme.primaryOrange,
              AppTheme.primaryOrange.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppTheme.primaryOrange.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: isActive ? BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ) : null,
              child: Icon(
                icon,
                color: isActive 
                  ? Colors.white
                  : isDark 
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
                size: 24,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1.0 : 0.0,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
