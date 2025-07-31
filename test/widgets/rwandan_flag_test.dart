import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/widgets/rwandan_flag.dart';

void main() {
  group('RwandanFlag Widget Tests', () {
    testWidgets('should render with default dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RwandanFlag(),
          ),
        ),
      );

      expect(find.byType(RwandanFlag), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should render with custom dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RwandanFlag(
              width: 200,
              height: 133,
            ),
          ),
        ),
      );

      expect(find.byType(RwandanFlag), findsOneWidget);
      
      final containerWidget = tester.widget<Container>(find.byType(Container).first);
      expect(containerWidget.constraints?.maxWidth, 200);
    });

    testWidgets('should have correct flag colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RwandanFlag(),
          ),
        ),
      );

      // Find containers with Rwanda flag colors
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      bool hasBlue = false;
      bool hasYellow = false;
      bool hasGreen = false;
      
      for (final container in containers) {
        final color = container.color;
        if (color == const Color(0xFF00A1DE)) hasBlue = true;
        if (color == const Color(0xFFFAD201)) hasYellow = true;
        if (color == const Color(0xFF00A651)) hasGreen = true;
      }
      
      expect(hasBlue, true, reason: 'Should contain Rwanda blue color');
      expect(hasYellow, true, reason: 'Should contain Rwanda yellow color');
      expect(hasGreen, true, reason: 'Should contain Rwanda green color');
    });
  });
}