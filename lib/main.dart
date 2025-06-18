import 'package:flutter/material.dart';
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

void main() {
  runApp(const KinyaLearnApp());
}

class KinyaLearnApp extends StatelessWidget {
  const KinyaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinyaLearn',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/': (context) => const HomePage(),
        '/splash': (context) => const SplashScreen(),
        '/auth-choice': (context) => const AuthChoiceScreen(),
        '/login': (context) => const LoginScreen(),
        '/lessons': (context) => const LessonsScreen(),
        '/lesson-detail': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return LessonPage(lesson: lesson);
        },
        '/practice': (context) => const PracticeScreen(),
        '/culture': (context) => const CultureScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/certificate': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return CertificateScreen(lesson: lesson);
        },
        '/register': (context) => const RegisterScreen(),
        '/payment': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return PaymentScreen(lesson: lesson);
        },
        '/final-quiz': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return FinalQuizScreen(lesson: lesson);
        },
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
