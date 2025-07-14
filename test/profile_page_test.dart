import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/pages/profile_page.dart';

void main() {
  group('ProfilePage Tests', () {
    testWidgets('should render profile page correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify that the profile page is rendered
      expect(find.text('Total XP'), findsOneWidget);
      expect(find.text('Accuracy'), findsOneWidget);
      expect(find.text('Learning Goals'), findsOneWidget);
      expect(find.text('Achievement Badges'), findsOneWidget);
    });

    testWidgets('should show statistics correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify statistics are displayed (without comma formatting)
      expect(find.text('2450'), findsOneWidget);
      expect(find.text('23/45'), findsOneWidget);
      expect(find.text('87%'), findsOneWidget);
    });

    testWidgets('should show profile options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Verify profile options are displayed
      expect(find.text('Achievement Badges'), findsOneWidget);
      expect(find.text('Learning Statistics'), findsOneWidget);
      expect(find.text('Cultural Preferences'), findsOneWidget);
      expect(find.text('Offline Downloads'), findsOneWidget);
      expect(find.text('Notification Settings'), findsOneWidget);
      expect(find.text('Privacy & Data'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About KinyaLearn'), findsOneWidget);
    });

    testWidgets('should handle tap on learning goals', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Tap on learning goals
      await tester.tap(find.text('Learning Goals'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('Daily XP Goal'), findsOneWidget);
      expect(find.text('Weekly Lessons'), findsOneWidget);
      expect(find.text('Monthly Challenge'), findsOneWidget);
    });

    testWidgets('should handle tap on achievement badges', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfilePage(),
        ),
      );

      // Tap on achievement badges
      await tester.tap(find.text('Achievement Badges'));
      await tester.pumpAndSettle();

      // Verify badge dialog is shown
      expect(find.text('First Star'), findsOneWidget);
      expect(find.text('Hot Streak'), findsOneWidget);
      expect(find.text('Scholar'), findsOneWidget);
    });
  });
}
