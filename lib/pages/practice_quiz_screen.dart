import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class PracticeQuizScreen extends StatefulWidget {
  final Lesson lesson;

  const PracticeQuizScreen({super.key, required this.lesson});

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];
  bool quizCompleted = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What does "Muraho" mean in English?',
      'options': ['Goodbye', 'Hello', 'Thank you', 'Good morning'],
      'correctAnswer': 1,
    },
    {
      'question': 'How do you say "Thank you" in Kinyarwanda?',
      'options': ['Murakoze', 'Muraho', 'Urabeho', 'Mwaramutse'],
      'correctAnswer': 0,
    },
    {
      'question': 'What is the meaning of "Mwaramutse"?',
      'options': ['Good night', 'Good afternoon', 'Good morning', 'Hello'],
      'correctAnswer': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: Text(
          'Practice Quiz - ${widget.lesson.title}',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: quizCompleted
          ? _buildResultScreen(isTablet)
          : _buildQuizScreen(isTablet),
    );
  }

  Widget _buildQuizScreen(bool isTablet) {
    final question = questions[currentQuestionIndex];

    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: AppTheme.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
          ),

          const SizedBox(height: 20),

          // Question counter
          Text(
            'Question ${currentQuestionIndex + 1} of ${questions.length}',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          // Question
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              question['question'],
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question['options'].length,
              itemBuilder: (context, index) {
                bool isSelected =
                    selectedAnswers[currentQuestionIndex] == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryPurple.withOpacity(0.1)
                            : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        question['options'][index],
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Next/Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedAnswers[currentQuestionIndex] != null
                  ? () => _handleNext()
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Submit Quiz'
                    : 'Next Question',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(bool isTablet) {
    double percentage = (score / questions.length) * 100;
    bool passed = percentage >= 70;

    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            passed ? Icons.celebration : Icons.refresh,
            size: isTablet ? 80 : 64,
            color: passed ? AppTheme.success : AppTheme.warning,
          ),
          const SizedBox(height: 24),
          Text(
            passed ? 'Great Job!' : 'Keep Practicing!',
            style: TextStyle(
              fontSize: isTablet ? 32 : 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $score out of ${questions.length}',
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: isTablet ? 48 : 40,
              fontWeight: FontWeight.bold,
              color: passed ? AppTheme.success : AppTheme.warning,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (selectedAnswers[currentQuestionIndex] ==
        questions[currentQuestionIndex]['correctAnswer']) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }
}
