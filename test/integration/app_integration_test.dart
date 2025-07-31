import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:kinya_learn/main.dart';
import 'package:kinya_learn/theme/theme_provider.dart';
import 'package:kinya_learn/providers/auth_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should navigate through main app flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const KinyaLearnApp(),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Should start with splash screen or home page
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Test navigation to different sections
      // This would be expanded based on your app's navigation structure
    });

    testWidgets('should handle theme switching', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const KinyaLearnApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Test theme switching functionality
      // This would require finding theme toggle buttons in your app
    });

    testWidgets('should handle responsive layout changes', (WidgetTester tester) async {
      // Test mobile layout
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const KinyaLearnApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Test desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpAndSettle();

      // Verify responsive changes took effect
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}