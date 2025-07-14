import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:math';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;
  int totalQuestions = 0;
  List<Map<String, dynamic>> todaysChallenges = [];

  final List<Map<String, dynamic>> allChallenges = [
    {
      'type': 'translation',
      'question': 'Translate to English: "Ndashaka kunywa amazi"',
      'options': ['I want to drink water', 'I want to eat food', 'I want to go home', 'I want to sleep'],
      'correct': 0,
      'points': 10,
    },
    {
      'type': 'vocabulary',
      'question': 'What does "Murakoze" mean?',
      'options': ['Hello', 'Thank you', 'Goodbye', 'Please'],
      'correct': 1,
      'points': 10,
    },
    {
      'type': 'grammar',
      'question': 'Complete: "Abana _____ mu ishuri"',
      'options': ['bari', 'ari', 'uri', 'ndi'],
      'correct': 0,
      'points': 15,
    },
    {
      'type': 'listening',
      'question': 'Which greeting is used in the morning?',
      'options': ['Mwiriwe', 'Mwaramutse', 'Muraho', 'Muramuke'],
      'correct': 1,
      'points': 10,
    },
    {
      'type': 'cultural',
      'question': 'What is the traditional Rwandan value of working together?',
      'options': ['Ubwiyunge', 'Ubwoba', 'Ubushingantahe', 'Ubusabane'],
      'correct': 3,
      'points': 20,
    },
    {
      'type': 'translation',
      'question': 'Translate to Kinyarwanda: "Good morning"',
      'options': ['Mwiriwe', 'Mwaramutse', 'Muraho', 'Muramuke'],
      'correct': 1,
      'points': 10,
    },
    {
      'type': 'vocabulary',
      'question': 'What is the Kinyarwanda word for "school"?',
      'options': ['ishuri', 'inzu', 'umukino', 'amazi'],
      'correct': 0,
      'points': 10,
    },
    {
      'type': 'grammar',
      'question': 'Which is the correct possessive form for "my book"?',
      'options': ['igitabo cyawe', 'igitabo cyanjye', 'igitabo cye', 'igitabo cyabo'],
      'correct': 1,
      'points': 15,
    },
    {
      'type': 'cultural',
      'question': 'What does "Ubushingantahe" represent in Rwandan culture?',
      'options': ['Traditional dance', 'Traditional food', 'Traditional leadership', 'Traditional clothing'],
      'correct': 2,
      'points': 20,
    },
    {
      'type': 'translation',
      'question': 'Translate: "Ni bangahe?" means:',
      'options': ['How are you?', 'How much is it?', 'How old are you?', 'How many?'],
      'correct': 1,
      'points': 10,
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateTodaysChallenge();
  }

  void _generateTodaysChallenge() {
    // Generate 5 random challenges for today
    final random = Random();
    final shuffled = List<Map<String, dynamic>>.from(allChallenges)..shuffle(random);
    todaysChallenges = shuffled.take(5).toList();
  }

  void _checkAnswer() {
    final correctAnswer = todaysChallenges[currentQuestionIndex]['correct'];
    final points = todaysChallenges[currentQuestionIndex]['points'] as int;
    
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showResult = true;
      totalQuestions++;
      if (isCorrect) score += points;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < todaysChallenges.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    final maxPoints = todaysChallenges.fold(0, (sum, item) => sum + (item['points'] as int));
    final percentage = (score / maxPoints * 100).round();
    
    String title = 'Daily Challenge Complete!';
    String message = 'Your score: $score / $maxPoints points ($percentage%)';
    
    if (percentage >= 90) {
      title = '🏆 Outstanding Performance!';
      message = 'Perfect! You earned $score / $maxPoints points ($percentage%)';
    } else if (percentage >= 70) {
      title = '🎉 Great Job!';
      message = 'Well done! You earned $score / $maxPoints points ($percentage%)';
    } else if (percentage >= 50) {
      title = '👍 Good Effort!';
      message = 'Keep practicing! You earned $score / $maxPoints points ($percentage%)';
    } else {
      title = '📚 Keep Learning!';
      message = 'Don\'t give up! You earned $score / $maxPoints points ($percentage%)';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 16),
            Text(
              'Come back tomorrow for a new challenge!',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Return to Practice'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                totalQuestions = 0;
                selectedAnswer = null;
                showResult = false;
              });
              _generateTodaysChallenge();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'translation':
        return const Color(0xFFFAD201);
      case 'vocabulary':
        return const Color(0xFF4CAF50);
      case 'grammar':
        return AppTheme.primaryOrange;
      case 'listening':
        return const Color(0xFF00A1DE);
      case 'cultural':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'translation':
        return 'Translation';
      case 'vocabulary':
        return 'Vocabulary';
      case 'grammar':
        return 'Grammar';
      case 'listening':
        return 'Listening';
      case 'cultural':
        return 'Culture';
      default:
        return 'Question';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (todaysChallenges.isEmpty) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    final currentQuestion = todaysChallenges[currentQuestionIndex];
    final typeColor = _getTypeColor(currentQuestion['type']);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [theme.colorScheme.surface, theme.colorScheme.surface]
                    : [Colors.orange, Colors.deepOrange],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                              size: isTablet ? 32 : 28),
                          SizedBox(width: isTablet ? 12 : 8),
                          Text(
                            'Daily Challenge',
                            style: TextStyle(
                              color: isDark ? theme.colorScheme.onSurface : Colors.white,
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        'Complete today\'s challenge for bonus XP!',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / todaysChallenges.length,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentQuestionIndex + 1}/${todaysChallenges.length}',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Question Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(
                      color: AppTheme.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question type and points
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 12 : 8,
                              vertical: isTablet ? 6 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                            ),
                            child: Text(
                              _getTypeLabel(currentQuestion['type']),
                              style: TextStyle(
                                color: typeColor,
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: typeColor, size: isTablet ? 20 : 16),
                              SizedBox(width: isTablet ? 4 : 2),
                              Text(
                                '${currentQuestion['points']} XP',
                                style: TextStyle(
                                  color: typeColor,
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Question
                      Text(
                        currentQuestion['question'],
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Options
                      ...List.generate(
                        currentQuestion['options'].length,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
                          child: Container(
                            width: double.infinity,
                            child: InkWell(
                              onTap: showResult ? null : () {
                                setState(() {
                                  selectedAnswer = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                              child: Container(
                                padding: EdgeInsets.all(isTablet ? 16 : 12),
                                decoration: BoxDecoration(
                                  color: showResult
                                      ? (index == currentQuestion['correct']
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : (index == selectedAnswer && selectedAnswer != currentQuestion['correct']
                                              ? Colors.red.withValues(alpha: 0.1)
                                              : Colors.grey.withValues(alpha: 0.1)))
                                      : (selectedAnswer == index
                                          ? typeColor.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1)),
                                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                  border: Border.all(
                                    color: showResult
                                        ? (index == currentQuestion['correct']
                                            ? Colors.green
                                            : (index == selectedAnswer && selectedAnswer != currentQuestion['correct']
                                                ? Colors.red
                                                : Colors.grey))
                                        : (selectedAnswer == index
                                            ? typeColor
                                            : Colors.grey),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: isTablet ? 24 : 20,
                                      height: isTablet ? 24 : 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedAnswer == index
                                            ? typeColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: selectedAnswer == index
                                              ? typeColor
                                              : Colors.grey,
                                        ),
                                      ),
                                      child: selectedAnswer == index
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: isTablet ? 16 : 14,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    Expanded(
                                      child: Text(
                                        currentQuestion['options'][index],
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Score display
                      if (showResult) ...[
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: isTablet ? 24 : 20,
                              ),
                              SizedBox(width: isTablet ? 8 : 6),
                              Text(
                                isCorrect ? '+${currentQuestion['points']} XP' : '+0 XP',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                      ],
                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: showResult ? _nextQuestion : (selectedAnswer != null ? _checkAnswer : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: typeColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                            ),
                          ),
                          child: Text(
                            showResult ? 'Next Question' : 'Check Answer',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
