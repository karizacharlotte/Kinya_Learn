import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class FirestoreDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed initial categories
  static Future<void> seedCategories() async {
    try {
      List<CategoryModel> categories = [
        CategoryModel(
          id: 'greetings',
          name: 'Greetings',
          nameKinyarwanda: 'Amasuzuguro',
          description: 'Learn basic greetings and polite expressions in Kinyarwanda',
          icon: '👋',
          color: '#FF6B6B',
          order: 1,
          lessonsCount: 5,
        ),
        CategoryModel(
          id: 'numbers',
          name: 'Numbers',
          nameKinyarwanda: 'Imibare',
          description: 'Master numbers from 1 to 100 and counting in Kinyarwanda',
          icon: '🔢',
          color: '#4ECDC4',
          order: 2,
          lessonsCount: 4,
        ),
        CategoryModel(
          id: 'family',
          name: 'Family',
          nameKinyarwanda: 'Umuryango',
          description: 'Learn family relationships and household terms',
          icon: '👨‍👩‍👧‍👦',
          color: '#45B7D1',
          order: 3,
          lessonsCount: 6,
        ),
        CategoryModel(
          id: 'food',
          name: 'Food & Drinks',
          nameKinyarwanda: 'Ibiryo n\'Ibinyobwa',
          description: 'Discover Rwandan cuisine and food vocabulary',
          icon: '🍽️',
          color: '#FFA07A',
          order: 4,
          lessonsCount: 5,
        ),
        CategoryModel(
          id: 'culture',
          name: 'Culture & Traditions',
          nameKinyarwanda: 'Umuco n\'Imigenzo',
          description: 'Explore Rwandan culture, traditions, and customs',
          icon: '🎭',
          color: '#98D8C8',
          order: 5,
          lessonsCount: 7,
        ),
        CategoryModel(
          id: 'daily_life',
          name: 'Daily Life',
          nameKinyarwanda: 'Ubuzima bwa buri munsi',
          description: 'Common phrases and vocabulary for everyday situations',
          icon: '🏠',
          color: '#F7DC6F',
          order: 6,
          lessonsCount: 8,
        ),
      ];

      for (CategoryModel category in categories) {
        await _firestore
            .collection('categories')
            .doc(category.id)
            .set(category.toFirestore(), SetOptions(merge: true));
      }

      print('Categories seeded successfully');
    } catch (e) {
      print('Error seeding categories: $e');
    }
  }

  /// Seed initial lessons
  static Future<void> seedLessons() async {
    try {
      List<LessonModel> lessons = [
        // Greetings Lessons
        LessonModel(
          id: 'greetings_basic',
          title: 'Basic Greetings',
          description: 'Learn the most common greetings in Kinyarwanda',
          level: 'Beginner',
          order: 1,
          category: 'greetings',
          estimatedDuration: 15,
          objectives: [
            'Say hello and goodbye',
            'Ask how someone is doing',
            'Respond to greetings appropriately'
          ],
        ),
        LessonModel(
          id: 'greetings_time',
          title: 'Time-based Greetings',
          description: 'Greetings for different times of day',
          level: 'Beginner',
          order: 2,
          category: 'greetings',
          estimatedDuration: 12,
          objectives: [
            'Use morning greetings',
            'Use afternoon greetings',
            'Use evening greetings'
          ],
        ),
        LessonModel(
          id: 'greetings_formal',
          title: 'Formal Greetings',
          description: 'Respectful greetings for elders and formal situations',
          level: 'Intermediate',
          order: 3,
          category: 'greetings',
          estimatedDuration: 18,
          objectives: [
            'Show respect through greetings',
            'Use formal language',
            'Understand cultural context'
          ],
        ),

        // Numbers Lessons
        LessonModel(
          id: 'numbers_1_10',
          title: 'Numbers 1-10',
          description: 'Learn the first ten numbers in Kinyarwanda',
          level: 'Beginner',
          order: 1,
          category: 'numbers',
          estimatedDuration: 10,
          objectives: [
            'Count from 1 to 10',
            'Pronounce numbers correctly',
            'Use numbers in simple sentences'
          ],
        ),
        LessonModel(
          id: 'numbers_11_50',
          title: 'Numbers 11-50',
          description: 'Expand your number vocabulary',
          level: 'Beginner',
          order: 2,
          category: 'numbers',
          estimatedDuration: 15,
          objectives: [
            'Count from 11 to 50',
            'Understand number patterns',
            'Practice pronunciation'
          ],
        ),

        // Family Lessons
        LessonModel(
          id: 'family_immediate',
          title: 'Immediate Family',
          description: 'Learn terms for parents, siblings, and children',
          level: 'Beginner',
          order: 1,
          category: 'family',
          estimatedDuration: 20,
          objectives: [
            'Name immediate family members',
            'Describe family relationships',
            'Talk about your family'
          ],
        ),
        LessonModel(
          id: 'family_extended',
          title: 'Extended Family',
          description: 'Learn terms for grandparents, aunts, uncles, and cousins',
          level: 'Intermediate',
          order: 2,
          category: 'family',
          estimatedDuration: 25,
          objectives: [
            'Name extended family members',
            'Understand generational terms',
            'Describe complex relationships'
          ],
        ),

        // Culture Lessons
        LessonModel(
          id: 'culture_traditions',
          title: 'Traditional Ceremonies',
          description: 'Learn about important Rwandan ceremonies and celebrations',
          level: 'Intermediate',
          order: 1,
          category: 'culture',
          estimatedDuration: 30,
          objectives: [
            'Understand traditional ceremonies',
            'Learn ceremonial vocabulary',
            'Appreciate cultural significance'
          ],
        ),
        LessonModel(
          id: 'culture_proverbs',
          title: 'Rwandan Proverbs',
          description: 'Discover the wisdom in traditional Rwandan sayings',
          level: 'Advanced',
          order: 2,
          category: 'culture',
          estimatedDuration: 35,
          objectives: [
            'Learn common proverbs',
            'Understand their meanings',
            'Use proverbs appropriately'
          ],
        ),
      ];

      for (LessonModel lesson in lessons) {
        await _firestore
            .collection('lessons')
            .doc(lesson.id)
            .set(lesson.toFirestore(), SetOptions(merge: true));
      }

      print('Lessons seeded successfully');
    } catch (e) {
      print('Error seeding lessons: $e');
    }
  }

  /// Seed initial achievements
  static Future<void> seedAchievements() async {
    try {
      List<AchievementModel> achievements = [
        AchievementModel(
          id: 'first_lesson',
          title: 'First Steps',
          description: 'Complete your first lesson',
          icon: '🎯',
          type: 'completion',
          condition: {'type': 'lessons_completed', 'value': 1},
          points: 50,
          rarity: 'common',
        ),
        AchievementModel(
          id: 'lesson_streak_3',
          title: 'Getting Started',
          description: 'Complete lessons for 3 days in a row',
          icon: '🔥',
          type: 'streak',
          condition: {'type': 'daily_streak', 'value': 3},
          points: 100,
          rarity: 'common',
        ),
        AchievementModel(
          id: 'lesson_streak_7',
          title: 'Week Warrior',
          description: 'Complete lessons for 7 days in a row',
          icon: '⚡',
          type: 'streak',
          condition: {'type': 'daily_streak', 'value': 7},
          points: 250,
          rarity: 'rare',
        ),
        AchievementModel(
          id: 'lesson_streak_30',
          title: 'Monthly Master',
          description: 'Complete lessons for 30 days in a row',
          icon: '👑',
          type: 'streak',
          condition: {'type': 'daily_streak', 'value': 30},
          points: 1000,
          rarity: 'legendary',
        ),
        AchievementModel(
          id: 'points_100',
          title: 'Century Club',
          description: 'Earn 100 total points',
          icon: '💯',
          type: 'points',
          condition: {'type': 'total_points', 'value': 100},
          points: 25,
          rarity: 'common',
        ),
        AchievementModel(
          id: 'points_1000',
          title: 'Point Master',
          description: 'Earn 1000 total points',
          icon: '⭐',
          type: 'points',
          condition: {'type': 'total_points', 'value': 1000},
          points: 100,
          rarity: 'epic',
        ),
        AchievementModel(
          id: 'category_greetings',
          title: 'Greeting Expert',
          description: 'Complete all lessons in the Greetings category',
          icon: '👋',
          type: 'category',
          condition: {'type': 'category_complete', 'value': 'greetings'},
          points: 200,
          rarity: 'rare',
        ),
        AchievementModel(
          id: 'category_numbers',
          title: 'Number Ninja',
          description: 'Complete all lessons in the Numbers category',
          icon: '🔢',
          type: 'category',
          condition: {'type': 'category_complete', 'value': 'numbers'},
          points: 200,
          rarity: 'rare',
        ),
        AchievementModel(
          id: 'culture_explorer',
          title: 'Culture Explorer',
          description: 'Complete all lessons in the Culture category',
          icon: '🎭',
          type: 'category',
          condition: {'type': 'category_complete', 'value': 'culture'},
          points: 300,
          rarity: 'epic',
        ),
        AchievementModel(
          id: 'perfect_score',
          title: 'Perfectionist',
          description: 'Get 100% on any lesson quiz',
          icon: '🎯',
          type: 'special',
          condition: {'type': 'perfect_quiz', 'value': 1},
          points: 150,
          rarity: 'rare',
        ),
      ];

      for (AchievementModel achievement in achievements) {
        await _firestore
            .collection('achievements')
            .doc(achievement.id)
            .set(achievement.toFirestore(), SetOptions(merge: true));
      }

      print('Achievements seeded successfully');
    } catch (e) {
      print('Error seeding achievements: $e');
    }
  }

  /// Seed app configuration
  static Future<void> seedAppConfig() async {
    try {
      Map<String, dynamic> config = {
        'version': '1.0.0',
        'minSupportedVersion': '1.0.0',
        'featuredLessons': [
          'greetings_basic',
          'numbers_1_10',
          'family_immediate',
          'culture_traditions'
        ],
        'announcements': [
          {
            'title': 'Welcome to Kinya Learn!',
            'message': 'Start your journey learning Kinyarwanda today',
            'type': 'info',
            'expiresAt': Timestamp.fromDate(
              DateTime.now().add(Duration(days: 30))
            ),
          }
        ],
        'maintenanceMode': false,
      };

      await _firestore
          .collection('app_content')
          .doc('config')
          .set(config, SetOptions(merge: true));

      print('App config seeded successfully');
    } catch (e) {
      print('Error seeding app config: $e');
    }
  }

  /// Seed all data
  static Future<void> seedAllData() async {
    print('Starting data seeding...');
    
    await seedCategories();
    await seedLessons();
    await seedAchievements();
    await seedAppConfig();
    
    print('Data seeding completed!');
  }

  /// Check if seeding is needed
  static Future<bool> needsSeeding() async {
    try {
      QuerySnapshot categoriesSnapshot = await _firestore
          .collection('categories')
          .limit(1)
          .get();
      
      return categoriesSnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking if seeding is needed: $e');
      return true; // Default to needing seeding if we can't check
    }
  }

  /// Seed data if needed
  static Future<void> seedIfNeeded() async {
    bool needsSeeding = await FirestoreDataSeeder.needsSeeding();
    
    if (needsSeeding) {
      print('Database is empty, seeding initial data...');
      await seedAllData();
    } else {
      print('Database already has data, skipping seeding.');
    }
  }
}
