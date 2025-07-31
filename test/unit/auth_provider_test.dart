import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinya_learn/providers/auth_provider.dart';

@GenerateMocks([FirebaseAuth, User])
import 'auth_provider_test.mocks.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      authProvider = AuthProvider();
    });

    test('should initialize with no user', () {
      expect(authProvider.user, isNull);
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.isLoading, false);
      expect(authProvider.errorMessage, isNull);
    });

    test('should return correct display name', () {
      when(mockUser.displayName).thenReturn('Test User');
      authProvider.user = mockUser;
      expect(authProvider.displayName, 'Test User');
    });

    test('should return default values for user stats', () {
      expect(authProvider.totalXP, 0);
      expect(authProvider.currentStreak, 0);
      expect(authProvider.lessonsCompleted, 0);
    });

    test('should handle loading state correctly', () {
      expect(authProvider.isLoading, false);
      // Test loading state changes would require mocking Firebase methods
    });

    test('should clear error message', () {
      // This would test the private _clearError method through public methods
      expect(authProvider.errorMessage, isNull);
    });
  });
}