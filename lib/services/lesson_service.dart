import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_models.dart';

class LessonService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lesson Management

  /// Get all lessons ordered by sequence
  static Future<List<LessonModel>> getAllLessons() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lessons')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting lessons: $e');
      return [];
    }
  }

  /// Get lessons by category
  static Future<List<LessonModel>> getLessonsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lessons')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting lessons by category: $e');
      return [];
    }
  }

  /// Get lessons by level
  static Future<List<LessonModel>> getLessonsByLevel(String level) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lessons')
          .where('level', isEqualTo: level)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting lessons by level: $e');
      return [];
    }
  }

  /// Get a specific lesson
  static Future<LessonModel?> getLesson(String lessonId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (doc.exists) {
        return LessonModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting lesson: $e');
      return null;
    }
  }

  // Section Management

  /// Get sections for a lesson
  static Future<List<SectionModel>> getLessonSections(String lessonId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .collection('sections')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => SectionModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting lesson sections: $e');
      return [];
    }
  }

  /// Get a specific section
  static Future<SectionModel?> getSection(String lessonId, String sectionId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .collection('sections')
          .doc(sectionId)
          .get();

      if (doc.exists) {
        return SectionModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting section: $e');
      return null;
    }
  }

  // Quiz Management

  /// Get quiz for a lesson
  static Future<QuizModel?> getLessonQuiz(String lessonId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('quizzes')
          .where('lessonId', isEqualTo: lessonId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return QuizModel.fromFirestore(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      print('Error getting lesson quiz: $e');
      return null;
    }
  }

  /// Get quiz by ID
  static Future<QuizModel?> getQuiz(String quizId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('quizzes')
          .doc(quizId)
          .get();

      if (doc.exists) {
        return QuizModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting quiz: $e');
      return null;
    }
  }

  // Progress Management

  /// Save section progress
  static Future<bool> saveSectionProgress({
    required String lessonId,
    required String sectionId,
    required double completionPercentage,
    int score = 0,
    int timeSpent = 0,
    Map<String, dynamic> answers = const {},
  }) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    try {
      String progressId = '${currentUser.uid}_${lessonId}_$sectionId';
      
      ProgressModel progress = ProgressModel(
        userId: currentUser.uid,
        lessonId: lessonId,
        sectionId: sectionId,
        completionPercentage: completionPercentage,
        score: score,
        timeSpent: timeSpent,
        startedAt: DateTime.now(),
        completedAt: completionPercentage >= 100 ? DateTime.now() : null,
        answers: answers,
      );

      await _firestore
          .collection('progress')
          .doc(progressId)
          .set(progress.toFirestore(), SetOptions(merge: true));

      // Update user progress
      if (completionPercentage >= 100) {
        await _updateUserLessonProgress(currentUser.uid, lessonId, score);
      }

      return true;
    } catch (e) {
      print('Error saving section progress: $e');
      return false;
    }
  }

  /// Get user progress for a lesson
  static Future<List<ProgressModel>> getUserLessonProgress(String lessonId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: currentUser.uid)
          .where('lessonId', isEqualTo: lessonId)
          .get();

      return snapshot.docs
          .map((doc) => ProgressModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting user lesson progress: $e');
      return [];
    }
  }

  /// Get user's overall progress
  static Future<Map<String, dynamic>> getUserOverallProgress() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return {};

    try {
      // Get user document
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return {
          'xpPoints': userData['xpPoints'] ?? 0,
          'currentStreak': userData['currentStreak'] ?? 0,
          'maxStreak': userData['maxStreak'] ?? 0,
          'completedLessons': List<String>.from(userData['completedLessons'] ?? []),
          'progress': userData['progress'] ?? {},
        };
      }
      return {};
    } catch (e) {
      print('Error getting user overall progress: $e');
      return {};
    }
  }

  /// Check if lesson is unlocked for user
  static Future<bool> isLessonUnlocked(String lessonId, int lessonOrder) async {
    // First lesson is always unlocked
    if (lessonOrder <= 1) return true;

    User? currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    try {
      // Get user's completed lessons
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<String> completedLessons = List<String>.from(userData['completedLessons'] ?? []);
        
        // Get previous lesson
        QuerySnapshot previousLessons = await _firestore
            .collection('lessons')
            .where('order', isLessThan: lessonOrder)
            .orderBy('order', descending: true)
            .limit(1)
            .get();

        if (previousLessons.docs.isNotEmpty) {
          String previousLessonId = previousLessons.docs.first.id;
          return completedLessons.contains(previousLessonId);
        }
      }
      return false;
    } catch (e) {
      print('Error checking lesson unlock status: $e');
      return false;
    }
  }

  /// Private helper method to update user lesson progress
  static Future<void> _updateUserLessonProgress(String userId, String lessonId, int score) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userRef);
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          List<String> completedLessons = List<String>.from(userData['completedLessons'] ?? []);
          Map<String, dynamic> progress = Map<String, dynamic>.from(userData['progress'] ?? {});
          
          // Add lesson to completed if not already there
          if (!completedLessons.contains(lessonId)) {
            completedLessons.add(lessonId);
          }
          
          // Update lesson progress
          progress[lessonId] = {
            'score': score,
            'completed': true,
            'completedAt': Timestamp.now(),
          };
          
          // Calculate XP (example: 50 base XP + score bonus)
          int xpGained = 50 + (score ~/ 10);
          int currentXP = userData['xpPoints'] ?? 0;
          
          transaction.update(userRef, {
            'completedLessons': completedLessons,
            'progress': progress,
            'xpPoints': currentXP + xpGained,
            'lastActive': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      print('Error updating user lesson progress: $e');
    }
  }

  // Statistics and Analytics

  /// Get lesson completion statistics
  static Future<Map<String, dynamic>> getLessonStats(String lessonId) async {
    try {
      QuerySnapshot progressQuery = await _firestore
          .collection('progress')
          .where('lessonId', isEqualTo: lessonId)
          .where('completionPercentage', isGreaterThanOrEqualTo: 100)
          .get();

      int completions = progressQuery.docs.length;
      double averageScore = 0;
      
      if (completions > 0) {
        int totalScore = progressQuery.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .map((data) => data['score'] as int? ?? 0)
            .reduce((a, b) => a + b);
        averageScore = totalScore / completions;
      }

      return {
        'completions': completions,
        'averageScore': averageScore,
      };
    } catch (e) {
      print('Error getting lesson stats: $e');
      return {'completions': 0, 'averageScore': 0.0};
    }
  }

  // Content Management (for future admin features)

  /// Create a new lesson (admin only)
  static Future<String?> createLesson(LessonModel lesson) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('lessons')
          .add(lesson.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating lesson: $e');
      return null;
    }
  }

  /// Create a new section (admin only)
  static Future<String?> createSection(String lessonId, SectionModel section) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('lessons')
          .doc(lessonId)
          .collection('sections')
          .add(section.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating section: $e');
      return null;
    }
  }

  /// Create a new quiz (admin only)
  static Future<String?> createQuiz(QuizModel quiz) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('quizzes')
          .add(quiz.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating quiz: $e');
      return null;
    }
  }

  // Real-time streams for reactive UI

  /// Stream lessons for real-time updates
  static Stream<List<LessonModel>> streamLessons() {
    return _firestore
        .collection('lessons')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LessonModel.fromFirestore(
                doc.data(), doc.id))
            .toList());
  }

  /// Stream user progress for real-time updates
  static Stream<List<ProgressModel>> streamUserProgress() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('progress')
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressModel.fromFirestore(
                doc.data(), doc.id))
            .toList());
  }
}
