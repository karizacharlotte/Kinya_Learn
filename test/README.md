# KinyaLearn Test Suite

This directory contains comprehensive tests for the KinyaLearn app.

## Test Structure

### Unit Tests (`test/unit/`)
- `responsive_helper_test.dart` - Tests for responsive utility functions
- `auth_provider_test.dart` - Tests for authentication provider logic

### Widget Tests (`test/widgets/`)
- `rwandan_flag_test.dart` - Tests for the Rwandan flag widget
- `responsive_layout_test.dart` - Tests for responsive layout components
- `home_page_test.dart` - Tests for the home page widget

### Integration Tests (`test/integration/`)
- `app_integration_test.dart` - End-to-end app flow tests

## Running Tests

### Run all tests:
```bash
flutter test
```

### Run specific test files:
```bash
flutter test test/unit/responsive_helper_test.dart
flutter test test/widgets/home_page_test.dart
```

### Run integration tests:
```bash
flutter test integration_test/app_integration_test.dart
```

### Generate mocks (if needed):
```bash
flutter packages pub run build_runner build
```

## Test Coverage

To generate test coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Guidelines

1. **Unit Tests**: Test individual functions and classes in isolation
2. **Widget Tests**: Test widget rendering and user interactions
3. **Integration Tests**: Test complete user flows and app behavior
4. **Mock Dependencies**: Use mockito for external dependencies like Firebase
5. **Responsive Testing**: Test different screen sizes and orientations