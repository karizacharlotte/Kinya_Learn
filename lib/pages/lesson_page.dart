import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/lesson.dart';
import '../data/kinyarwanda_lessons.dart';

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
  String? hoveredOption;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.lesson.exercises[currentExerciseIndex];
    final progress =
        (currentExerciseIndex + 1) / widget.lesson.exercises.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 42, 147),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                exercise.question,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Options with highlight and hover
              ...exercise.options.map((option) {
                final isSelected = selectedAnswer == option;
                final isCorrectAnswer = option == exercise.correctAnswer;
                final showFeedback = showResult && isSelected;
                Color? borderColor;
                Color? fillColor;
                if (showResult) {
                  if (isSelected && isCorrectAnswer) {
                    borderColor = Colors.green;
                    fillColor = Colors.green.withOpacity(0.1);
                  } else if (isSelected && !isCorrectAnswer) {
                    borderColor = Colors.red;
                    fillColor = Colors.red.withOpacity(0.1);
                  } else if (isCorrectAnswer) {
                    borderColor = Colors.green;
                    fillColor = Colors.green.withOpacity(0.05);
                  }
                } else if (hoveredOption == option) {
                  borderColor = Colors.deepPurple.withOpacity(0.5);
                  fillColor = Colors.deepPurple.withOpacity(0.05);
                }

                Widget optionChild = Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (showResult && isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          isCorrectAnswer ? 'Correct' : 'Incorrect',
                          style: TextStyle(
                            color: isCorrectAnswer ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (showResult && !isSelected && isCorrectAnswer)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: const Text(
                          'Correct',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );

                Widget button = OutlinedButton(
                  onPressed: showResult ? null : () => _selectAnswer(option),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: borderColor != null
                        ? BorderSide(color: borderColor, width: 2)
                        : null,
                    backgroundColor: fillColor,
                  ),
                  child: optionChild,
                );

                if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) {
                  button = MouseRegion(
                    onEnter: (_) {
                      if (!showResult) setState(() => hoveredOption = option);
                    },
                    onExit: (_) {
                      if (!showResult) setState(() => hoveredOption = null);
                    },
                    child: button,
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: button,
                );
              }),
              // Feedback below options
              if (showResult)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    isCorrect ? 'Correct!' : 'Try again!',
                    style: TextStyle(
                      fontSize: 18,
                      color: isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              // Continue or Try Again button
              if (showResult && isCorrect)
                ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 78, 42, 147),
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
              if (showResult && !isCorrect)
                ElevatedButton(
                  onPressed: _tryAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
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

  void _tryAgain() {
    setState(() {
      selectedAnswer = null;
      showResult = false;
      isCorrect = false;
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
      widget.lesson.isCompleted = true;
      // Unlock next lesson if available (only on continue)
      final lessons = KinyarwandaLessons.getLessons();
      final idx = lessons.indexWhere((l) => l.title == widget.lesson.title);
      if (idx != -1 && idx + 1 < lessons.length) {
        lessons[idx + 1].isUnlocked = true;
      }
      // Show progress slide
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Lesson Completed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve unlocked the next lesson.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close bottom sheet
                  Navigator.pop(context); // go back to lessons
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lesson completed! Great job!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 78, 42, 147),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
