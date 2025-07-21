import '../models/lesson.dart';

class KinyarwandaCultureVideos {
  // Real Kinyarwanda culture videos from YouTube
  static const Map<String, String> cultureVideos = {
    'proverbs': 'https://www.youtube.com/embed/XNhXnuwUI5o',
    'story_telling': 'https://www.youtube.com/embed/AYGZy_aLiuI',
    'traditional_celebrations': 'https://www.youtube.com/embed/z9H-YzfG-YQ',
    'culture_etiquette': 'https://www.youtube.com/embed/dVqm40wcnL4',
    'rwanda_history': 'https://www.youtube.com/embed/TPAo8z4WUeY',
    'modern_rwanda': 'https://www.youtube.com/embed/QQ7mscbSuLk',
  };

  // Get video URL for lesson
  static String? getVideoUrl(String lessonId) {
    return cultureVideos[lessonId];
  }
}

class CultureLessons {
  static List<Lesson> getLessons() {
    return [
      // Culture Lessons (15-20)
      Lesson(
        id: 'proverbs',
        title: 'Proverbs',
        description: 'Learn traditional Kinyarwanda proverbs and their meanings',
        order: 15,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('proverbs'),
        exercises: [
          Exercise(
            id: 'proverb1',
            type: ExerciseType.multipleChoice,
            question: 'What does "Ubwoba bukabije ubwenge" mean?',
            correctAnswer: 'Fear destroys wisdom',
            options: ['Fear destroys wisdom', 'Wisdom brings fear', 'Fear brings wisdom', 'Wisdom destroys fear'],
          ),
          Exercise(
            id: 'proverb2',
            type: ExerciseType.multipleChoice,
            question: 'Complete the proverb: "Urukundo..."',
            correctAnswer: 'rurata ibintu byose',
            options: ['rurata ibintu byose', 'ruhora abantu', 'ruribwa n\'abantu', 'rushaka amafaranga'],
          ),
          Exercise(
            id: 'proverb3',
            type: ExerciseType.multipleChoice,
            question: 'What does "Umuntu ni ubuntu" emphasize?',
            correctAnswer: 'Humanity and compassion',
            options: ['Humanity and compassion', 'Individual strength', 'Material wealth', 'Personal achievement'],
          ),
        ],
      ),

      Lesson(
        id: 'story_telling',
        title: 'Story Telling',
        description: 'Learn traditional Kinyarwanda storytelling techniques and expressions',
        order: 16,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('story_telling'),
        exercises: [
          Exercise(
            id: 'story1',
            type: ExerciseType.multipleChoice,
            question: 'How do you start a traditional story in Kinyarwanda?',
            correctAnswer: 'Gasakara...',
            options: ['Gasakara...', 'Hamwe...', 'Kera...', 'Nyuma...'],
          ),
          Exercise(
            id: 'story2',
            type: ExerciseType.multipleChoice,
            question: 'What is the response to "Gasakara"?',
            correctAnswer: 'Karasaza',
            options: ['Karasaza', 'Twese', 'Niko', 'Sawa'],
          ),
          Exercise(
            id: 'story3',
            type: ExerciseType.multipleChoice,
            question: 'Traditional stories often teach about:',
            correctAnswer: 'Moral values',
            options: ['Moral values', 'Modern technology', 'Western culture', 'Urban life'],
          ),
        ],
      ),

      Lesson(
        id: 'traditional_celebrations',
        title: 'Traditional Celebrations',
        description: 'Learn about traditional Rwandan celebrations and ceremonies',
        order: 17,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('traditional_celebrations'),
        exercises: [
          Exercise(
            id: 'celebration1',
            type: ExerciseType.multipleChoice,
            question: 'What is "Kwita Izina"?',
            correctAnswer: 'Gorilla naming ceremony',
            options: ['Gorilla naming ceremony', 'Wedding ceremony', 'Harvest festival', 'New Year celebration'],
          ),
          Exercise(
            id: 'celebration2',
            type: ExerciseType.multipleChoice,
            question: 'What is "Umuganda"?',
            correctAnswer: 'Community work day',
            options: ['Community work day', 'Religious festival', 'Dance competition', 'Food festival'],
          ),
          Exercise(
            id: 'celebration3',
            type: ExerciseType.multipleChoice,
            question: 'Traditional Rwandan dance is called:',
            correctAnswer: 'Intore',
            options: ['Intore', 'Ikinyamasyo', 'Urukerereza', 'Amahoro'],
          ),
        ],
      ),

      Lesson(
        id: 'culture_etiquette',
        title: 'Culture Etiquette',
        description: 'Learn about Rwandan cultural norms and proper etiquette',
        order: 18,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('culture_etiquette'),
        exercises: [
          Exercise(
            id: 'etiquette1',
            type: ExerciseType.multipleChoice,
            question: 'When greeting elders, you should:',
            correctAnswer: 'Use both hands and bow slightly',
            options: ['Use both hands and bow slightly', 'Wave casually', 'Shake hands firmly', 'Nod your head'],
          ),
          Exercise(
            id: 'etiquette2',
            type: ExerciseType.multipleChoice,
            question: 'What does "Ubushake" mean in Rwandan culture?',
            correctAnswer: 'Hospitality',
            options: ['Hospitality', 'Respect', 'Forgiveness', 'Wisdom'],
          ),
          Exercise(
            id: 'etiquette3',
            type: ExerciseType.multipleChoice,
            question: 'In Rwandan culture, which is most important?',
            correctAnswer: 'Unity and reconciliation',
            options: ['Unity and reconciliation', 'Individual achievement', 'Material wealth', 'Competition'],
          ),
        ],
      ),

      Lesson(
        id: 'rwanda_history',
        title: 'Rwanda History',
        description: 'Learn about the history of Rwanda and its people',
        order: 19,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('rwanda_history'),
        exercises: [
          Exercise(
            id: 'history1',
            type: ExerciseType.multipleChoice,
            question: 'Rwanda gained independence in which year?',
            correctAnswer: '1962',
            options: ['1962', '1959', '1961', '1963'],
          ),
          Exercise(
            id: 'history2',
            type: ExerciseType.multipleChoice,
            question: 'The traditional kingdom of Rwanda was ruled by:',
            correctAnswer: 'Mwami (King)',
            options: ['Mwami (King)', 'President', 'Prime Minister', 'Chief'],
          ),
          Exercise(
            id: 'history3',
            type: ExerciseType.multipleChoice,
            question: 'What happened in Rwanda in 1994?',
            correctAnswer: 'Genocide against the Tutsi',
            options: ['Genocide against the Tutsi', 'Independence', 'Civil war', 'Natural disaster'],
          ),
        ],
      ),

      Lesson(
        id: 'modern_rwanda',
        title: 'Modern Rwanda',
        description: 'Learn about contemporary Rwanda and its development',
        order: 20,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: KinyarwandaCultureVideos.getVideoUrl('modern_rwanda'),
        exercises: [
          Exercise(
            id: 'modern1',
            type: ExerciseType.multipleChoice,
            question: 'Rwanda is known for its progress in:',
            correctAnswer: 'Technology and gender equality',
            options: ['Technology and gender equality', 'Mining and oil', 'Tourism only', 'Agriculture only'],
          ),
          Exercise(
            id: 'modern2',
            type: ExerciseType.multipleChoice,
            question: 'Rwanda has banned which environmental pollutant?',
            correctAnswer: 'Plastic bags',
            options: ['Plastic bags', 'Cars', 'Factories', 'Phones'],
          ),
          Exercise(
            id: 'modern3',
            type: ExerciseType.multipleChoice,
            question: 'What is Rwanda\'s Vision 2020 about?',
            correctAnswer: 'Becoming a middle-income country',
            options: ['Becoming a middle-income country', 'Building more cities', 'Increasing population', 'Expanding territory'],
          ),
        ],
      ),
    ];
  }
}
