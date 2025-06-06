import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/lessons_screen.dart';
import 'pages/practice_screen.dart';
import 'pages/culture_screen.dart';
import 'pages/profile_screen.dart';
import 'theme/app_theme.dart';
import 'pages/auth/login_screen.dart';
import 'pages/auth/register_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/lessons': (context) => const LessonsScreen(),
        '/practice': (context) => const PracticeScreen(),
        '/culture': (context) => const CultureScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/about': (context) => const Scaffold(
              body: Center(child: Text('About KinyaLearn')),
            ),
      },
    );
  }
}
