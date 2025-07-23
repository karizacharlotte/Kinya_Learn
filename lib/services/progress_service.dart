import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_models.dart';
import 'user_service.dart';

class ProgressTrackingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Record lesson completion
  static Future<void> recordLessonCompletion({
    required String lessonId,
    required double completionPercentage,
    required int score,
    required int timeSpentSeconds,
    Map<String, dynamic>? sectionScores,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final progressData = {
        'userId': userId,
        'lessonId': lessonId,
        'completionPercentage': completionPercentage,
        'score': score,
        'timeSpentSeconds': timeSpentSeconds,
        'sectionScores': sectionScores ?? {},
        'completedAt': FieldValue.serverTimestamp(),
        'attempts': 1,
      };

      // Check if progress already exists
      final existingProgress = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('lessonId', isEqualTo: lessonId)
          .get();

      if (existingProgress.docs.isNotEmpty) {
        // Update existing progress
        final doc = existingProgress.docs.first;
        final currentData = doc.data();
        
        progressData['attempts'] = (currentData['attempts'] ?? 0) + 1;
        
        // Keep best score
        if ((currentData['score'] ?? 0) > score) {
          progressData['score'] = currentData['score'];
        }
        
        // Keep best completion percentage
        if ((currentData['completionPercentage'] ?? 0.0) > completionPercentage) {
          progressData['completionPercentage'] = currentData['completionPercentage'];
        }
        
        await doc.reference.update(progressData);
      } else {
        // Create new progress record
        await _firestore.collection('progress').add(progressData);
      }

      // Update user statistics
      await UserService.updateUserStats(
        userId: userId,
        xpGained: _calculateXP(score, completionPercentage),
        lessonsCompleted: completionPercentage >= 100.0 ? 1 : 0,
        accuracy: score.toDouble(),
        maintainStreak: await _checkStreakMaintenance(userId),
      );

      // Check for achievements
      await _checkAndAwardAchievements(userId, lessonId, score, completionPercentage);

    } catch (e) {
      throw Exception('Failed to record lesson completion: $e');
    }
  }

  // Record section progress
  static Future<void> recordSectionProgress({
    required String lessonId,
    required String sectionId,
    required double completionPercentage,
    required int score,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final sectionProgressData = {
        'userId': userId,
        'lessonId': lessonId,
        'sectionId': sectionId,
        'completionPercentage': completionPercentage,
        'score': score,
        'completedAt': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
      };

      await _firestore
          .collection('progress')
          .doc('${userId}_${lessonId}_${sectionId}')
          .set(sectionProgressData, SetOptions(merge: true));

    } catch (e) {
      throw Exception('Failed to record section progress: $e');
    }
  }

  // Get user's overall progress
  static Future<Map<String, dynamic>> getUserOverallProgress(String userId) async {
    try {
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      final userStats = await UserService.getUserStats(userId);
      
      int totalLessons = 0;
      int completedLessons = 0;
      double totalScore = 0;
      int totalTimeSpent = 0;
      Map<String, int> categoryProgress = {};

      for (final doc in progressQuery.docs) {
        final data = doc.data();
        totalLessons++;
        
        if ((data['completionPercentage'] ?? 0.0) >= 100.0) {
          completedLessons++;
        }
        
        totalScore += (data['score'] ?? 0).toDouble();
        totalTimeSpent += (data['timeSpentSeconds'] ?? 0) as int;
        
        // Get lesson category for category progress
        final lessonId = data['lessonId'];
        final lessonDoc = await _firestore.collection('lessons').doc(lessonId).get();
        if (lessonDoc.exists) {
          final category = lessonDoc.data()?['category'] ?? 'other';
          categoryProgress[category] = (categoryProgress[category] ?? 0) + 1;
        }
      }

      final averageScore = totalLessons > 0 ? totalScore / totalLessons : 0.0;
      final completionRate = totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0.0;

      return {
        'totalLessons': totalLessons,
        'completedLessons': completedLessons,
        'completionRate': completionRate,
        'averageScore': averageScore,
        'totalTimeSpent': totalTimeSpent,
        'categoryProgress': categoryProgress,
        'userStats': userStats,
        'streak': userStats['streakDays'] ?? 0,
        'level': userStats['level'] ?? 'Beginner',
        'xp': userStats['totalXP'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get user progress: $e');
    }
  }

  // Get lesson progress for a specific lesson
  static Future<ProgressModel?> getLessonProgress(String lessonId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('lessonId', isEqualTo: lessonId)
          .get();

      if (progressQuery.docs.isNotEmpty) {
        final data = progressQuery.docs.first.data();
        return ProgressModel.fromFirestore(data, progressQuery.docs.first.id);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get progress for multiple lessons
  static Future<List<ProgressModel>> getUserLessonProgress(String userId) async {
    try {
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .get();

      return progressQuery.docs.map((doc) {
        return ProgressModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Get daily progress
  static Future<Map<String, dynamic>> getDailyProgress(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final todayProgressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();

      int lessonsToday = todayProgressQuery.docs.length;
      int totalTimeToday = 0;
      double totalScoreToday = 0;

      for (final doc in todayProgressQuery.docs) {
        final data = doc.data();
        totalTimeToday += (data['timeSpentSeconds'] ?? 0) as int;
        totalScoreToday += (data['score'] ?? 0).toDouble();
      }

      final averageScoreToday = lessonsToday > 0 ? totalScoreToday / lessonsToday : 0.0;

      // Get daily goal
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final dailyGoal = userDoc.data()?['learningGoals']?['dailyLessons'] ?? 3;

      return {
        'lessonsCompleted': lessonsToday,
        'dailyGoal': dailyGoal,
        'goalProgress': lessonsToday / dailyGoal,
        'timeSpent': totalTimeToday,
        'averageScore': averageScoreToday,
        'goalAchieved': lessonsToday >= dailyGoal,
      };
    } catch (e) {
      return {
        'lessonsCompleted': 0,
        'dailyGoal': 3,
        'goalProgress': 0.0,
        'timeSpent': 0,
        'averageScore': 0.0,
        'goalAchieved': false,
      };
    }
  }

  // Get weekly progress
  static Future<Map<String, dynamic>> getWeeklyProgress(String userId) async {
    try {
      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      
      final weekProgressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeekDay))
          .get();

      Map<String, int> dailyLessons = {};
      int totalLessonsWeek = weekProgressQuery.docs.length;

      for (final doc in weekProgressQuery.docs) {
        final data = doc.data();
        final completedAt = (data['completedAt'] as Timestamp).toDate();
        final dayKey = '${completedAt.year}-${completedAt.month}-${completedAt.day}';
        dailyLessons[dayKey] = (dailyLessons[dayKey] ?? 0) + 1;
      }

      // Get weekly goal
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final weeklyGoal = userDoc.data()?['learningGoals']?['weeklyGoal'] ?? 21;

      return {
        'lessonsCompleted': totalLessonsWeek,
        'weeklyGoal': weeklyGoal,
        'goalProgress': totalLessonsWeek / weeklyGoal,
        'dailyBreakdown': dailyLessons,
        'goalAchieved': totalLessonsWeek >= weeklyGoal,
      };
    } catch (e) {
      return {
        'lessonsCompleted': 0,
        'weeklyGoal': 21,
        'goalProgress': 0.0,
        'dailyBreakdown': {},
        'goalAchieved': false,
      };
    }
  }

  // Calculate XP based on score and completion
  static int _calculateXP(int score, double completionPercentage) {
    int baseXP = (score * 0.1).round(); // Base XP from score
    int completionBonus = completionPercentage >= 100.0 ? 50 : 0; // Completion bonus
    int perfectScoreBonus = score >= 100 ? 25 : 0; // Perfect score bonus
    
    return baseXP + completionBonus + perfectScoreBonus;
  }

  // Check if user maintains streak
  static Future<bool> _checkStreakMaintenance(String userId) async {
    try {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final startOfYesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
      final endOfYesterday = startOfYesterday.add(const Duration(days: 1));
      
      final yesterdayProgressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYesterday))
          .where('completedAt', isLessThan: Timestamp.fromDate(endOfYesterday))
          .get();

      return yesterdayProgressQuery.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check and award achievements
  static Future<void> _checkAndAwardAchievements(
    String userId, 
    String lessonId, 
    int score, 
    double completionPercentage,
  ) async {
    try {
      final userStats = await UserService.getUserStats(userId);
      final achievements = userStats['achievements'] as List? ?? [];

      // First lesson completion
      if (userStats['lessonsCompleted'] == 1 && !achievements.contains('first_lesson')) {
        await UserService.addAchievement(userId, 'first_lesson');
      }

      // Perfect score achievement
      if (score >= 100 && !achievements.contains('perfect_score')) {
        await UserService.addAchievement(userId, 'perfect_score');
      }

      // 10 lessons milestone
      if (userStats['lessonsCompleted'] >= 10 && !achievements.contains('lesson_master_10')) {
        await UserService.addAchievement(userId, 'lesson_master_10');
      }

      // 7-day streak achievement
      if (userStats['streakDays'] >= 7 && !achievements.contains('streak_7')) {
        await UserService.addAchievement(userId, 'streak_7');
      }

      // High XP achievement
      if (userStats['totalXP'] >= 1000 && !achievements.contains('xp_master_1000')) {
        await UserService.addAchievement(userId, 'xp_master_1000');
      }

    } catch (e) {
      // Ignore achievement errors
    }
  }

  // Delete user progress
  static Future<void> deleteUserProgress(String userId) async {
    try {
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in progressQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user progress: $e');
    }
  }
}
