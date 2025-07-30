import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _currentProfile;
  bool _isLoading = false;
  String? _error;
  List<UserProfile> _allProfiles = [];

  // Getters
  UserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<UserProfile> get allProfiles => _allProfiles;
  bool get hasProfile => _currentProfile != null;

  // CREATE: Create new user profile
  Future<bool> createProfile({
    required String uid,
    required String displayName,
    required String email,
    String? photoURL,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newProfile = UserProfile(
        uid: uid,
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        stats: UserStats(lastSessionDate: DateTime.now()), // Default stats with required field
        settings: UserSettings(), // Default settings
      );

      final success = await UserProfileService.createUserProfile(newProfile);
      
      if (success) {
        _currentProfile = newProfile;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to create profile');
        return false;
      }
    } catch (e) {
      _setError('Error creating profile: $e');
      return false;
    }
  }

  // READ: Load current user profile
  Future<void> loadCurrentProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await UserProfileService.getCurrentUserProfile();
      _currentProfile = profile;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error loading profile: $e');
      _setLoading(false);
    }
  }

  // READ: Load specific user profile
  Future<UserProfile?> loadUserProfile(String uid) async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await UserProfileService.getUserProfile(uid);
      _setLoading(false);
      return profile;
    } catch (e) {
      _setError('Error loading user profile: $e');
      _setLoading(false);
      return null;
    }
  }

  // UPDATE: Update profile information
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    if (_currentProfile == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final success = await UserProfileService.updateCurrentUserProfile(updates);
      
      if (success) {
        // Update local profile data
        await loadCurrentProfile(); // Reload to get updated data
        return true;
      } else {
        _setError('Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Error updating profile: $e');
      return false;
    }
  }

  // UPDATE: Update specific fields
  Future<bool> updateDisplayName(String newName) async {
    return await updateProfile({'displayName': newName});
  }

  Future<bool> updateProfilePhoto(String photoURL) async {
    return await updateProfile({'photoURL': photoURL});
  }

  Future<bool> updateStats({
    int? totalXP,
    int? lessonsCompleted,
    int? currentStreak,
    int? maxStreak,
  }) async {
    if (_currentProfile == null) return false;

    final currentStats = _currentProfile!.stats;
    final updatedStats = currentStats.copyWith(
      totalXP: totalXP,
      lessonsCompleted: lessonsCompleted,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      lastSessionDate: DateTime.now(),
    );

    return await updateProfile({'stats': updatedStats.toMap()});
  }

  Future<bool> updateSettings({
    bool? notifications,
    String? preferredLanguage,
    bool? darkMode,
    bool? soundEnabled,
    int? dailyGoal,
  }) async {
    if (_currentProfile == null) return false;

    final currentSettings = _currentProfile!.settings;
    final updatedSettings = currentSettings.copyWith(
      notifications: notifications,
      preferredLanguage: preferredLanguage,
      darkMode: darkMode,
      soundEnabled: soundEnabled,
      dailyGoal: dailyGoal,
    );

    return await updateProfile({'settings': updatedSettings.toMap()});
  }

  // DELETE: Soft delete profile (can be restored)
  Future<bool> softDeleteProfile() async {
    if (_currentProfile == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final success = await UserProfileService.softDeleteUserProfile(_currentProfile!.uid);
      
      if (success) {
        // Don't clear current profile immediately for confirmation
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete profile');
        return false;
      }
    } catch (e) {
      _setError('Error deleting profile: $e');
      return false;
    }
  }

  // DELETE: Permanent delete (cannot be restored)
  Future<bool> permanentDeleteProfile() async {
    if (_currentProfile == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final success = await UserProfileService.hardDeleteUserProfile(_currentProfile!.uid);
      
      if (success) {
        _currentProfile = null;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to permanently delete profile');
        return false;
      }
    } catch (e) {
      _setError('Error permanently deleting profile: $e');
      return false;
    }
  }

  // RESTORE: Restore soft deleted profile
  Future<bool> restoreProfile(String uid) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await UserProfileService.restoreUserProfile(uid);
      
      if (success) {
        await loadCurrentProfile(); // Reload restored profile
        return true;
      } else {
        _setError('Failed to restore profile');
        return false;
      }
    } catch (e) {
      _setError('Error restoring profile: $e');
      return false;
    }
  }

  // ADMIN: Load all profiles
  Future<void> loadAllProfiles({bool includeDeleted = false}) async {
    _setLoading(true);
    _clearError();

    try {
      _allProfiles = await UserProfileService.getAllUserProfiles(includeDeleted: includeDeleted);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error loading all profiles: $e');
      _setLoading(false);
    }
  }

  // BACKUP: Create backup of current profile
  Future<bool> backupCurrentProfile() async {
    if (_currentProfile == null) return false;

    try {
      return await UserProfileService.backupUserProfile(_currentProfile!.uid);
    } catch (e) {
      _setError('Error creating backup: $e');
      return false;
    }
  }

  // ANALYTICS: Get user analytics
  Future<Map<String, dynamic>?> getUserAnalytics() async {
    if (_currentProfile == null) return null;

    try {
      return await UserProfileService.getUserAnalytics(_currentProfile!.uid);
    } catch (e) {
      _setError('Error getting analytics: $e');
      return null;
    }
  }

  // STREAM: Listen to real-time profile updates
  Stream<UserProfile?> getCurrentProfileStream() {
    return UserProfileService.getCurrentUserProfileStream();
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearProfile() {
    _currentProfile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Add XP to user
  Future<bool> addXP(int xp) async {
    if (_currentProfile == null) return false;
    
    final newTotalXP = _currentProfile!.stats.totalXP + xp;
    return await updateStats(totalXP: newTotalXP);
  }

  // Complete a lesson
  Future<bool> completeLesson(String lessonId, double score) async {
    if (_currentProfile == null) return false;

    final currentStats = _currentProfile!.stats;
    final newLessonsCompleted = currentStats.lessonsCompleted + 1;
    
    // Update XP based on score (e.g., 100 points for perfect score)
    final xpGained = (score * 100).round();
    final newTotalXP = currentStats.totalXP + xpGained;

    return await updateStats(
      totalXP: newTotalXP,
      lessonsCompleted: newLessonsCompleted,
    );
  }
}
