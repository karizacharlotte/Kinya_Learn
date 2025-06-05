import '../models/lesson.dart';

class KinyarwandaLessons {
  static List<Lesson> getLessons() {
    return [
      Lesson(
        id: 'basics1',
        title: 'Basic Greetings',
        description: 'Learn how to say hello and goodbye in Kinyarwanda',
        order: 1,
        isUnlocked: true,
        exercises: [
          Exercise(
            id: 'greet1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "Hello" in Kinyarwanda?',
            correctAnswer: 'Muraho',
            options: ['Muraho', 'Murabeho', 'Mwiriwe', 'Bite'],
          ),
          Exercise(
            id: 'greet2',
            type: ExerciseType.translation,
            question: 'Translate: "Good morning"',
            correctAnswer: 'Mwaramutse',
            options: ['Mwaramutse', 'Mwiriwe', 'Ijoro ryiza', 'Muraho'],
          ),
        ],
      ),
      Lesson(
        id: 'family1',
        title: 'Family Members',
        description: 'Learn words for family members in Kinyarwanda',
        order: 2,
        isUnlocked: true,
        exercises: [
          Exercise(
            id: 'family1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "mother" in Kinyarwanda?',
            correctAnswer: 'Mama',
            options: ['Mama', 'Papa', 'Mwana', 'Murumuna'],
          ),
        ],
      ),
      Lesson(
        id: 'numbers1',
        title: 'Numbers 1-10',
        description: 'Count from 1 to 10 in Kinyarwanda',
        order: 3,
        isUnlocked: false,
        exercises: [
          Exercise(
            id: 'num1',
            type: ExerciseType.multipleChoice,
            question: 'What is "1" in Kinyarwanda?',
            correctAnswer: 'Rimwe',
            options: ['Rimwe', 'Kabiri', 'Gatatu', 'Kane'],
          ),
        ],
      ),
    ];
  }
}
