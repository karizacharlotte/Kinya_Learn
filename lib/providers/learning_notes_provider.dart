import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/learning_note.dart';
import '../services/learning_notes_service.dart';

class LearningNotesProvider extends ChangeNotifier {
  List<LearningNote> _notes = [];
  List<LearningGoal> _goals = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _notesStats = {};
  Map<String, dynamic> _goalsStats = {};

  // Filters
  NoteCategory? _selectedNoteCategory;
  Priority? _selectedNotePriority;
  bool? _showCompletedNotes;
  GoalType? _selectedGoalType;
  bool? _showCompletedGoals;

  // Getters
  List<LearningNote> get notes => _notes;
  List<LearningGoal> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get notesStats => _notesStats;
  Map<String, dynamic> get goalsStats => _goalsStats;

  // Filter getters
  NoteCategory? get selectedNoteCategory => _selectedNoteCategory;
  Priority? get selectedNotePriority => _selectedNotePriority;
  bool? get showCompletedNotes => _showCompletedNotes;
  GoalType? get selectedGoalType => _selectedGoalType;
  bool? get showCompletedGoals => _showCompletedGoals;

  // Filtered lists
  List<LearningNote> get filteredNotes {
    return _notes.where((note) {
      bool categoryMatch = _selectedNoteCategory == null || note.category == _selectedNoteCategory;
      bool priorityMatch = _selectedNotePriority == null || note.priority == _selectedNotePriority;
      bool completionMatch = _showCompletedNotes == null || note.isCompleted == _showCompletedNotes;
      return categoryMatch && priorityMatch && completionMatch;
    }).toList();
  }

  List<LearningGoal> get filteredGoals {
    return _goals.where((goal) {
      bool typeMatch = _selectedGoalType == null || goal.type == _selectedGoalType;
      bool completionMatch = _showCompletedGoals == null || goal.isCompleted == _showCompletedGoals;
      return typeMatch && completionMatch;
    }).toList();
  }

  // Quick access lists
  List<LearningNote> get overdueNotes => _notes.where((note) => note.isOverdue).toList();
  List<LearningNote> get dueSoonNotes => _notes.where((note) => note.isDueSoon).toList();
  List<LearningGoal> get overdueGoals => _goals.where((goal) => goal.isOverdue).toList();

  // Authentication helper
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  // Initialize and load data
  Future<void> initialize() async {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _error = 'Please log in to access learning notes and goals';
      _setLoading(false);
      notifyListeners();
      return;
    }
    
