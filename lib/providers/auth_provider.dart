import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  /// Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_user == null) {
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseService.getUserDocument(_user!.uid);
      if (doc.exists) {
        _userData = doc.data() as Map<String, dynamic>?;
      } else {
        // Initialize user data if document doesn't exist
        await FirestoreService.initializeUserData(
            _user!.uid, _user!.email ?? '', _user!.displayName ?? 'User');
        // Reload the data after initialization
        doc = await FirebaseService.getUserDocument(_user!.uid);
        if (doc.exists) {
          _userData = doc.data() as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    notifyListeners();
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential? result = await FirebaseService.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      );

      if (result != null) {
        _user = result.user;
        await _loadUserData();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential? result = await FirebaseService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (result != null) {
        _user = result.user;
        await _loadUserData();

        // Update last login time
        if (_user != null) {
          await FirebaseService.updateUserProgress(uid: _user!.uid);
        }

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await FirebaseService.signOut();
      _user = null;
      _userData = null;
    } catch (e) {
      _setError('Error signing out');
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await FirebaseService.resetPassword(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential? result = await FirebaseService.signInWithGoogle();

      if (result != null) {
        _user = result.user;
        await _loadUserData();

        // Update last login time
        if (_user != null) {
          await FirebaseService.updateUserProgress(uid: _user!.uid);
        }

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Failed to sign in with Google');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update user progress
  Future<void> updateProgress({
    int? lessonsCompleted,
    int? xpGained,
    int? currentStreak,
  }) async {
    if (_user == null) {
      return;
    }

    try {
      await FirebaseService.updateUserProgress(
        uid: _user!.uid,
        lessonsCompleted: lessonsCompleted,
        xpGained: xpGained,
        currentStreak: currentStreak,
      );

      // Reload user data to reflect changes
      await _loadUserData();
    } catch (e) {
      print('Error updating progress: $e');
    }
  }

  /// Save lesson completion
  Future<void> completLesson({
    required String lessonId,
    required String lessonTitle,
    required double completionPercentage,
    required int xpEarned,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_user == null) {
      return;
    }

    try {
      await FirebaseService.saveLessonProgress(
        uid: _user!.uid,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        completionPercentage: completionPercentage,
        xpEarned: xpEarned,
        additionalData: additionalData,
      );

      // Reload user data to reflect progress changes
      await _loadUserData();
    } catch (e) {
      print('Error completing lesson: $e');
    }
  }

  /// Save quiz result
  Future<void> saveQuizResult({
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required int timeSpent,
    Map<String, dynamic>? answers,
  }) async {
    if (_user == null) {
      return;
    }

    try {
      await FirebaseService.saveQuizResult(
        uid: _user!.uid,
        quizId: quizId,
        quizTitle: quizTitle,
        score: score,
        totalQuestions: totalQuestions,
        timeSpent: timeSpent,
        answers: answers,
      );

      // Reload user data to reflect XP changes
      await _loadUserData();
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  /// Get user's total XP
  int get totalXP =>
      _userData?['progress']?['totalXP'] ?? _userData?['totalPoints'] ?? 0;

  /// Get user's current streak
  int get currentStreak =>
      _userData?['progress']?['currentStreak'] ?? _userData?['streakDays'] ?? 0;

  /// Get user's lessons completed count
  int get lessonsCompleted =>
      _userData?['progress']?['lessonsCompleted'] ??
      _userData?['totalLessonsCompleted'] ??
      0;

  /// Get user's display name
  String get displayName =>
      _user?.displayName ??
      _userData?['displayName'] ??
      _userData?['name'] ??
      'User';

  /// Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
