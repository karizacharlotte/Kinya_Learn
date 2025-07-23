import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../data/language_lessons.dart';

class LessonProgressProvider extends ChangeNotifier {
  final Set<String> _completedLessons = {};
  final Set<String> _unlockedLessons = {};
  
  Set<String> get completedLessons => Set.unmodifiable(_completedLessons);
  Set<String> get unlockedLessons => Set.unmodifiable(_unlockedLessons);
  
  LessonProgressProvider() {
    _loadProgress();
  }

  /// Load lesson progress from local storage
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load completed lessons
      final completedList = prefs.getStringList('completed_lessons') ?? [];
      _completedLessons.addAll(completedList);
      
      // Load unlocked lessons
      final unlockedList = prefs.getStringList('unlocked_lessons') ?? ['greetings']; // First lesson always unlocked
      _unlockedLessons.addAll(unlockedList);
      
      // Update lesson objects
      _updateLessonStates();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading lesson progress: $e');
    }
  }

  /// Save lesson progress to local storage
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completed_lessons', _completedLessons.toList());
      await prefs.setStringList('unlocked_lessons', _unlockedLessons.toList());
    } catch (e) {
      debugPrint('Error saving lesson progress: $e');
    }
  }

  /// Update lesson objects with current state
  void _updateLessonStates() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    for (final lesson in lessons) {
      lesson.isCompleted = _completedLessons.contains(lesson.id);
      lesson.isUnlocked = _unlockedLessons.contains(lesson.id);
    }
  }

  /// Mark a lesson as completed
  Future<void> completeLesson(String lessonId) async {
    if (!_completedLessons.contains(lessonId)) {
      _completedLessons.add(lessonId);
      
      // Auto-unlock next lesson
      final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
      final currentIndex = lessons.indexWhere((lesson) => lesson.id == lessonId);
      
      if (currentIndex != -1 && currentIndex + 1 < lessons.length) {
        final nextLesson = lessons[currentIndex + 1];
        _unlockedLessons.add(nextLesson.id);
      }
      
      // Update lesson objects
      _updateLessonStates();
      
      // Save to storage
      await _saveProgress();
      
      notifyListeners();
    }
  }

  /// Unlock a specific lesson
  Future<void> unlockLesson(String lessonId) async {
    if (!_unlockedLessons.contains(lessonId)) {
      _unlockedLessons.add(lessonId);
      _updateLessonStates();
      await _saveProgress();
      notifyListeners();
    }
  }

  /// Check if a lesson is completed
  bool isLessonCompleted(String lessonId) {
    return _completedLessons.contains(lessonId);
  }

  /// Check if a lesson is unlocked
  bool isLessonUnlocked(String lessonId) {
    return _unlockedLessons.contains(lessonId);
  }

  /// Get overall progress percentage
  double get overallProgress {
    final totalLessons = KinyarwandaLanguageLessons.getLanguageLessons().length;
    if (totalLessons == 0) return 0.0;
    return _completedLessons.length / totalLessons;
  }

  /// Get the next lesson to take
  Lesson? getNextLesson() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    
    // Find the first unlocked but not completed lesson
    for (final lesson in lessons) {
      if (isLessonUnlocked(lesson.id) && !isLessonCompleted(lesson.id)) {
        return lesson;
      }
    }
    
    return null; // All lessons completed
  }

  /// Get completed lessons count
  int get completedLessonsCount => _completedLessons.length;

  /// Get total lessons count
  int get totalLessonsCount => KinyarwandaLanguageLessons.getLanguageLessons().length;

  /// Reset all progress (for testing or user request)
  Future<void> resetProgress() async {
    _completedLessons.clear();
    _unlockedLessons.clear();
    _unlockedLessons.add('greetings'); // Always unlock first lesson
    
    _updateLessonStates();
    await _saveProgress();
    notifyListeners();
  }

  /// Get lessons by completion status
  List<Lesson> getCompletedLessons() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    return lessons.where((lesson) => isLessonCompleted(lesson.id)).toList();
  }

  List<Lesson> getUnlockedLessons() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    return lessons.where((lesson) => isLessonUnlocked(lesson.id)).toList();
  }

  List<Lesson> getAvailableLessons() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    return lessons.where((lesson) => 
      isLessonUnlocked(lesson.id) && !isLessonCompleted(lesson.id)
    ).toList();
  }
}