    await loadNotes();
    await loadGoals();
    await loadStatistics();
  }

  // NOTES OPERATIONS

  /// Load notes with current filters
  Future<void> loadNotes() async {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _error = 'Please log in to access your notes';
      _setLoading(false);
      notifyListeners();
      return;
    }
    
    try {
      _setLoading(true);
      _error = null;

      LearningNotesService.getUserNotes(
        category: _selectedNoteCategory,
        isCompleted: _showCompletedNotes,
        priority: _selectedNotePriority,
      ).listen(
        (notes) {
          _notes = notes;
          _setLoading(false);
          notifyListeners();
        },
        onError: (error) {
          _error = 'Failed to load notes: $error';
          _setLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to load notes: $e';
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Create a new note
  Future<String?> createNote({
    required String title,
    required String content,
    DateTime? deadline,
    Priority priority = Priority.medium,
    NoteCategory category = NoteCategory.general,
    Map<String, dynamic>? metadata,
  }) async {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _error = 'Please log in to create notes';
      notifyListeners();
      return null;
    }
    
    try {
      _setLoading(true);
      _error = null;

      final noteId = await LearningNotesService.createNote(
        title: title,
        content: content,
        deadline: deadline,
        priority: priority,
        category: category,
        metadata: metadata,
      );

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return noteId;
    } catch (e) {
      _error = 'Failed to create note: $e';
      _setLoading(false);
      notifyListeners();
      return null;
    }
  }

  /// Update an existing note
  Future<bool> updateNote({
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
      _setLoading(true);
      _error = null;

      await LearningNotesService.updateNote(
        noteId: noteId,
        title: title,
        content: content,
        deadline: deadline,
        priority: priority,
        category: category,
        isCompleted: isCompleted,
        metadata: metadata,
      );

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to update note: $e';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Delete a note
  Future<bool> deleteNote(String noteId) async {
    try {
      _setLoading(true);
      _error = null;

      await LearningNotesService.deleteNote(noteId);

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to delete note: $e';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Toggle note completion
  Future<void> toggleNoteCompletion(String noteId) async {
    try {
      await LearningNotesService.toggleNoteCompletion(noteId);
      // Statistics will be refreshed when the stream updates
    } catch (e) {
      _error = 'Failed to toggle note completion: $e';
      notifyListeners();
    }
  }

  // GOALS OPERATIONS

  /// Load goals with current filters
  Future<void> loadGoals() async {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _error = 'Please log in to access your goals';
      _setLoading(false);
      notifyListeners();
      return;
    }
    
    try {
      _setLoading(true);
      _error = null;

      LearningNotesService.getUserGoals(
        type: _selectedGoalType,
        isCompleted: _showCompletedGoals,
      ).listen(
        (goals) {
          _goals = goals;
          _setLoading(false);
          notifyListeners();
        },
        onError: (error) {
          _error = 'Failed to load goals: $error';
          _setLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to load goals: $e';
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Create a new goal
  Future<String?> createGoal({
    required String title,
    required String description,
    required DateTime targetDate,
    required GoalType type,
    required int targetValue,
    Map<String, dynamic>? milestones,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      final goalId = await LearningNotesService.createGoal(
        title: title,
        description: description,
        targetDate: targetDate,
        type: type,
        targetValue: targetValue,
        milestones: milestones,
      );

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return goalId;
    } catch (e) {
      _error = 'Failed to create goal: $e';
      _setLoading(false);
      notifyListeners();
      return null;
    }
  }

  /// Update goal progress
  Future<bool> updateGoalProgress({
    required String goalId,
    required int newProgress,
  }) async {
    try {
      await LearningNotesService.updateGoalProgress(
        goalId: goalId,
        newProgress: newProgress,
      );

      // Refresh statistics
      await loadStatistics();
      
      return true;
    } catch (e) {
      _error = 'Failed to update goal progress: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing goal
  Future<bool> updateGoal({
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
      _setLoading(true);
      _error = null;

      await LearningNotesService.updateGoal(
        goalId: goalId,
        title: title,
        description: description,
        targetDate: targetDate,
        type: type,
        targetValue: targetValue,
        currentProgress: currentProgress,
        isCompleted: isCompleted,
        milestones: milestones,
      );

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to update goal: $e';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Delete a goal
  Future<bool> deleteGoal(String goalId) async {
    try {
      _setLoading(true);
      _error = null;

      await LearningNotesService.deleteGoal(goalId);

      // Refresh statistics
      await loadStatistics();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to delete goal: $e';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // FILTER OPERATIONS

  /// Set note category filter
  void setNoteCategory(NoteCategory? category) {
    if (_selectedNoteCategory != category) {
      _selectedNoteCategory = category;
      notifyListeners();
      loadNotes(); // Reload with new filter
    }
  }

  /// Set note priority filter
  void setNotePriority(Priority? priority) {
    if (_selectedNotePriority != priority) {
      _selectedNotePriority = priority;
      notifyListeners();
      loadNotes(); // Reload with new filter
    }
  }

  /// Set show completed notes filter
  void setShowCompletedNotes(bool? show) {
    if (_showCompletedNotes != show) {
      _showCompletedNotes = show;
      notifyListeners();
      loadNotes(); // Reload with new filter
    }
  }

  /// Set goal type filter
  void setGoalType(GoalType? type) {
    if (_selectedGoalType != type) {
      _selectedGoalType = type;
      notifyListeners();
      loadGoals(); // Reload with new filter
    }
  }

  /// Set show completed goals filter
  void setShowCompletedGoals(bool? show) {
    if (_showCompletedGoals != show) {
      _showCompletedGoals = show;
      notifyListeners();
      loadGoals(); // Reload with new filter
    }
  }

  /// Clear all filters
  void clearFilters() {
    _selectedNoteCategory = null;
    _selectedNotePriority = null;
    _showCompletedNotes = null;
    _selectedGoalType = null;
    _showCompletedGoals = null;
    notifyListeners();
    loadNotes();
    loadGoals();
  }

  // STATISTICS

  /// Load statistics for notes and goals
  Future<void> loadStatistics() async {
    try {
      final notesStats = await LearningNotesService.getNotesStatistics();
      final goalsStats = await LearningNotesService.getGoalsStatistics();
      
      _notesStats = notesStats;
      _goalsStats = goalsStats;
      notifyListeners();
    } catch (e) {
      // Don't show error for statistics - they're supplementary
      _notesStats = {};
      _goalsStats = {};
    }
  }

  // UTILITY METHODS

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get note by ID
  LearningNote? getNoteById(String noteId) {
    try {
      return _notes.firstWhere((note) => note.id == noteId);
    } catch (e) {
      return null;
    }
  }

  /// Get goal by ID
  LearningGoal? getGoalById(String goalId) {
    try {
      return _goals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      return null;
    }
  }
}
