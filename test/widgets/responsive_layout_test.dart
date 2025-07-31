import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/utils/responsive_layout.dart';

void main() {
  group('ResponsiveLayout Widget Tests', () {
    testWidgets('ResponsiveContainer should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveContainer(
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveContainer), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('ResponsiveText should render with correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              'Test Text',
              type: ResponsiveTextType.header,
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveText), findsOneWidget);
      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('ResponsiveButton should be tappable', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              onPressed: () => wasPressed = true,
              child: Text('Tap Me'),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveButton), findsOneWidget);
      expect(find.text('Tap Me'), findsOneWidget);
      
      await tester.tap(find.byType(ResponsiveButton));
      expect(wasPressed, true);
    });

    testWidgets('ResponsiveCard should render child content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveCard), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('ResponsiveGrid should render children', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              children: [
                Container(child: Text('Item 1')),
                Container(child: Text('Item 2')),
                Container(child: Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveGrid), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });
  });
}