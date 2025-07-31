import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinya_learn/utils/responsive_helper.dart';

void main() {
  group('ResponsiveHelper Tests', () {
    testWidgets('should detect mobile screen correctly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(ResponsiveHelper.isMobile(context), true);
            expect(ResponsiveHelper.isTablet(context), false);
            expect(ResponsiveHelper.isDesktop(context), false);
            return Container();
          },
        ),
      ));
    });

    testWidgets('should detect tablet screen correctly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 600));
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(ResponsiveHelper.isMobile(context), false);
            expect(ResponsiveHelper.isTablet(context), true);
            expect(ResponsiveHelper.isDesktop(context), false);
            return Container();
          },
        ),
      ));
    });

    testWidgets('should detect desktop screen correctly', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(ResponsiveHelper.isMobile(context), false);
            expect(ResponsiveHelper.isTablet(context), false);
            expect(ResponsiveHelper.isDesktop(context), true);
            return Container();
          },
        ),
      ));
    });

    testWidgets('should return correct responsive values', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800)); // Mobile
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(ResponsiveHelper.getResponsiveValue(context, mobile: 10, tablet: 20, desktop: 30), 10);
            expect(ResponsiveHelper.getResponsiveHeaderFontSize(context), 24);
            expect(ResponsiveHelper.getResponsiveTitleFontSize(context), 20);
            expect(ResponsiveHelper.getResponsiveBodyFontSize(context), 14);
            return Container();
          },
        ),
      ));
    });
  });
}