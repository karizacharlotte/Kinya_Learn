class Lesson {
  final String id;
  final String title;
  final String description;
  final List<Exercise> exercises;
  final int order;
  final bool isCompleted;
  final bool isUnlocked;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.exercises,
    required this.order,
    this.isCompleted = false,
    this.isUnlocked = false,
  });
}

class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? audioUrl;
  final String? imageUrl;

  Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.audioUrl,
    this.imageUrl,
  });
}

enum ExerciseType {
  multipleChoice,
  translation,
  listening,
  speaking,
  matching,
}
