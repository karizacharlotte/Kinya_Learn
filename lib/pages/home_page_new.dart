import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const Navigation(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section
                  _buildHeroSection(context),
                  // Features Section
                  _buildFeaturesSection(context),
                  // Call to Action Section
                  _buildCallToActionSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding:
          ResponsiveHelper.getResponsiveHorizontalPadding(context).copyWith(
        top: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
        bottom: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [theme.colorScheme.background, theme.colorScheme.background]
              : [AppTheme.primaryOrange, AppTheme.primaryOrange],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use responsive layout based on screen size and orientation
          if (ResponsiveHelper.isDesktop(context) ||
              (ResponsiveHelper.isTablet(context) &&
                  ResponsiveHelper.isLandscape(context)))
            _buildHeroContentDesktop(context)
          else
            _buildHeroContentMobile(context),
        ],
      ),
    );
  }

  Widget _buildHeroContentDesktop(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildHeroText(context),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: _buildRwandaFlag(context),
        ),
      ],
    );
  }

  Widget _buildHeroContentMobile(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLandscape)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildHeroText(context),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildRwandaFlag(context),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroText(context),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              Center(child: _buildRwandaFlag(context)),
            ],
          ),
      ],
    );
  }

  Widget _buildHeroText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn Kinyarwanda\nwith KinyaLearn',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveHeaderFontSize(context),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.white,
            height: 1.2,
          ),
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
        Text(
          'Master Rwanda\'s beautiful language through interactive lessons, cultural insights, and certified achievements.',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
            color: isDark ? Colors.white70 : Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        SizedBox(
            height:
                ResponsiveHelper.getResponsiveSpacing(context, factor: 1.5)),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/lessons'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.white,
            foregroundColor: isDark ? Colors.black : AppTheme.primaryOrange,
            padding: ResponsiveHelper.getResponsiveButtonPadding(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Start Learning',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRwandaFlag(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveHelper.isDesktop(context) ? 200 : 150,
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF00A1DE),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 162, 143, 49),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 59, 117, 87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Padding(
      padding:
          ResponsiveHelper.getResponsiveHorizontalPadding(context).copyWith(
        top: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
        bottom: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
      ),
      child: Column(
        children: [
          Text(
            'Why Choose KinyaLearn?',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveTitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height:
                  ResponsiveHelper.getResponsiveSpacing(context, factor: 1.5)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
            crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(context),
            mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(context),
            childAspectRatio:
                ResponsiveHelper.getResponsiveCardAspectRatio(context),
            children: [
              _buildFeatureCard(
                'Interactive Lessons',
                'Learn through engaging exercises and real-world scenarios',
                Icons.school_rounded,
                AppTheme.primaryOrange,
                context,
              ),
              _buildFeatureCard(
                'Cultural Integration',
                'Understand Rwandan culture and context behind the language',
                Icons.language_rounded,
                const Color(0xFF00A1DE),
                context,
              ),
              _buildFeatureCard(
                'Certified Progress',
                'Track your learning journey and earn certificates',
                Icons.verified_rounded,
                const Color(0xFF22C55E),
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: ResponsiveHelper.getResponsiveHorizontalPadding(context).copyWith(
        bottom: ResponsiveHelper.getResponsiveSpacing(context, factor: 2),
      ),
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.background
                ]
              : [AppTheme.primaryOrange, AppTheme.primaryOrange],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Learning?',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveTitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
          Text(
            'Join thousands of students learning Kinyarwanda with KinyaLearn',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
              color:
                  isDark ? Colors.white70 : Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height:
                  ResponsiveHelper.getResponsiveSpacing(context, factor: 1.5)),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/lessons'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Colors.white,
              foregroundColor: isDark ? Colors.black : AppTheme.primaryOrange,
              padding: ResponsiveHelper.getResponsiveButtonPadding(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isDark ? 2 : 0,
            ),
            child: Text(
              'Start Your Journey',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveBodyFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppTheme.darkBorder : AppTheme.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ResponsiveHelper.getResponsiveIconSize(context) + 16,
              height: ResponsiveHelper.getResponsiveIconSize(context) + 16,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveHelper.getResponsiveIconSize(context),
              ),
            ),
            SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context,
                    factor: 0.75)),
            Text(
              title,
              style: TextStyle(
                fontSize:
                    ResponsiveHelper.getResponsiveBodyFontSize(context) + 2,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context,
                    factor: 0.5)),
            Text(
              description,
              style: TextStyle(
                fontSize:
                    ResponsiveHelper.getResponsiveBodyFontSize(context) - 1,
                color: isDark ? Colors.white70 : AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
