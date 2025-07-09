import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class EnhancedPracticeQuizScreen extends StatefulWidget {
  final Lesson lesson;

  const EnhancedPracticeQuizScreen({super.key, required this.lesson});

  @override
  State<EnhancedPracticeQuizScreen> createState() => _EnhancedPracticeQuizScreenState();
}

class _EnhancedPracticeQuizScreenState extends State<EnhancedPracticeQuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];
  bool quizCompleted = false;
  bool answeredCurrentQuestion = false;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(widget.lesson.exercises.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.surface,
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
    final exercise = widget.lesson.exercises[currentQuestionIndex];

    return Padding(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / widget.lesson.exercises.length,
            backgroundColor: AppTheme.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
          ),

          const SizedBox(height: 20),

          // Question counter
          Text(
            'Question ${currentQuestionIndex + 1} of ${widget.lesson.exercises.length}',
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
              exercise.question,
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
              itemCount: exercise.options.length,
              itemBuilder: (context, index) {
                final isSelected = selectedAnswers[currentQuestionIndex] == index;
                final isCorrect = exercise.options[index] == exercise.correctAnswer;
                final showCorrectAnswer = answeredCurrentQuestion && isCorrect;
                final showIncorrectAnswer = answeredCurrentQuestion && isSelected && !isCorrect;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: answeredCurrentQuestion ? null : () {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: showCorrectAnswer
                            ? AppTheme.success.withValues(alpha: 0.1)
                            : showIncorrectAnswer
                                ? AppTheme.error.withValues(alpha: 0.1)
                                : isSelected
                                    ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                                    : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: showCorrectAnswer
                              ? AppTheme.success
                              : showIncorrectAnswer
                                  ? AppTheme.error
                                  : isSelected
                                      ? AppTheme.primaryOrange
                                      : AppTheme.border,
                          width: isSelected || showCorrectAnswer || showIncorrectAnswer ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.options[index],
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: showCorrectAnswer
                                    ? AppTheme.success
                                    : showIncorrectAnswer
                                        ? AppTheme.error
                                        : isSelected
                                            ? AppTheme.primaryOrange
                                            : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (showCorrectAnswer)
                            Icon(Icons.check_circle, color: AppTheme.success, size: 24),
                          if (showIncorrectAnswer)
                            Icon(Icons.cancel, color: AppTheme.error, size: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanation
          if (answeredCurrentQuestion && exercise.explanation != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppTheme.primaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Explanation',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.explanation!,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Check Answer / Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedAnswers[currentQuestionIndex] != null
                  ? () => answeredCurrentQuestion ? _handleNext() : _checkAnswer()
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: answeredCurrentQuestion ? AppTheme.primaryBlue : AppTheme.primaryOrange,
              ),
              child: Text(
                answeredCurrentQuestion
                    ? (currentQuestionIndex == widget.lesson.exercises.length - 1
                        ? 'Submit Quiz'
                        : 'Next Question')
                    : 'Check Answer',
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
    double percentage = (score / widget.lesson.exercises.length) * 100;
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
            passed ? 'Excellent Work!' : 'Keep Practicing!',
            style: TextStyle(
              fontSize: isTablet ? 32 : 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $score out of ${widget.lesson.exercises.length}',
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
          if (passed) ...[
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.school, color: AppTheme.success, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Lesson Completed!',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                  Text(
                    'You\'ve mastered ${widget.lesson.title}',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 40),
          Row(
            children: [
              if (!passed) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _retakeQuiz(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warning,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retake Quiz'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
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
        ],
      ),
    );
  }

  void _checkAnswer() {
    setState(() {
      answeredCurrentQuestion = true;
    });
  }

  void _handleNext() {
    final selectedOptionIndex = selectedAnswers[currentQuestionIndex];
    final exercise = widget.lesson.exercises[currentQuestionIndex];
    
    if (selectedOptionIndex != null && 
        exercise.options[selectedOptionIndex] == exercise.correctAnswer) {
      score++;
    }

    if (currentQuestionIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answeredCurrentQuestion = false;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }

  void _retakeQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswers = List.filled(widget.lesson.exercises.length, null);
      quizCompleted = false;
      answeredCurrentQuestion = false;
    });
  }
}
