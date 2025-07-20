import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'package:flutter/rendering.dart';
import 'pages/home_page.dart';
import 'pages/lessons_screen.dart';
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

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LessonProgressProvider()),
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
            '/': (context) => const HomePage(),
            '/lessons': (context) => const LessonsScreen(),
            '/practice': (context) => const PracticeScreen(),
            '/culture': (context) => const CultureScreen(),
            '/profile': (context) => const ProfilePage(),
            '/profile-page': (context) => const ProfilePage(),
            '/auth': (context) => const AuthChoiceScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
            '/about': (context) => const AboutScreen(),
            '/settings': (context) => const SettingsScreen(),
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
