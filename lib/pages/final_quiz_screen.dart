import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class FinalQuizScreen extends StatefulWidget {
  final Lesson lesson;

  const FinalQuizScreen({super.key, required this.lesson});

  @override
  State<FinalQuizScreen> createState() => _FinalQuizScreenState();
}

class _FinalQuizScreenState extends State<FinalQuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];
  bool quizCompleted = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Complete the sentence: "Ndashaka _____ amazi" (I want water)',
      'options': ['kunywa', 'kurya', 'gusoma', 'kwandika'],
      'correctAnswer': 0,
    },
    {
      'question': 'What is the plural of "umuntu" (person)?',
      'options': ['abantu', 'abantu', 'umuuntu', 'ibantu'],
      'correctAnswer': 0,
    },
    {
      'question': 'How do you say "I am learning Kinyarwanda"?',
      'options': [
        'Niga Ikinyarwanda',
        'Niga Icyongereza',
        'Nsoma Ikinyarwanda',
        'Nandika Ikinyarwanda'
      ],
      'correctAnswer': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(questions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: Text('Final Quiz - ${widget.lesson.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final question = questions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: AppTheme.border,
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 158, 74, 21)),
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 158, 74, 21)
                                .withOpacity(0.1)
                            : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color.fromARGB(255, 158, 74, 21)
                              : AppTheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(question['options'][index]),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedAnswers[currentQuestionIndex] != null
                  ? () => _handleNext()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 158, 74, 21),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Complete Final Quiz'
                    : 'Next Question',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    double percentage = (score / questions.length) * 100;
    bool passed = percentage >= 80;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            passed ? Icons.emoji_events : Icons.refresh,
            size: 64,
            color: passed
                ? const Color.fromARGB(255, 158, 74, 21)
                : AppTheme.warning,
          ),
          const SizedBox(height: 24),
          Text(
            passed ? 'Congratulations!' : 'Keep Practicing!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Final Score: $score out of ${questions.length}'),
          const SizedBox(height: 8),
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: passed
                  ? const Color.fromARGB(255, 158, 74, 21)
                  : AppTheme.warning,
            ),
          ),
          const SizedBox(height: 40),
          if (passed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/certificate',
                      arguments: widget.lesson);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 158, 74, 21),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Download Certificate'),
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false),
              child: Text(passed ? 'Continue Learning' : 'Try Again Later'),
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
