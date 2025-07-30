import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _userId => _auth.currentUser?.uid;

  // ===================
  // NOTES CRUD
  // ===================

  static Future<String?> createNote({
    required String lessonId,
    required String title,
    required String content,
    List<String> tags = const [],
  }) async {
    if (_userId == null) return null;

    try {
      final docRef = await _firestore.collection('student_notes').add({
        'userId': _userId,
        'lessonId': lessonId,
        'title': title,
        'content': content,
        'tags': tags,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
      return docRef.id;
    } catch (e) {
      print('Error creating note: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserNotes() async {
    if (_userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('student_notes')
          .where('userId', isEqualTo: _userId)
          .get();

      final notes = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      notes.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return notes;
    } catch (e) {
      print('Error getting notes: $e');
      return [];
    }
  }

  // Alias for backward compatibility
  static Future<List<Map<String, dynamic>>> getUserNotesSimple() => getUserNotes();

  // For lesson-specific notes, filter in memory
  static Future<List<Map<String, dynamic>>> getLessonNotes(String lessonId) async {
    final allNotes = await getUserNotes();
    return allNotes.where((note) => note['lessonId'] == lessonId).toList();
  }

  // Simple search implementation
  static Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    final allNotes = await getUserNotes();
    return allNotes.where((note) {
      final title = note['title']?.toString().toLowerCase() ?? '';
      final content = note['content']?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase()) || content.contains(query.toLowerCase());
    }).toList();
  }

  static Future<bool> updateNote(String noteId, {
    String? title,
    String? content,
    List<String>? tags,
    bool? isFavorite,
  }) async {
    if (_userId == null) return false;

    try {
      final updates = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
      if (title != null) updates['title'] = title;
      if (content != null) updates['content'] = content;
      if (tags != null) updates['tags'] = tags;
      if (isFavorite != null) updates['isFavorite'] = isFavorite;

      await _firestore.collection('student_notes').doc(noteId).update(updates);
      return true;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  static Future<bool> deleteNote(String noteId) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('student_notes').doc(noteId).delete();
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  // ===================
  // LEARNING GOALS
  // ===================

  static Future<bool> setLearningGoals({
    int? dailyLessons,
    int? weeklyGoal,
    int? monthlyGoal,
    String? targetLevel,
    List<String>? focusAreas,
    DateTime? targetDate,
  }) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('learning_goals').doc(_userId).set({
        'userId': _userId,
        'dailyLessons': dailyLessons ?? 3,
        'weeklyGoal': weeklyGoal ?? 21,
        'monthlyGoal': monthlyGoal ?? 90,
        'targetLevel': targetLevel ?? 'Intermediate',
        'focusAreas': focusAreas ?? ['vocabulary', 'pronunciation'],
        'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error setting goals: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getLearningGoals() async {
    if (_userId == null) return null;

    try {
      final doc = await _firestore.collection('learning_goals').doc(_userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting goals: $e');
      return null;
    }
  }

  // Simple daily progress implementation
  static Future<Map<String, dynamic>> getDailyProgress() async {
    final goals = await getLearningGoals();
    final dailyGoal = goals?['dailyLessons'] ?? 3;
    
    return {
      'completedToday': 0, // Simplified for now
      'dailyGoal': dailyGoal,
      'progress': 0.0,
      'goalAchieved': false,
    };
  }

  // ===================
  // VOCABULARY
  // ===================

  static Future<bool> addVocabulary({
    required String word,
    required String translation,
    required String pronunciation,
    String? definition,
    String? example,
  }) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('vocabulary').add({
        'userId': _userId,
        'word': word,
        'translation': translation,
        'pronunciation': pronunciation,
        'definition': definition,
        'example': example,
        'createdAt': FieldValue.serverTimestamp(),
        'mastered': false,
      });
      return true;
    } catch (e) {
      print('Error adding vocabulary: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getVocabulary() async {
    if (_userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('vocabulary')
          .where('userId', isEqualTo: _userId)
          .get();

      final vocabulary = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      vocabulary.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return vocabulary;
    } catch (e) {
      print('Error getting vocabulary: $e');
      return [];
    }
  }

  static Future<bool> updateVocabulary(String vocabId, Map<String, dynamic> updates) async {
    if (_userId == null) return false;

    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('vocabulary').doc(vocabId).update(updates);
      return true;
    } catch (e) {
      print('Error updating vocabulary: $e');
      return false;
    }
  }

  static Future<bool> deleteVocabulary(String vocabId) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('vocabulary').doc(vocabId).delete();
      return true;
    } catch (e) {
      print('Error deleting vocabulary: $e');
      return false;
    }
  }

  // Helper method for marking vocabulary as mastered
  static Future<bool> markVocabularyMastered(String vocabId, bool mastered) async {
    return updateVocabulary(vocabId, {'mastered': mastered});
  }

  // ===================
  // BOOKMARKS
  // ===================

  static Future<bool> addBookmark(String lessonId) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('bookmarks').doc('${_userId}_$lessonId').set({
        'userId': _userId,
        'lessonId': lessonId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error adding bookmark: $e');
      return false;
    }
  }

  static Future<bool> removeBookmark(String lessonId) async {
    if (_userId == null) return false;

    try {
      await _firestore.collection('bookmarks').doc('${_userId}_$lessonId').delete();
      return true;
    } catch (e) {
      print('Error removing bookmark: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    if (_userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('bookmarks')
          .where('userId', isEqualTo: _userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting bookmarks: $e');
      return [];
    }
  }
}
