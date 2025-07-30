import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'theme/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'services/notification_service.dart';
import 'services/achievement_service.dart';
import 'services/firestore_data_seeder.dart';
import 'package:flutter/rendering.dart';
import 'pages/home_page.dart';
import 'pages/lessons_screen.dart'; // Original video-based lessons
import 'pages/enhanced_lessons_screen.dart';
import 'pages/practice_screen.dart';
import 'pages/culture_screen.dart';
import 'pages/profile_page.dart';
import 'pages/auth/login_screen.dart';
import 'pages/auth/auth_choice_screen.dart';
import 'pages/splash_screen.dart';
import 'theme/app_theme.dart';
import 'models/lesson.dart';
import 'pages/auth/register_screen.dart';
import 'pages/final_quiz_screen.dart';
import 'pages/about_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/lesson_detail_screen.dart';

// 🔥 Simple Firebase Test Function
Future<void> _testFirebaseConnection() async {
  try {
    print('🔄 Testing Firebase backend connection...');
    
    // Test Firestore connection
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('📊 Project ID:  [1m${DefaultFirebaseOptions.currentPlatform.projectId} [0m');
    
    // Test Authentication service
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    print('👤 Current user: ${currentUser?.email ?? 'No user logged in'}');
    
    // Check existing users in Firestore
    QuerySnapshot userDocs = await firestore.collection('users').limit(3).get();
    print('👥 Found ${userDocs.docs.length} users in Firestore:');
    for (var doc in userDocs.docs) {
      var data = doc.data() as Map<String, dynamic>;
      print('  - ${data['email'] ?? 'No email'} (ID: ${doc.id.substring(0, 8)}...)');
    }
    
    // Test write capability
    await firestore.collection('test').doc('connection_test').set({
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Backend working!',
      'testTime': DateTime.now().toIso8601String(),
    });
    print('✅ Firebase backend is working correctly!');
    
  } catch (e) {
    print('❌ Firebase Error: $e');
    print('🔧 Check Firebase configuration and permissions');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    print('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully!');
    
    // Initialize notification service
    print('📱 Initializing notifications...');
    await NotificationService.initialize();
    print('✅ Notifications initialized!');
    
    // Seed achievements if not already done
    print('🏆 Seeding achievements...');
    await AchievementService.seedAchievements();
    print('✅ Achievements seeded!');
    
    // Seed Firestore data if needed
    print('📚 Seeding Firestore data...');
    await FirestoreDataSeeder.seedIfNeeded();
    print('✅ Firestore data seeded!');
    
    // 🔥 Quick Firebase Connection Test
    await _testFirebaseConnection();
  } catch (e) {
    print('❌ Initialization error: $e');
    // Continue anyway for debugging
  }
  
  debugPaintSizeEnabled = false;
  
  print('🚀 Starting Kinya Learn App...');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // If you need lesson progress tracking, add this line:
        // ChangeNotifierProvider(create: (_) => LessonProgressProvider()),
        // If you want to use the enhanced auth provider, swap it here:
        // ChangeNotifierProvider(create: (_) => EnhancedAuthProvider()),
      ],
      child: const KinyaLearnApp(),
    ),
  );
}

class KinyaLearnApp extends StatelessWidget {
  const KinyaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'KinyaLearn',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: {
            '/': (context) => const HomePage(), // Back to original home
            '/home': (context) => const HomePage(),
            '/lessons': (context) => const LessonsScreen(), // Original video-based lessons
            '/enhanced-lessons': (context) => const EnhancedLessonsScreen(), // Keep Firebase lessons available
            '/practice': (context) => const PracticeScreen(),
            '/culture': (context) => const CultureScreen(),
            '/profile': (context) => const ProfilePage(),
            '/profile-page': (context) => const ProfilePage(),
            '/auth': (context) => const AuthChoiceScreen(),
            '/auth-choice': (context) => const AuthChoiceScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
            '/about': (context) => const AboutScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/dictionary': (context) => const HomePage(), // Placeholder for now
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/lesson-detail') {
              final lesson = settings.arguments as Lesson?;
              if (lesson == null) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(child: const Text('No lesson data provided!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => LessonDetailScreen(lesson: lesson),
              );
            }
            if (settings.name == '/final-quiz') {
              final lesson = settings.arguments as Lesson?;
              if (lesson == null) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(child: const Text('No lesson data provided!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => FinalQuizScreen(lesson: lesson),
              );
            }
            if (settings.name == '/practice-quiz') {
              final lesson = settings.arguments as Lesson?;
              if (lesson == null) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Practice Quiz')),
                    body: const Center(child: Text('Practice Quiz - Coming Soon!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text('Practice Quiz - ${lesson.title}')),
                  body: const Center(child: Text('Practice Quiz - Coming Soon!')),
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
