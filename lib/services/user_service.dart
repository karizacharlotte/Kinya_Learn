import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_models.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create or update user profile
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
    String level = 'Beginner',
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final userData = {
        'email': email,
        'displayName': displayName ?? email.split('@')[0],
        'photoURL': photoURL,
        'level': level,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'streakDays': 0,
        'totalXP': 0,
        'lessonsCompleted': 0,
        'accuracy': 0.0,
        'preferences': preferences ?? {
          'notifications': true,
          'soundEnabled': true,
          'darkMode': false,
          'language': 'en',
          'culturalContent': true,
        },
        'learningGoals': {
          'dailyLessons': 3,
          'weeklyGoal': 21,
          'targetLevel': 'Advanced',
          'focusAreas': ['vocabulary', 'pronunciation', 'culture'],
        },
        'achievements': [],
        'badges': [],
      };

      await _firestore.collection('users').doc(userId).set(userData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Get user profile
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Update user profile
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Update user statistics
  static Future<void> updateUserStats({
    required String userId,
    int? xpGained,
    int? lessonsCompleted,
    double? accuracy,
    bool? maintainStreak,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (xpGained != null) {
        updates['totalXP'] = FieldValue.increment(xpGained);
      }
      
      if (lessonsCompleted != null) {
        updates['lessonsCompleted'] = FieldValue.increment(lessonsCompleted);
      }
      
      if (accuracy != null) {
        // Calculate new accuracy average
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final currentAccuracy = userDoc.data()?['accuracy'] ?? 0.0;
          final totalLessons = userDoc.data()?['lessonsCompleted'] ?? 1;
          final newAccuracy = ((currentAccuracy * (totalLessons - 1)) + accuracy) / totalLessons;
          updates['accuracy'] = newAccuracy;
        }
      }
      
      if (maintainStreak == true) {
        updates['streakDays'] = FieldValue.increment(1);
        updates['lastStreakDate'] = FieldValue.serverTimestamp();
      } else if (maintainStreak == false) {
        updates['streakDays'] = 0;
      }
      
      updates['lastActivityAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  // Add achievement to user
  static Future<void> addAchievement(String userId, String achievementId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'achievements': FieldValue.arrayUnion([achievementId]),
        'badges': FieldValue.arrayUnion([{
          'id': achievementId,
          'earnedAt': FieldValue.serverTimestamp(),
        }]),
      });
    } catch (e) {
      throw Exception('Failed to add achievement: $e');
    }
  }

  // Update learning preferences
  static Future<void> updateLearningPreferences(String userId, Map<String, dynamic> preferences) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'preferences': preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }

  // Update learning goals
  static Future<void> updateLearningGoals(String userId, Map<String, dynamic> goals) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'learningGoals': goals,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update learning goals: $e');
    }
  }

  // Get user's learning statistics
  static Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return {
          'totalXP': 0,
          'lessonsCompleted': 0,
          'accuracy': 0.0,
          'streakDays': 0,
          'achievements': [],
          'level': 'Beginner',
        };
      }

      final userData = userDoc.data()!;
      
      // Calculate level based on XP
      final totalXP = userData['totalXP'] ?? 0;
      String level = 'Beginner';
      if (totalXP >= 5000) {
        level = 'Advanced';
      } else if (totalXP >= 2000) {
        level = 'Intermediate';
      }
      
      return {
        'totalXP': totalXP,
        'lessonsCompleted': userData['lessonsCompleted'] ?? 0,
        'accuracy': userData['accuracy'] ?? 0.0,
        'streakDays': userData['streakDays'] ?? 0,
        'achievements': userData['achievements'] ?? [],
        'badges': userData['badges'] ?? [],
        'level': level,
        'learningGoals': userData['learningGoals'] ?? {},
        'preferences': userData['preferences'] ?? {},
      };
    } catch (e) {
      throw Exception('Failed to get user stats: $e');
    }
  }

  // Delete user account
  static Future<void> deleteUserAccount(String userId) async {
    try {
      // Delete user data from Firestore
      await _firestore.collection('users').doc(userId).delete();
      
      // Delete user progress
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();
      
      for (final doc in progressQuery.docs) {
        await doc.reference.delete();
      }
      
      // Delete Firebase Auth user
      final user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user account: $e');
    }
  }

  // Check if user completed daily goal
  static Future<bool> checkDailyGoalCompletion(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final dailyGoal = userDoc.data()?['learningGoals']?['dailyLessons'] ?? 3;
      
      return progressQuery.docs.length >= dailyGoal;
    } catch (e) {
      return false;
    }
  }

  // Get user leaderboard position
  static Future<Map<String, dynamic>> getUserLeaderboardData(String userId) async {
    try {
      // Get users sorted by XP
      final leaderboardQuery = await _firestore
          .collection('users')
          .orderBy('totalXP', descending: true)
          .limit(100)
          .get();
      
      int position = 1;
      for (final doc in leaderboardQuery.docs) {
        if (doc.id == userId) {
          return {
            'position': position,
            'totalUsers': leaderboardQuery.docs.length,
            'xp': doc.data()['totalXP'] ?? 0,
          };
        }
        position++;
      }
      
      return {
        'position': position,
        'totalUsers': leaderboardQuery.docs.length,
        'xp': 0,
      };
    } catch (e) {
      return {
        'position': 0,
        'totalUsers': 0,
        'xp': 0,
      };
    }
  }

  // Update last login
  static Future<void> updateLastLogin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore error if user document doesn't exist yet
    }
  }
}
