import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;

  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int currentExerciseIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.lesson.exercises[currentExerciseIndex];
    final progress =
        (currentExerciseIndex + 1) / widget.lesson.exercises.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        title: Text(widget.lesson.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question
            Text(
              exercise.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Options
            ...exercise.options.map((option) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton(
                    onPressed: showResult ? null : () => _selectAnswer(option),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(option, style: const TextStyle(fontSize: 16)),
                  ),
                )),
            const Spacer(),
            // Result feedback
            if (showResult)
              Text(
                isCorrect ? 'Correct!' : 'Try again!',
                style: TextStyle(
                  fontSize: 18,
                  color: isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            // Continue button
            if (showResult)
              ElevatedButton(
                onPressed: _nextExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  currentExerciseIndex < widget.lesson.exercises.length - 1
                      ? 'Continue'
                      : 'Finish',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;
      isCorrect =
          answer == widget.lesson.exercises[currentExerciseIndex].correctAnswer;
    });
  }

  void _nextExercise() {
    if (currentExerciseIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        selectedAnswer = null;
        showResult = false;
        isCorrect = false;
      });
    } else {
      // Lesson completed
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson completed! Great job!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
