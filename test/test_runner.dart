import 'package:flutter_test/flutter_test.dart';

// Unit Tests
import 'unit/responsive_helper_test.dart' as responsive_helper_test;
import 'unit/auth_provider_test.dart' as auth_provider_test;

// Widget Tests  
import 'widgets/rwandan_flag_test.dart' as rwandan_flag_test;
import 'widgets/responsive_layout_test.dart' as responsive_layout_test;
import 'widgets/home_page_test.dart' as home_page_test;

void main() {
  group('Unit Tests', () {
    responsive_helper_test.main();
    auth_provider_test.main();
  });

  group('Widget Tests', () {
    rwandan_flag_test.main();
    responsive_layout_test.main();
    home_page_test.main();
  });
}