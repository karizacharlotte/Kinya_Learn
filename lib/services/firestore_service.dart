import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // LESSON MANAGEMENT

  /// Get all lessons with optional filtering
  static Future<List<LessonModel>> getLessons({
    String? category,
    int? level,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection('lessons');
      
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      
      if (level != null) {
        query = query.where('level', isEqualTo: level);
      }
      
      query = query.where('isActive', isEqualTo: true)
                  .orderBy('order');
      
      if (limit != null) {
        query = query.limit(limit);
      }

      QuerySnapshot snapshot = await query.get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LessonModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting lessons: $e');
      rethrow;
    }
  }

  /// Get lesson by ID
  static Future<LessonModel?> getLessonById(String lessonId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LessonModel.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting lesson: $e');
      rethrow;
    }
  }

  /// Get lessons by category
  static Future<List<LessonModel>> getLessonsByCategory(String category) async {
    return getLessons(category: category);
  }

  // CATEGORY MANAGEMENT

  /// Get all categories
  static Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }

  // USER PROGRESS MANAGEMENT

  /// Get user progress
  static Future<UserProgressModel?> getUserProgress(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('user_progress')
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserProgressModel.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user progress: $e');
      rethrow;
    }
  }

  /// Update user progress
  static Future<void> updateUserProgress({
    required String userId,
    int? totalLessonsCompleted,
    int? totalPoints,
    int? currentStreak,
    DateTime? lastActivityDate,
    Map<String, dynamic>? categoryProgress,
    Map<String, dynamic>? levelProgress,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'userId': userId,
        'lastActivityDate': lastActivityDate ?? FieldValue.serverTimestamp(),
      };

      if (totalLessonsCompleted != null) {
        updateData['totalLessonsCompleted'] = FieldValue.increment(totalLessonsCompleted);
      }

      if (totalPoints != null) {
        updateData['totalPoints'] = FieldValue.increment(totalPoints);
      }

      if (currentStreak != null) {
        updateData['currentStreak'] = currentStreak;
        
        // Update longest streak if current is higher
        DocumentSnapshot doc = await _firestore
            .collection('user_progress')
            .doc(userId)
            .get();
        
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int longestStreak = data['longestStreak'] ?? 0;
          if (currentStreak > longestStreak) {
            updateData['longestStreak'] = currentStreak;
          }
        }
      }

      if (categoryProgress != null) {
        updateData['categoryProgress'] = categoryProgress;
      }

      if (levelProgress != null) {
        updateData['levelProgress'] = levelProgress;
      }

      await _firestore
          .collection('user_progress')
          .doc(userId)
          .set(updateData, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user progress: $e');
      rethrow;
    }
  }

  // LESSON PROGRESS MANAGEMENT

  /// Save lesson progress
  static Future<void> saveLessonProgress({
    required String userId,
    required String lessonId,
    required LessonProgressStatus status,
    required int progress,
    required int pointsEarned,
    int? attemptsCount,
    List<Map<String, dynamic>>? exerciseResults,
  }) async {
    try {
      String docId = '${userId}_$lessonId';
      
      Map<String, dynamic> data = {
        'userId': userId,
        'lessonId': lessonId,
        'status': status.toString().split('.').last,
        'progress': progress,
        'pointsEarned': pointsEarned,
        'lastAccessedAt': FieldValue.serverTimestamp(),
      };

      if (attemptsCount != null) {
        data['attemptsCount'] = attemptsCount;
      }

      if (exerciseResults != null) {
        data['exerciseResults'] = exerciseResults;
      }

      if (status == LessonProgressStatus.completed && progress >= 100) {
        data['firstCompletedAt'] = FieldValue.serverTimestamp();
        
        // Update user progress
        await updateUserProgress(
          userId: userId,
          totalLessonsCompleted: 1,
          totalPoints: pointsEarned,
        );
      }

      await _firestore
          .collection('lesson_progress')
          .doc(docId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error saving lesson progress: $e');
      rethrow;
    }
  }

  /// Get lesson progress for user
  static Future<LessonProgressModel?> getLessonProgress(
      String userId, String lessonId) async {
    try {
      String docId = '${userId}_$lessonId';
      DocumentSnapshot doc = await _firestore
          .collection('lesson_progress')
          .doc(docId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LessonProgressModel.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting lesson progress: $e');
      rethrow;
    }
  }

  /// Get all lesson progress for user
  static Future<List<LessonProgressModel>> getAllLessonProgress(
      String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lesson_progress')
          .where('userId', isEqualTo: userId)
          .orderBy('lastAccessedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return LessonProgressModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting all lesson progress: $e');
      rethrow;
    }
  }

  // ACHIEVEMENT MANAGEMENT

  /// Get all achievements
  static Future<List<AchievementModel>> getAchievements() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('achievements')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AchievementModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting achievements: $e');
      rethrow;
    }
  }

  /// Unlock achievement for user
  static Future<void> unlockAchievement(
      String userId, String achievementId) async {
    try {
      String docId = '${userId}_$achievementId';
      
      // Check if already unlocked
      DocumentSnapshot existing = await _firestore
          .collection('user_achievements')
          .doc(docId)
          .get();

      if (!existing.exists) {
        await _firestore
            .collection('user_achievements')
            .doc(docId)
            .set({
          'userId': userId,
          'achievementId': achievementId,
          'unlockedAt': FieldValue.serverTimestamp(),
          'progress': 100,
        });

        // Award points for achievement
        DocumentSnapshot achievementDoc = await _firestore
            .collection('achievements')
            .doc(achievementId)
            .get();
        
        if (achievementDoc.exists) {
          Map<String, dynamic> data = achievementDoc.data() as Map<String, dynamic>;
          int points = data['points'] ?? 0;
          
          if (points > 0) {
            await updateUserProgress(
              userId: userId,
              totalPoints: points,
            );
          }
        }
      }
    } catch (e) {
      print('Error unlocking achievement: $e');
      rethrow;
    }
  }

  /// Get user achievements
  static Future<List<UserAchievementModel>> getUserAchievements(
      String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('user_achievements')
          .where('userId', isEqualTo: userId)
          .orderBy('unlockedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserAchievementModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting user achievements: $e');
      rethrow;
    }
  }

  // DAILY CHALLENGES

  /// Get today's daily challenge
  static Future<DailyChallengeModel?> getTodaysChallenge() async {
    try {
      String today = DateTime.now().toIso8601String().split('T')[0];
      DocumentSnapshot doc = await _firestore
          .collection('daily_challenges')
          .doc(today)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return DailyChallengeModel.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting today\'s challenge: $e');
      rethrow;
    }
  }

  // REAL-TIME STREAMS

  /// Stream user progress for real-time updates
  static Stream<DocumentSnapshot> streamUserProgress(String userId) {
    return _firestore.collection('user_progress').doc(userId).snapshots();
  }

  /// Stream lessons for real-time updates
  static Stream<QuerySnapshot> streamLessons({String? category}) {
    Query query = _firestore.collection('lessons')
        .where('isActive', isEqualTo: true)
        .orderBy('order');
    
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    
    return query.snapshots();
  }

  /// Stream user achievements for real-time updates
  static Stream<QuerySnapshot> streamUserAchievements(String userId) {
    return _firestore
        .collection('user_achievements')
        .where('userId', isEqualTo: userId)
        .orderBy('unlockedAt', descending: true)
        .snapshots();
  }

  // BATCH OPERATIONS

  /// Initialize user data (call after registration)
  static Future<void> initializeUserData(String userId, String email, String displayName) async {
    try {
      WriteBatch batch = _firestore.batch();

      // Create user document
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      batch.set(userRef, {
        'uid': userId,
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'totalPoints': 0,
        'currentLevel': 1,
        'completedLessons': [],
        'achievements': [],
        'streakDays': 0,
        'lastActivityDate': FieldValue.serverTimestamp(),
        'preferences': {
          'language': 'en',
          'soundEnabled': true,
          'notificationsEnabled': true,
          'theme': 'light',
        },
      });

      // Create user progress document
      DocumentReference progressRef = _firestore.collection('user_progress').doc(userId);
      batch.set(progressRef, {
        'userId': userId,
        'totalLessonsCompleted': 0,
        'totalPoints': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'lastActivityDate': FieldValue.serverTimestamp(),
        'levelProgress': {
          'currentLevel': 1,
          'pointsInCurrentLevel': 0,
          'pointsNeededForNextLevel': 100,
        },
        'categoryProgress': {},
      });

      await batch.commit();
    } catch (e) {
      print('Error initializing user data: $e');
      rethrow;
    }
  }
}
