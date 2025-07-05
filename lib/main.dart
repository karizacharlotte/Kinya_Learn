import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'package:flutter/rendering.dart';
import 'pages/home_page.dart';
import 'pages/lessons_screen.dart';
import 'pages/lesson_page.dart';
import 'pages/practice_screen.dart';
import 'pages/culture_screen.dart';
import 'pages/profile_screen.dart';
import 'pages/auth/login_screen.dart';
import 'pages/auth/auth_choice_screen.dart';
import 'pages/splash_screen.dart';
import 'pages/certificate_screen.dart';
import 'theme/app_theme.dart';
import 'models/lesson.dart';
import 'pages/auth/register_screen.dart';
import 'pages/payment_screen.dart';
import 'pages/final_quiz_screen.dart';
import 'pages/about_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/lesson_detail_screen.dart';
import 'pages/practice_quiz_screen.dart' as practice_quiz;

void main() {
  debugPaintSizeEnabled = false; // Highlights layout issues
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
            '/splash': (context) => const SplashScreen(),
            '/auth-choice': (context) => const AuthChoiceScreen(),
            '/login': (context) => const LoginScreen(),
            '/lessons': (context) => const LessonsScreen(),
            '/practice': (context) => const PracticeScreen(),
            '/culture': (context) => const CultureScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/register': (context) => const RegisterScreen(),
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
            if (settings.name == '/certificate') {
              final lesson = settings.arguments as Lesson?;
              if (lesson == null) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(child: const Text('No lesson data provided!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => CertificateScreen(lesson: lesson),
              );
            }
            if (settings.name == '/payment') {
              final lesson = settings.arguments as Lesson?;
              if (lesson == null) {
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(child: const Text('No lesson data provided!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => PaymentScreen(lesson: lesson),
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
                    body: Center(child: const Text('No lesson data provided!')),
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (_) => practice_quiz.PracticeQuizScreen(lesson: lesson),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
