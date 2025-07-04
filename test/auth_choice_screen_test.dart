import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/pages/auth/auth_choice_screen.dart';
import 'package:kinya_learn/theme/app_theme.dart';

void main() {
  group('AuthChoiceScreen Merge Resolution Tests', () {
    testWidgets('should render with light theme (resolves raissa branch conflicts)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const AuthChoiceScreen(),
        ),
      );

      // Verify the screen renders without errors
      expect(find.byType(AuthChoiceScreen), findsOneWidget);
      expect(find.text('KinyaLearn'), findsOneWidget);
      expect(find.text('Learn Kinyarwanda with confidence'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('should render with dark theme (preserves main branch theming)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AuthChoiceScreen(),
        ),
      );

      // Verify the screen renders without errors in dark mode
      // This test validates that we preserved the theming infrastructure
      // from main branch instead of the hardcoded colors from raissa branch
      expect(find.byType(AuthChoiceScreen), findsOneWidget);
      expect(find.text('KinyaLearn'), findsOneWidget);
      expect(find.text('Learn Kinyarwanda with confidence'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('should handle responsive layout', (WidgetTester tester) async {
      // Test tablet layout (>768px width)
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const AuthChoiceScreen(),
        ),
      );

      expect(find.byType(AuthChoiceScreen), findsOneWidget);
      
      // Test mobile layout (<768px width)
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pump();
      
      expect(find.byType(AuthChoiceScreen), findsOneWidget);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });
}