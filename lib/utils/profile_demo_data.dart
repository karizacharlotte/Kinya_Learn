import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';

class ProfileDemoData {
  static Future<void> createDemoProfiles() async {
    final demoProfiles = [
      {
        'uid': 'demo_user_1',
        'displayName': 'John Doe',
        'email': 'john.doe@example.com',
        'photoURL': null,
        'stats': {
          'totalXP': 1250,
          'lessonsCompleted': 12,
          'currentStreak': 5,
          'maxStreak': 10,
          'achievementsUnlocked': 3,
          'avgSessionTime': 25.5,
        },
        'settings': {
          'notifications': true,
          'soundEnabled': true,
          'dailyGoal': 30,
          'preferredLanguage': 'en',
          'darkMode': false,
          'speechRate': 1.0,
        },
      },
      {
        'uid': 'demo_user_2',
        'displayName': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'photoURL': null,
        'stats': {
          'totalXP': 2100,
          'lessonsCompleted': 18,
          'currentStreak': 8,
          'maxStreak': 15,
          'achievementsUnlocked': 5,
          'avgSessionTime': 32.0,
        },
        'settings': {
          'notifications': true,
          'soundEnabled': false,
          'dailyGoal': 45,
          'preferredLanguage': 'rw',
          'darkMode': true,
          'speechRate': 0.8,
        },
      },
    ];

    for (final profileData in demoProfiles) {
      try {
        await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(profileData['uid'] as String)
            .set({
          'displayName': profileData['displayName'],
          'email': profileData['email'],
          'photoURL': profileData['photoURL'],
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'stats': profileData['stats'],
          'settings': profileData['settings'],
          'preferences': {},
        });
        
        print('✅ Created demo profile: ${profileData['displayName']}');
      } catch (e) {
        print('❌ Error creating demo profile: $e');
      }
    }
  }

  static Future<void> testCRUDOperations() async {
    print('\n🧪 TESTING FIREBASE CRUD OPERATIONS...\n');

    try {
      // Test CREATE
      print('📝 Testing CREATE operation...');
      final testProfile = UserProfile(
        uid: 'test_user_${DateTime.now().millisecondsSinceEpoch}',
        displayName: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        stats: UserStats(lastSessionDate: DateTime.now()),
        settings: UserSettings(),
      );
      
      final createSuccess = await UserProfileService.createUserProfile(testProfile);
      print(createSuccess ? '✅ CREATE: Success' : '❌ CREATE: Failed');

      if (createSuccess) {
        // Test READ
        print('\n📖 Testing READ operation...');
        final retrievedProfile = await UserProfileService.getUserProfile(testProfile.uid);
        print(retrievedProfile != null ? '✅ READ: Success' : '❌ READ: Failed');

        if (retrievedProfile != null) {
          // Test UPDATE
          print('\n🔄 Testing UPDATE operation...');
          final updateSuccess = await UserProfileService.updateUserProfile(
            testProfile.uid,
            {
              'displayName': 'Updated Test User',
              'stats.totalXP': 500,
            },
          );
          print(updateSuccess ? '✅ UPDATE: Success' : '❌ UPDATE: Failed');

          // Test SOFT DELETE
          print('\n🗂️ Testing SOFT DELETE operation...');
          final softDeleteSuccess = await UserProfileService.softDeleteUserProfile(testProfile.uid);
          print(softDeleteSuccess ? '✅ SOFT DELETE: Success' : '❌ SOFT DELETE: Failed');

          if (softDeleteSuccess) {
            // Test RESTORE
            print('\n🔄 Testing RESTORE operation...');
            final restoreSuccess = await UserProfileService.restoreUserProfile(testProfile.uid);
            print(restoreSuccess ? '✅ RESTORE: Success' : '❌ RESTORE: Failed');

            // Test BACKUP
            print('\n💾 Testing BACKUP operation...');
            final backupSuccess = await UserProfileService.backupUserProfile(testProfile.uid);
            print(backupSuccess ? '✅ BACKUP: Success' : '❌ BACKUP: Failed');

            // Test HARD DELETE (cleanup)
            print('\n🗑️ Testing HARD DELETE operation...');
            final hardDeleteSuccess = await UserProfileService.hardDeleteUserProfile(testProfile.uid);
            print(hardDeleteSuccess ? '✅ HARD DELETE: Success' : '❌ HARD DELETE: Failed');
          }
        }
      }

      print('\n🎉 CRUD TESTING COMPLETED!\n');
    } catch (e) {
      print('❌ Error during CRUD testing: $e');
    }
  }

  static Future<void> clearDemoData() async {
    print('🧹 Clearing demo data...');
    
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      // Delete demo profiles
      batch.delete(FirebaseFirestore.instance.collection('user_profiles').doc('demo_user_1'));
      batch.delete(FirebaseFirestore.instance.collection('user_profiles').doc('demo_user_2'));
      
      await batch.commit();
      print('✅ Demo data cleared');
    } catch (e) {
      print('❌ Error clearing demo data: $e');
    }
  }
}
