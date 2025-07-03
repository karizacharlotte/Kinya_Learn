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
        isCompleted: false,
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
            type: ExerciseType.multipleChoice,
            question: 'How do you say "Good morning" in Kinyarwanda?',
            correctAnswer: 'Mwaramutse',
            options: ['Mwaramutse', 'Mwiriwe', 'Ijoro ryiza', 'Muraho'],
          ),
          Exercise(
            id: 'greet3',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "Good evening" in Kinyarwanda?',
            correctAnswer: 'Mwiriwe',
            options: ['Mwiriwe', 'Mwaramutse', 'Ijoro ryiza', 'Murabeho'],
          ),
          Exercise(
            id: 'greet4',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "Goodbye" in Kinyarwanda?',
            correctAnswer: 'Murabeho',
            options: ['Murabeho', 'Muraho', 'Mwiriwe', 'Mwaramutse'],
          ),
        ],
      ),
      Lesson(
        id: 'family1',
        title: 'Family Members',
        description: 'Learn words for family members in Kinyarwanda',
        order: 2,
        isUnlocked: true,
        isCompleted: false,
        exercises: [
          Exercise(
            id: 'family1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "mother" in Kinyarwanda?',
            correctAnswer: 'Mama',
            options: ['Mama', 'Papa', 'Mwana', 'Murumuna'],
          ),
          Exercise(
            id: 'family2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "father" in Kinyarwanda?',
            correctAnswer: 'Papa',
            options: ['Papa', 'Mama', 'Data', 'Nyoko'],
          ),
          Exercise(
            id: 'family3',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "child" in Kinyarwanda?',
            correctAnswer: 'Umwana',
            options: ['Umwana', 'Murumuna', 'Mushiki', 'Musaza'],
          ),
          Exercise(
            id: 'family4',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "brother" in Kinyarwanda?',
            correctAnswer: 'Murumuna',
            options: ['Murumuna', 'Mushiki', 'Mama', 'Papa'],
          ),
        ],
      ),
      Lesson(
        id: 'numbers-1-10',
        title: 'Numbers 1-10',
        description: 'Learn basic Kinyarwanda numbers from 1 to 10',
        order: 3,
        isUnlocked: true,
        isCompleted: false,
        exercises: [
          Exercise(
            id: 'num1',
            type: ExerciseType.multipleChoice,
            question: 'What is "1" in Kinyarwanda?',
            options: ['rimwe', 'kabiri', 'gatatu', 'kane'],
            correctAnswer: 'rimwe',
          ),
          Exercise(
            id: 'num2',
            type: ExerciseType.multipleChoice,
            question: 'What is "2" in Kinyarwanda?',
            options: ['rimwe', 'kabiri', 'gatatu', 'kane'],
            correctAnswer: 'kabiri',
          ),
          Exercise(
            id: 'num3',
            type: ExerciseType.multipleChoice,
            question: 'What is "3" in Kinyarwanda?',
            options: ['kabiri', 'gatatu', 'kane', 'gatanu'],
            correctAnswer: 'gatatu',
          ),
          Exercise(
            id: 'num4',
            type: ExerciseType.multipleChoice,
            question: 'What is "4" in Kinyarwanda?',
            options: ['gatatu', 'kane', 'gatanu', 'gatandatu'],
            correctAnswer: 'kane',
          ),
          Exercise(
            id: 'num5',
            type: ExerciseType.multipleChoice,
            question: 'What is "5" in Kinyarwanda?',
            options: ['kane', 'gatanu', 'gatandatu', 'karindwi'],
            correctAnswer: 'gatanu',
          ),
          Exercise(
            id: 'num6',
            type: ExerciseType.multipleChoice,
            question: 'What is "6" in Kinyarwanda?',
            options: ['gatanu', 'gatandatu', 'karindwi', 'munani'],
            correctAnswer: 'gatandatu',
          ),
          Exercise(
            id: 'num7',
            type: ExerciseType.multipleChoice,
            question: 'What is "7" in Kinyarwanda?',
            options: ['gatandatu', 'karindwi', 'munani', 'cyenda'],
            correctAnswer: 'karindwi',
          ),
          Exercise(
            id: 'num8',
            type: ExerciseType.multipleChoice,
            question: 'What is "8" in Kinyarwanda?',
            options: ['karindwi', 'umunani', 'cyenda', 'icenda'],
            correctAnswer: 'umunani',
          ),
          Exercise(
            id: 'num9',
            type: ExerciseType.multipleChoice,
            question: 'What is "9" in Kinyarwanda?',
            options: ['umunani', 'icyenda', 'icumi', 'rimwe'],
            correctAnswer: 'icyenda',
          ),
          Exercise(
            id: 'num10',
            type: ExerciseType.multipleChoice,
            question: 'What is "10" in Kinyarwanda?',
            options: ['icyenda', 'icumi', 'rimwe', 'kabiri'],
            correctAnswer: 'icumi',
          ),
        ],
      ),
      Lesson(
        id: 'traditional-proverbs',
        title: 'Traditional Proverbs',
        description: 'Learn wisdom through traditional Rwandan sayings',
        order: 4,
        isUnlocked: true,
        isCompleted: false,
        exercises: [
          Exercise(
            id: 'proverb1',
            type: ExerciseType.translation,
            question: 'What does "Ubwoba bw\'ijisho bubona n\'ubwitange" mean?',
            correctAnswer: 'Fear of the eye sees even courage',
            options: [
              'Fear of the eye sees even courage',
              'The brave never fear anything',
              'Eyes show true feelings',
              'Courage comes from within'
            ],
          ),
          Exercise(
            id: 'proverb2',
            type: ExerciseType.translation,
            question: 'Translate: "Akanyamanza kaziko mu mazu"',
            correctAnswer: 'There is no secrets in houses',
            options: [
              'There is no secrets in houses',
              'Houses have many rooms',
              'Home is where the heart is',
              'Family comes first'
            ],
          ),
          Exercise(
            id: 'proverb3',
            type: ExerciseType.multipleChoice,
            question: 'Which proverb means "Unity is strength"?',
            correctAnswer: 'Ubwiyunge ni imbaraga',
            options: [
              'Ubwiyunge ni imbaraga',
              'Urukundo rugira ubwoba',
              'Inyangamugayo ifata isoko',
              'Akazi kenshi karangwa n\'umuntu umwe'
            ],
          ),
          Exercise(
            id: 'proverb4',
            type: ExerciseType.translation,
            question: 'What does "Urukundo rugira ubwoba" mean?',
            correctAnswer: 'Love conquers fear',
            options: [
              'Love conquers fear',
              'Fear has no love',
              'Love is patient',
              'True love never dies'
            ],
          ),
          Exercise(
            id: 'proverb5',
            type: ExerciseType.multipleChoice,
            question: 'Complete the proverb: "Inyangamugayo ifata..."',
            correctAnswer: 'isoko',
            options: ['isoko', 'umuntu', 'igihe', 'amahirwe'],
          ),
          Exercise(
            id: 'proverb6',
            type: ExerciseType.translation,
            question: 'Translate: "Akazi kenshi karangwa n\'umuntu umwe"',
            correctAnswer: 'Much work is done by one person',
            options: [
              'Much work is done by one person',
              'Many hands make light work',
              'One person cannot do everything',
              'Work brings people together'
            ],
          ),
        ],
      ),
    ];
  }
}
