class Lesson {
  final String id;
  final String title;
  final String description;
  final List<Exercise> exercises;
  final int order;
  bool isCompleted;
  bool isUnlocked;
  final String? videoUrl; // Add video URL support
  final String? videoTitle; // Optional video title

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.exercises,
    this.order = 0, // Add default value
    this.isCompleted = false,
    this.isUnlocked = false,
    this.videoUrl,
    this.videoTitle,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        exercises: (json['exercises'] as List)
            .map((e) => Exercise.fromJson(e))
            .toList(),
        order: json['order'],
        isCompleted: json['isCompleted'] ?? false,
        isUnlocked: json['isUnlocked'] ?? false,
        videoUrl: json['videoUrl'],
        videoTitle: json['videoTitle'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'order': order,
        'isCompleted': isCompleted,
        'isUnlocked': isUnlocked,
        'videoUrl': videoUrl,
        'videoTitle': videoTitle,
      };
}

class Exercise {
  final String? id;
  final ExerciseType? type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? audioUrl;
  final String? imageUrl;

  Exercise({
    this.id,
    this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.audioUrl,
    this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'],
        type: ExerciseType.values[json['type']],
        question: json['question'],
        correctAnswer: json['correctAnswer'],
        options: List<String>.from(json['options']),
        audioUrl: json['audioUrl'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type?.index,
        'question': question,
        'correctAnswer': correctAnswer,
        'options': options,
        'audioUrl': audioUrl,
        'imageUrl': imageUrl,
      };
}

enum ExerciseType {
  multipleChoice,
  translation,
  fillInBlank,
  listening,
  speaking,
  matching,
}
