import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kinya_learn/pages/home_page.dart';
import 'package:kinya_learn/providers/auth_provider.dart';
import 'package:kinya_learn/theme/theme_provider.dart';
import 'package:kinya_learn/widgets/rwandan_flag.dart';

@GenerateMocks([AuthProvider])
import 'home_page_test.mocks.dart';

void main() {
  group('HomePage Widget Tests', () {
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
    });

    testWidgets('should render home page for guest user', (WidgetTester tester) async {
      when(mockAuthProvider.isLoggedIn).thenReturn(false);
      when(mockAuthProvider.displayName).thenReturn('Guest');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/auth': (context) => Scaffold(body: Text('Auth Page')),
              '/lessons': (context) => Scaffold(body: Text('Lessons Page')),
            },
          ),
        ),
      );

      expect(find.text('Learn Kinyarwanda\nwith KinyaLearn'), findsOneWidget);
      expect(find.text('Sign In to Track Progress'), findsOneWidget);
      expect(find.text('Why Choose KinyaLearn?'), findsOneWidget);
      expect(find.text('Quick Start'), findsOneWidget);
    });

    testWidgets('should render home page for logged in user', (WidgetTester tester) async {
      when(mockAuthProvider.isLoggedIn).thenReturn(true);
      when(mockAuthProvider.displayName).thenReturn('Test User');
      when(mockAuthProvider.totalXP).thenReturn(100);
      when(mockAuthProvider.currentStreak).thenReturn(5);
      when(mockAuthProvider.lessonsCompleted).thenReturn(10);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/auth': (context) => Scaffold(body: Text('Auth Page')),
              '/lessons': (context) => Scaffold(body: Text('Lessons Page')),
            },
          ),
        ),
      );

      expect(find.text('Welcome back, Test User!'), findsOneWidget);
      expect(find.text('Study Tools'), findsOneWidget);
      expect(find.text('100'), findsOneWidget); // XP
      expect(find.text('5 days'), findsOneWidget); // Streak
      expect(find.text('10'), findsOneWidget); // Lessons completed
    });

    testWidgets('should show Rwandan flag on desktop', (WidgetTester tester) async {
      when(mockAuthProvider.isLoggedIn).thenReturn(false);
      
      await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop size
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/auth': (context) => Scaffold(body: Text('Auth Page')),
            },
          ),
        ),
      );

      expect(find.byType(RwandanFlag), findsOneWidget);
    });

    testWidgets('should navigate to auth when sign in button is tapped', (WidgetTester tester) async {
      when(mockAuthProvider.isLoggedIn).thenReturn(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/auth': (context) => Scaffold(body: Text('Auth Page')),
            },
          ),
        ),
      );

      await tester.tap(find.text('Sign In to Track Progress'));
      await tester.pumpAndSettle();

      expect(find.text('Auth Page'), findsOneWidget);
    });

    testWidgets('should show logout dialog when logout button is tapped', (WidgetTester tester) async {
      when(mockAuthProvider.isLoggedIn).thenReturn(true);
      when(mockAuthProvider.displayName).thenReturn('Test User');
      when(mockAuthProvider.totalXP).thenReturn(0);
      when(mockAuthProvider.currentStreak).thenReturn(0);
      when(mockAuthProvider.lessonsCompleted).thenReturn(0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: HomePage(),
            routes: {
              '/auth': (context) => Scaffold(body: Text('Auth Page')),
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.text('Logout'), findsWidgets);
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}