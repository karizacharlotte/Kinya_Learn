import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/lessons_screen.dart';
import 'pages/practice_screen.dart';
import 'pages/culture_screen.dart';
import 'pages/profile_screen.dart';
import 'theme/app_theme.dart';
import 'pages/auth/login_screen.dart';
import 'pages/auth/register_screen.dart';
import 'pages/auth/auth_choice_screen.dart';
import 'pages/splash_screen.dart';
import 'pages/lesson_detail_screen.dart';
import 'pages/practice_quiz_screen.dart';
import 'pages/payment_screen.dart';
import 'pages/final_quiz_screen.dart';
import 'pages/certificate_screen.dart';
import 'models/lesson.dart';

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
        '/splash': (context) => const SplashScreen(),
        '/auth-choice': (context) => const AuthChoiceScreen(),
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/lessons': (context) => const LessonsScreen(),
        '/practice': (context) => const PracticeScreen(),
        '/culture': (context) => const CultureScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/lesson-detail': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return LessonDetailScreen(lesson: lesson);
        },
        '/practice-quiz': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return PracticeQuizScreen(lesson: lesson);
        },
        '/payment': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return PaymentScreen(lesson: lesson);
        },
        '/final-quiz': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return FinalQuizScreen(lesson: lesson);
        },
        '/certificate': (context) {
          final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
          return CertificateScreen(lesson: lesson);
        },
        '/about': (context) => const Scaffold(
              body: Center(child: Text('About KinyaLearn')),
            ),
      },
    );
  }
}
