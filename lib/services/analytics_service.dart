import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Track user engagement
  static Future<void> trackUserEngagement({
    required String action,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final eventData = {
        'userId': userId,
        'action': action,
        'properties': properties ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'platform': _getPlatform(),
      };

      await _firestore.collection('analytics_events').add(eventData);
    } catch (e) {
      // Silently fail - analytics shouldn't break the app
    }
  }

  // Track lesson start
  static Future<void> trackLessonStart(String lessonId) async {
    await trackUserEngagement(
      action: 'lesson_start',
      properties: {
        'lessonId': lessonId,
      },
    );
  }

  // Track lesson completion
  static Future<void> trackLessonCompletion({
    required String lessonId,
    required int score,
    required double completionPercentage,
    required int timeSpentSeconds,
  }) async {
    await trackUserEngagement(
      action: 'lesson_completion',
      properties: {
        'lessonId': lessonId,
        'score': score,
        'completionPercentage': completionPercentage,
        'timeSpentSeconds': timeSpentSeconds,
      },
    );
  }

  // Track quiz performance
  static Future<void> trackQuizPerformance({
    required String lessonId,
    required String sectionId,
    required int score,
    required int totalQuestions,
    required List<bool> answers,
  }) async {
    await trackUserEngagement(
      action: 'quiz_completion',
      properties: {
        'lessonId': lessonId,
        'sectionId': sectionId,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctAnswers': answers.where((answer) => answer).length,
        'accuracy': (answers.where((answer) => answer).length / totalQuestions) * 100,
      },
    );
  }

  // Track video engagement
  static Future<void> trackVideoEngagement({
    required String videoId,
    required String action, // play, pause, complete, seek
    int? position,
    int? duration,
  }) async {
    await trackUserEngagement(
      action: 'video_$action',
      properties: {
        'videoId': videoId,
        'position': position,
        'duration': duration,
        'completionRate': position != null && duration != null ? (position / duration) * 100 : null,
      },
    );
  }

  // Track audio engagement
  static Future<void> trackAudioEngagement({
    required String audioId,
    required String action, // play, pause, complete
    int? playCount,
  }) async {
    await trackUserEngagement(
      action: 'audio_$action',
      properties: {
        'audioId': audioId,
        'playCount': playCount,
      },
    );
  }

  // Track user retention
  static Future<void> trackUserRetention() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('user_retention')
          .doc('${userId}_$dateKey')
          .set({
        'userId': userId,
        'date': dateKey,
        'timestamp': FieldValue.serverTimestamp(),
        'dayOfWeek': today.weekday,
        'weekOfYear': _getWeekOfYear(today),
      }, SetOptions(merge: true));
    } catch (e) {
      // Silently fail
    }
  }

  // Track feature usage
  static Future<void> trackFeatureUsage(String featureName, {Map<String, dynamic>? metadata}) async {
    await trackUserEngagement(
      action: 'feature_usage',
      properties: {
        'feature': featureName,
        'metadata': metadata ?? {},
      },
    );
  }

  // Track app session
  static Future<void> trackAppSession({
    required String sessionId,
    required String action, // start, end
    int? durationSeconds,
  }) async {
    await trackUserEngagement(
      action: 'app_session_$action',
      properties: {
        'sessionId': sessionId,
        'durationSeconds': durationSeconds,
      },
    );
  }

  // Get user learning analytics
  static Future<Map<String, dynamic>> getUserLearningAnalytics(String userId) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30)); // Last 30 days

      // Get user events
      final eventsQuery = await _firestore
          .collection('analytics_events')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp', descending: true)
          .get();

      Map<String, int> dailyActivity = {};
      Map<String, int> actionCounts = {};
      Map<String, double> averageScores = {};
      int totalTimeSpent = 0;
      int totalLessons = 0;

      for (final doc in eventsQuery.docs) {
        final data = doc.data();
        final action = data['action'] as String;
        final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
        final properties = data['properties'] as Map<String, dynamic>? ?? {};

        if (timestamp != null) {
          final dateKey = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
          dailyActivity[dateKey] = (dailyActivity[dateKey] ?? 0) + 1;
        }

        actionCounts[action] = (actionCounts[action] ?? 0) + 1;

        if (action == 'lesson_completion') {
          final score = properties['score'] as int? ?? 0;
          final timeSpent = properties['timeSpentSeconds'] as int? ?? 0;
          
          averageScores[action] = ((averageScores[action] ?? 0) + score) / 2;
          totalTimeSpent += timeSpent;
          totalLessons++;
        }
      }

      // Calculate streak
      int currentStreak = _calculateStreak(dailyActivity);

      // Get most active day
      String mostActiveDay = _getMostActiveDay(dailyActivity);

      // Get favorite lesson category
      String favoriteCategory = await _getFavoriteCategory(userId);

      return {
        'dailyActivity': dailyActivity,
        'actionCounts': actionCounts,
        'averageScores': averageScores,
        'totalTimeSpent': totalTimeSpent,
        'totalLessons': totalLessons,
        'currentStreak': currentStreak,
        'mostActiveDay': mostActiveDay,
        'favoriteCategory': favoriteCategory,
        'averageSessionTime': totalLessons > 0 ? totalTimeSpent / totalLessons : 0,
      };
    } catch (e) {
      return {};
    }
  }

  // Get app-wide analytics (for admins)
  static Future<Map<String, dynamic>> getAppAnalytics() async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30));

      // Get total users
      final usersQuery = await _firestore.collection('users').get();
      final totalUsers = usersQuery.docs.length;

      // Get active users (last 30 days)
      final activeUsersQuery = await _firestore
          .collection('analytics_events')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .get();

      Set<String> activeUserIds = {};
      Map<String, int> lessonPopularity = {};
      Map<String, double> averageScores = {};
      int totalSessions = 0;

      for (final doc in activeUsersQuery.docs) {
        final data = doc.data();
        final userId = data['userId'] as String;
        final action = data['action'] as String;
        final properties = data['properties'] as Map<String, dynamic>? ?? {};

        activeUserIds.add(userId);

        if (action == 'lesson_start') {
          final lessonId = properties['lessonId'] as String?;
          if (lessonId != null) {
            lessonPopularity[lessonId] = (lessonPopularity[lessonId] ?? 0) + 1;
          }
        }

        if (action == 'lesson_completion') {
          final score = properties['score'] as int? ?? 0;
          final lessonId = properties['lessonId'] as String? ?? 'unknown';
          averageScores[lessonId] = ((averageScores[lessonId] ?? 0) + score) / 2;
        }

        if (action.startsWith('app_session_')) {
          totalSessions++;
        }
      }

      // Calculate retention rate
      double retentionRate = totalUsers > 0 ? (activeUserIds.length / totalUsers) * 100 : 0;

      return {
        'totalUsers': totalUsers,
        'activeUsers': activeUserIds.length,
        'retentionRate': retentionRate,
        'lessonPopularity': lessonPopularity,
        'averageScores': averageScores,
        'totalSessions': totalSessions,
      };
    } catch (e) {
      return {};
    }
  }

  // Helper methods
  static String _getPlatform() {
    // You can use Platform.isAndroid, Platform.isIOS, etc.
    // For now, return 'flutter'
    return 'flutter';
  }

  static int _getWeekOfYear(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static int _calculateStreak(Map<String, int> dailyActivity) {
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dateKey = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
      
      if (dailyActivity.containsKey(dateKey) && dailyActivity[dateKey]! > 0) {
        streak++;
      } else if (i > 0) { // Allow for today to not have activity yet
        break;
      }
    }

    return streak;
  }

  static String _getMostActiveDay(Map<String, int> dailyActivity) {
    if (dailyActivity.isEmpty) return 'No data';

    var sortedEntries = dailyActivity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }

  static Future<String> _getFavoriteCategory(String userId) async {
    try {
      final progressQuery = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, int> categoryCount = {};

      for (final doc in progressQuery.docs) {
        final data = doc.data();
        final lessonId = data['lessonId'] as String;
        
        // Get lesson category
        final lessonDoc = await _firestore.collection('lessons').doc(lessonId).get();
        if (lessonDoc.exists) {
          final category = lessonDoc.data()?['category'] as String? ?? 'other';
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }

      if (categoryCount.isEmpty) return 'No favorite yet';

      var sortedCategories = categoryCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedCategories.first.key;
    } catch (e) {
      return 'Unknown';
    }
  }

  // Clean old analytics data (call periodically)
  static Future<void> cleanOldAnalyticsData({int daysToKeep = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      final oldEventsQuery = await _firestore
          .collection('analytics_events')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      for (final doc in oldEventsQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Silently fail
    }
  }
}
