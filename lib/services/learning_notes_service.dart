import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/learning_note.dart';

class LearningNotesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  static CollectionReference get _notesCollection => _firestore.collection('learning_notes');
  static CollectionReference get _goalsCollection => _firestore.collection('learning_goals');

  // LEARNING NOTES CRUD OPERATIONS

  /// Create a new learning note
  static Future<String> createNote({
    required String title,
    required String content,
    DateTime? deadline,
    Priority priority = Priority.medium,
    NoteCategory category = NoteCategory.general,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final noteData = LearningNote(
        id: '', // Will be set by Firestore
        userId: user.uid,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
        deadline: deadline,
        priority: priority,
        category: category,
        metadata: metadata ?? {},
      );

      final docRef = await _notesCollection.add(noteData.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  /// Get all notes for current user
  static Stream<List<LearningNote>> getUserNotes({
    NoteCategory? category,
    bool? isCompleted,
    Priority? priority,
  }) {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      Query query = _notesCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('updatedAt', descending: true);

      if (category != null) {
        query = query.where('category', isEqualTo: category.toString().split('.').last);
      }

      if (isCompleted != null) {
        query = query.where('isCompleted', isEqualTo: isCompleted);
      }

      if (priority != null) {
        query = query.where('priority', isEqualTo: priority.toString().split('.').last);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return LearningNote.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  /// Get a specific note by ID
  static Future<LearningNote?> getNoteById(String noteId) async {
    try {
      final doc = await _notesCollection.doc(noteId).get();
      if (doc.exists) {
        return LearningNote.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get note: $e');
    }
  }

  /// Update an existing note
  static Future<void> updateNote({
    required String noteId,
    String? title,
    String? content,
    DateTime? deadline,
    Priority? priority,
    NoteCategory? category,
    bool? isCompleted,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (title != null) updateData['title'] = title;
      if (content != null) updateData['content'] = content;
      if (deadline != null) {
        updateData['deadline'] = Timestamp.fromDate(deadline);
      }
      if (priority != null) {
        updateData['priority'] = priority.toString().split('.').last;
      }
      if (category != null) {
        updateData['category'] = category.toString().split('.').last;
      }
      if (isCompleted != null) updateData['isCompleted'] = isCompleted;
      if (metadata != null) updateData['metadata'] = metadata;

      await _notesCollection.doc(noteId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  /// Delete a note
  static Future<void> deleteNote(String noteId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Verify ownership before deletion
      final note = await getNoteById(noteId);
      if (note == null || note.userId != user.uid) {
        throw Exception('Note not found or access denied');
      }

      await _notesCollection.doc(noteId).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  /// Mark note as completed/uncompleted
  static Future<void> toggleNoteCompletion(String noteId) async {
    try {
      final note = await getNoteById(noteId);
      if (note == null) throw Exception('Note not found');

      await updateNote(
        noteId: noteId,
        isCompleted: !note.isCompleted,
      );
    } catch (e) {
      throw Exception('Failed to toggle note completion: $e');
    }
  }

  // LEARNING GOALS CRUD OPERATIONS

  /// Create a new learning goal
  static Future<String> createGoal({
    required String title,
    required String description,
    required DateTime targetDate,
    required GoalType type,
    required int targetValue,
    Map<String, dynamic>? milestones,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final goalData = LearningGoal(
        id: '', // Will be set by Firestore
        userId: user.uid,
        title: title,
        description: description,
        createdAt: now,
        updatedAt: now,
        targetDate: targetDate,
        type: type,
        targetValue: targetValue,
        milestones: milestones ?? {},
      );

      final docRef = await _goalsCollection.add(goalData.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create goal: $e');
    }
  }

  /// Get all goals for current user
  static Stream<List<LearningGoal>> getUserGoals({
    GoalType? type,
    bool? isCompleted,
  }) {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      Query query = _goalsCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('targetDate', descending: false);

      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }

      if (isCompleted != null) {
        query = query.where('isCompleted', isEqualTo: isCompleted);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return LearningGoal.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get goals: $e');
    }
  }

  /// Update goal progress
  static Future<void> updateGoalProgress({
    required String goalId,
    required int newProgress,
  }) async {
    try {
      final goal = await getGoalById(goalId);
      if (goal == null) throw Exception('Goal not found');

      final isCompleted = newProgress >= goal.targetValue;
      
      await _goalsCollection.doc(goalId).update({
        'currentProgress': newProgress,
        'isCompleted': isCompleted,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update goal progress: $e');
    }
  }

  /// Get a specific goal by ID
  static Future<LearningGoal?> getGoalById(String goalId) async {
    try {
      final doc = await _goalsCollection.doc(goalId).get();
      if (doc.exists) {
        return LearningGoal.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get goal: $e');
    }
  }

  /// Update an existing goal
  static Future<void> updateGoal({
    required String goalId,
    String? title,
    String? description,
    DateTime? targetDate,
    GoalType? type,
    int? targetValue,
    int? currentProgress,
    bool? isCompleted,
    Map<String, dynamic>? milestones,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (targetDate != null) {
        updateData['targetDate'] = Timestamp.fromDate(targetDate);
      }
      if (type != null) {
        updateData['type'] = type.toString().split('.').last;
      }
      if (targetValue != null) updateData['targetValue'] = targetValue;
      if (currentProgress != null) updateData['currentProgress'] = currentProgress;
      if (isCompleted != null) updateData['isCompleted'] = isCompleted;
      if (milestones != null) updateData['milestones'] = milestones;

      await _goalsCollection.doc(goalId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }

  /// Delete a goal
  static Future<void> deleteGoal(String goalId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Verify ownership before deletion
      final goal = await getGoalById(goalId);
      if (goal == null || goal.userId != user.uid) {
        throw Exception('Goal not found or access denied');
      }

      await _goalsCollection.doc(goalId).delete();
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }

  // ANALYTICS AND REPORTS

  /// Get notes statistics
  static Future<Map<String, dynamic>> getNotesStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await _notesCollection
          .where('userId', isEqualTo: user.uid)
          .get();

      int totalNotes = snapshot.docs.length;
      int completedNotes = 0;
      int overdueNotes = 0;
      int dueSoonNotes = 0;
      Map<String, int> categoryBreakdown = {};
      Map<String, int> priorityBreakdown = {};

      for (final doc in snapshot.docs) {
        final note = LearningNote.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        if (note.isCompleted) completedNotes++;
        if (note.isOverdue) overdueNotes++;
        if (note.isDueSoon) dueSoonNotes++;

        // Category breakdown
        final categoryKey = note.category.toString().split('.').last;
        categoryBreakdown[categoryKey] = (categoryBreakdown[categoryKey] ?? 0) + 1;

        // Priority breakdown
        final priorityKey = note.priority.toString().split('.').last;
        priorityBreakdown[priorityKey] = (priorityBreakdown[priorityKey] ?? 0) + 1;
      }

      return {
        'totalNotes': totalNotes,
        'completedNotes': completedNotes,
        'activeNotes': totalNotes - completedNotes,
        'overdueNotes': overdueNotes,
        'dueSoonNotes': dueSoonNotes,
        'completionRate': totalNotes > 0 ? (completedNotes / totalNotes * 100) : 0.0,
        'categoryBreakdown': categoryBreakdown,
        'priorityBreakdown': priorityBreakdown,
      };
    } catch (e) {
      throw Exception('Failed to get notes statistics: $e');
    }
  }

  /// Get goals statistics
  static Future<Map<String, dynamic>> getGoalsStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await _goalsCollection
          .where('userId', isEqualTo: user.uid)
          .get();

      int totalGoals = snapshot.docs.length;
      int completedGoals = 0;
      int overdueGoals = 0;
      double totalProgress = 0.0;
      Map<String, int> typeBreakdown = {};

      for (final doc in snapshot.docs) {
        final goal = LearningGoal.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        if (goal.isCompleted) completedGoals++;
        if (goal.isOverdue) overdueGoals++;
        totalProgress += goal.progressPercentage;

        // Type breakdown
        final typeKey = goal.type.toString().split('.').last;
        typeBreakdown[typeKey] = (typeBreakdown[typeKey] ?? 0) + 1;
      }

      return {
        'totalGoals': totalGoals,
        'completedGoals': completedGoals,
        'activeGoals': totalGoals - completedGoals,
        'overdueGoals': overdueGoals,
        'averageProgress': totalGoals > 0 ? (totalProgress / totalGoals) : 0.0,
        'completionRate': totalGoals > 0 ? (completedGoals / totalGoals * 100) : 0.0,
        'typeBreakdown': typeBreakdown,
      };
    } catch (e) {
      throw Exception('Failed to get goals statistics: $e');
    }
  }
}
