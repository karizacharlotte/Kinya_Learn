import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'user_profiles';

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // CREATE: Add new user profile
  static Future<bool> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(profile.uid)
          .set(profile.toFirestore());
      
      print('✅ User profile created successfully: ${profile.uid}');
      return true;
    } catch (e) {
      print('❌ Error creating user profile: $e');
      return false;
    }
  }

  // READ: Get user profile by ID
  static Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  // READ: Get current user's profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    if (currentUserId == null) return null;
    return await getUserProfile(currentUserId!);
  }

  // UPDATE: Update user profile
  static Future<bool> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      // Add timestamp for when it was updated
      updates['lastUpdated'] = FieldValue.serverTimestamp();
      
      await _firestore
          .collection(_collection)
          .doc(uid)
          .update(updates);
      
      print('✅ User profile updated successfully: $uid');
      return true;
    } catch (e) {
      print('❌ Error updating user profile: $e');
      return false;
    }
  }

  // UPDATE: Update current user's profile
  static Future<bool> updateCurrentUserProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return false;
    return await updateUserProfile(currentUserId!, updates);
  }

  // DELETE: Soft delete (mark as deleted but keep data)
  static Future<bool> softDeleteUserProfile(String uid) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(uid)
          .update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ User profile soft deleted: $uid');
      return true;
    } catch (e) {
      print('❌ Error soft deleting user profile: $e');
      return false;
    }
  }

  // DELETE: Hard delete (permanent removal)
  static Future<bool> hardDeleteUserProfile(String uid) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(uid)
          .delete();
      
      print('✅ User profile permanently deleted: $uid');
      return true;
    } catch (e) {
      print('❌ Error permanently deleting user profile: $e');
      return false;
    }
  }

  // RESTORE: Restore soft deleted profile
  static Future<bool> restoreUserProfile(String uid) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(uid)
          .update({
        'isDeleted': FieldValue.delete(),
        'deletedAt': FieldValue.delete(),
        'restoredAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ User profile restored: $uid');
      return true;
    } catch (e) {
      print('❌ Error restoring user profile: $e');
      return false;
    }
  }

  // READ: Get all user profiles (admin function)
  static Future<List<UserProfile>> getAllUserProfiles({bool includeDeleted = false}) async {
    try {
      Query query = _firestore.collection(_collection);
      
      if (!includeDeleted) {
        query = query.where('isDeleted', isNotEqualTo: true);
      }
      
      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('❌ Error fetching all user profiles: $e');
      return [];
    }
  }

  // ADVANCED: Batch update multiple profiles
  static Future<bool> batchUpdateProfiles(Map<String, Map<String, dynamic>> updates) async {
    try {
      final batch = _firestore.batch();
      
      updates.forEach((uid, updateData) {
        updateData['lastUpdated'] = FieldValue.serverTimestamp();
        final docRef = _firestore.collection(_collection).doc(uid);
        batch.update(docRef, updateData);
      });
      
      await batch.commit();
      print('✅ Batch update completed for ${updates.length} profiles');
      return true;
    } catch (e) {
      print('❌ Error in batch update: $e');
      return false;
    }
  }

  // STREAM: Real-time user profile updates
  static Stream<UserProfile?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc.data()!, uid);
      }
      return null;
    });
  }

  // STREAM: Real-time current user profile updates
  static Stream<UserProfile?> getCurrentUserProfileStream() {
    if (currentUserId == null) {
      return Stream.value(null);
    }
    return getUserProfileStream(currentUserId!);
  }

  // ANALYTICS: Get user statistics
  static Future<Map<String, dynamic>> getUserAnalytics(String uid) async {
    try {
      final profile = await getUserProfile(uid);
      if (profile == null) return {};

      return {
        'totalXP': profile.stats.totalXP,
        'lessonsCompleted': profile.stats.lessonsCompleted, // Correct property name
        'currentStreak': profile.stats.currentStreak, // Correct property name
        'maxStreak': profile.stats.maxStreak, // Correct property name
        'achievementsUnlocked': profile.stats.achievementsUnlocked,
        'avgSessionTime': profile.stats.avgSessionTime,
        'lastActive': profile.lastLoginAt,
        'accountAge': DateTime.now().difference(profile.createdAt).inDays,
        'lastSessionDate': profile.stats.lastSessionDate,
      };
    } catch (e) {
      print('❌ Error getting user analytics: $e');
      return {};
    }
  }

  // BACKUP: Create backup of user data
  static Future<bool> backupUserProfile(String uid) async {
    try {
      final profile = await getUserProfile(uid);
      if (profile == null) return false;

      await _firestore
          .collection('user_backups')
          .doc('${uid}_${DateTime.now().millisecondsSinceEpoch}')
          .set({
        ...profile.toFirestore(),
        'backupCreatedAt': FieldValue.serverTimestamp(),
        'originalUid': uid,
      });
      
      print('✅ User profile backup created: $uid');
      return true;
    } catch (e) {
      print('❌ Error creating backup: $e');
      return false;
    }
  }
}
