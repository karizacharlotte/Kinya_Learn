import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all available achievements
  static Future<List<Map<String, dynamic>>> getAvailableAchievements() async {
    try {
      final achievementsQuery = await _firestore
          .collection('achievements')
          .orderBy('order')
          .get();

      return achievementsQuery.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      // Return default achievements if collection doesn't exist
      return _getDefaultAchievements();
    }
  }

  // Get user's earned achievements
  static Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data()!;
      final userBadges = userData['badges'] as List? ?? [];
      final userAchievements = userData['achievements'] as List? ?? [];

      final allAchievements = await getAvailableAchievements();
      
      return allAchievements.map((achievement) {
        final isEarned = userAchievements.contains(achievement['id']);
        final badgeData = userBadges.firstWhere(
          (badge) => badge['id'] == achievement['id'],
          orElse: () => <String, dynamic>{},
        );

        return {
          ...achievement,
          'earned': isEarned,
          'earnedAt': badgeData?['earnedAt'],
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Award achievement to user
  static Future<bool> awardAchievement(String userId, String achievementId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;
      final currentAchievements = userData['achievements'] as List? ?? [];

      // Check if already earned
      if (currentAchievements.contains(achievementId)) {
        return false;
      }

      // Add achievement
      await _firestore.collection('users').doc(userId).update({
        'achievements': FieldValue.arrayUnion([achievementId]),
        'badges': FieldValue.arrayUnion([{
          'id': achievementId,
          'earnedAt': FieldValue.serverTimestamp(),
        }]),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Check and award achievements based on user progress
  static Future<List<String>> checkAndAwardAchievements(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data()!;
      final currentAchievements = userData['achievements'] as List? ?? [];
      final newAchievements = <String>[];

      // Get user stats
      final totalXP = userData['totalXP'] ?? 0;
      final lessonsCompleted = userData['lessonsCompleted'] ?? 0;
      final streakDays = userData['streakDays'] ?? 0;
      final accuracy = userData['accuracy'] ?? 0.0;

      // Define achievement criteria
      final achievementCriteria = {
        'first_lesson': lessonsCompleted >= 1,
        'lesson_master_5': lessonsCompleted >= 5,
        'lesson_master_10': lessonsCompleted >= 10,
        'lesson_master_25': lessonsCompleted >= 25,
        'lesson_master_50': lessonsCompleted >= 50,
        'xp_master_500': totalXP >= 500,
        'xp_master_1000': totalXP >= 1000,
        'xp_master_2500': totalXP >= 2500,
        'xp_master_5000': totalXP >= 5000,
        'streak_3': streakDays >= 3,
        'streak_7': streakDays >= 7,
        'streak_30': streakDays >= 30,
        'perfect_accuracy': accuracy >= 95.0,
        'culture_explorer': lessonsCompleted >= 3, // Simplified for now
      };

      // Check each achievement
      for (final entry in achievementCriteria.entries) {
        final achievementId = entry.key;
        final criteria = entry.value;

        if (criteria && !currentAchievements.contains(achievementId)) {
          final awarded = await awardAchievement(userId, achievementId);
          if (awarded) {
            newAchievements.add(achievementId);
          }
        }
      }

      return newAchievements;
    } catch (e) {
      return [];
    }
  }

  // Get achievement details
  static Future<Map<String, dynamic>?> getAchievementDetails(String achievementId) async {
    try {
      final achievementDoc = await _firestore
          .collection('achievements')
          .doc(achievementId)
          .get();

      if (achievementDoc.exists) {
        final data = achievementDoc.data()!;
        data['id'] = achievementDoc.id;
        return data;
      }

      // Return default achievement if not found
      final defaultAchievements = _getDefaultAchievements();
      return defaultAchievements.firstWhere(
        (achievement) => achievement['id'] == achievementId,
        orElse: () => {},
      );
    } catch (e) {
      return null;
    }
  }

  // Seed achievements collection (run once)
  static Future<void> seedAchievements() async {
    try {
      final achievements = _getDefaultAchievements();
      
      for (final achievement in achievements) {
        await _firestore
            .collection('achievements')
            .doc(achievement['id'])
            .set(achievement);
      }
    } catch (e) {
      throw Exception('Failed to seed achievements: $e');
    }
  }

  // Default achievements data
  static List<Map<String, dynamic>> _getDefaultAchievements() {
    return [
      {
        'id': 'first_lesson',
        'title': 'First Steps',
        'description': 'Complete your first lesson',
        'icon': 'school',
        'color': 0xFF4CAF50,
        'xpReward': 50,
        'order': 1,
        'category': 'learning',
      },
      {
        'id': 'lesson_master_5',
        'title': 'Getting Started',
        'description': 'Complete 5 lessons',
        'icon': 'star',
        'color': 0xFF2196F3,
        'xpReward': 100,
        'order': 2,
        'category': 'learning',
      },
      {
        'id': 'lesson_master_10',
        'title': 'Lesson Master',
        'description': 'Complete 10 lessons',
        'icon': 'emoji_events',
        'color': 0xFF9C27B0,
        'xpReward': 200,
        'order': 3,
        'category': 'learning',
      },
      {
        'id': 'lesson_master_25',
        'title': 'Dedicated Learner',
        'description': 'Complete 25 lessons',
        'icon': 'school',
        'color': 0xFF673AB7,
        'xpReward': 500,
        'order': 4,
        'category': 'learning',
      },
      {
        'id': 'lesson_master_50',
        'title': 'Kinyarwanda Scholar',
        'description': 'Complete 50 lessons',
        'icon': 'local_library',
        'color': 0xFF3F51B5,
        'xpReward': 1000,
        'order': 5,
        'category': 'learning',
      },
      {
        'id': 'perfect_score',
        'title': 'Perfect Score',
        'description': 'Get 100% on any lesson',
        'icon': 'verified',
        'color': 0xFFFFD700,
        'xpReward': 100,
        'order': 6,
        'category': 'performance',
      },
      {
        'id': 'perfect_accuracy',
        'title': 'Accuracy Expert',
        'description': 'Maintain 95% accuracy',
        'icon': 'precision_manufacturing',
        'color': 0xFF00BCD4,
        'xpReward': 300,
        'order': 7,
        'category': 'performance',
      },
      {
        'id': 'streak_3',
        'title': 'Consistent Learner',
        'description': 'Learn for 3 days in a row',
        'icon': 'local_fire_department',
        'color': 0xFFFF5722,
        'xpReward': 75,
        'order': 8,
        'category': 'consistency',
      },
      {
        'id': 'streak_7',
        'title': 'Week Warrior',
        'description': 'Learn for 7 days in a row',
        'icon': 'whatshot',
        'color': 0xFFE91E63,
        'xpReward': 200,
        'order': 9,
        'category': 'consistency',
      },
      {
        'id': 'streak_30',
        'title': 'Month Master',
        'description': 'Learn for 30 days in a row',
        'icon': 'trending_up',
        'color': 0xFF9C27B0,
        'xpReward': 1000,
        'order': 10,
        'category': 'consistency',
      },
      {
        'id': 'xp_master_500',
        'title': 'XP Explorer',
        'description': 'Earn 500 XP',
        'icon': 'star_border',
        'color': 0xFF795548,
        'xpReward': 50,
        'order': 11,
        'category': 'xp',
      },
      {
        'id': 'xp_master_1000',
        'title': 'XP Collector',
        'description': 'Earn 1,000 XP',
        'icon': 'stars',
        'color': 0xFF607D8B,
        'xpReward': 100,
        'order': 12,
        'category': 'xp',
      },
      {
        'id': 'xp_master_2500',
        'title': 'XP Champion',
        'description': 'Earn 2,500 XP',
        'icon': 'military_tech',
        'color': 0xFF8BC34A,
        'xpReward': 250,
        'order': 13,
        'category': 'xp',
      },
      {
        'id': 'xp_master_5000',
        'title': 'XP Legend',
        'description': 'Earn 5,000 XP',
        'icon': 'emoji_events',
        'color': 0xFFFFD700,
        'xpReward': 500,
        'order': 14,
        'category': 'xp',
      },
      {
        'id': 'culture_explorer',
        'title': 'Culture Explorer',
        'description': 'Complete cultural lessons',
        'icon': 'public',
        'color': 0xFF00A651,
        'xpReward': 150,
        'order': 15,
        'category': 'culture',
      },
    ];
  }
}
