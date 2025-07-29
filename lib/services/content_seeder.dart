import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';
import '../services/lesson_service.dart';

class ContentSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed initial lessons and content
  static Future<void> seedInitialContent() async {
    try {
      // Check if content already exists
      QuerySnapshot existingLessons = await _firestore
          .collection('lessons')
          .limit(1)
          .get();

      if (existingLessons.docs.isNotEmpty) {
        print('Content already exists, skipping seeding');
        return;
      }

      print('Seeding initial content...');

      // Create initial lessons
      await _createGreetingsLesson();
      await _createBasicVocabularyLesson();
      await _createNumbersLesson();
      await _createFamilyMembersLesson();
      await _createDailyConversationsLesson();

      print('Initial content seeded successfully!');
    } catch (e) {
      print('Error seeding content: $e');
    }
  }

  static Future<void> _createGreetingsLesson() async {
    // Create Greetings Lesson
    LessonModel greetingsLesson = LessonModel(
      id: '',
      title: 'Greetings and Basic Phrases',
      description: 'Learn essential Kinyarwanda greetings and polite expressions for daily interactions.',
      level: 'Beginner',
      order: 1,
      category: 'greetings',
      estimatedDuration: 20,
      objectives: [
        'Master common greetings in Kinyarwanda',
        'Learn appropriate responses to greetings',
        'Understand cultural context of greetings',
        'Practice pronunciation of basic phrases'
      ],
    );

    String? lessonId = await LessonService.createLesson(greetingsLesson);
    if (lessonId == null) return;

    // Create sections for greetings lesson
    await _createGreetingsSections(lessonId);
    await _createGreetingsQuiz(lessonId);
  }

  static Future<void> _createGreetingsSections(String lessonId) async {
    // Section 1: Introduction to Greetings
    SectionModel introSection = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Introduction to Kinyarwanda Greetings',
      type: 'text',
      order: 1,
      content: {
        'text': '''
Greetings are very important in Rwandan culture. They show respect and help build relationships. In this lesson, you'll learn the most common greetings used in daily life.

Key points to remember:
• Greetings vary by time of day
• Age and social status affect which greeting to use
• Always respond appropriately to show respect
• A smile and eye contact are important
        ''',
        'culturalNote': 'In Rwanda, it\'s considered rude not to greet someone you know when you meet them. Taking time to greet properly shows respect and maintains social harmony.',
      },
    );

    // Section 2: Basic Greetings Vocabulary
    SectionModel vocabSection = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Basic Greetings Vocabulary',
      type: 'vocabulary',
      order: 2,
      content: {
        'vocabulary': [
          {
            'kinyarwandaWord': 'Muraho',
            'englishTranslation': 'Hello (formal)',
            'pronunciation': 'moo-rah-ho',
            'audioUrl': 'audio/greetings/muraho.mp3',
            'category': 'greeting',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Mwaramutse',
            'englishTranslation': 'Good morning',
            'pronunciation': 'mwa-rah-moot-say',
            'audioUrl': 'audio/greetings/mwaramutse.mp3',
            'category': 'greeting',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Mwiriwe',
            'englishTranslation': 'Good afternoon/evening',
            'pronunciation': 'mwee-ree-way',
            'audioUrl': 'audio/greetings/mwiriwe.mp3',
            'category': 'greeting',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Ijoro ryiza',
            'englishTranslation': 'Good night',
            'pronunciation': 'ee-jo-ro ree-za',
            'audioUrl': 'audio/greetings/ijoro_ryiza.mp3',
            'category': 'greeting',
            'difficulty': 2,
          },
          {
            'kinyarwandaWord': 'Murakoze',
            'englishTranslation': 'Thank you',
            'pronunciation': 'moo-rah-ko-zay',
            'audioUrl': 'audio/greetings/murakoze.mp3',
            'category': 'politeness',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Urakoze',
            'englishTranslation': 'Thank you (to one person)',
            'pronunciation': 'oo-rah-ko-zay',
            'audioUrl': 'audio/greetings/urakoze.mp3',
            'category': 'politeness',
            'difficulty': 1,
          },
        ]
      },
    );

    // Section 3: Common Dialogue
    SectionModel dialogueSection = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Greeting Conversation',
      type: 'dialogue',
      order: 3,
      content: {
        'dialogue': [
          {
            'speaker': 'Person A',
            'kinyarwandaLine': 'Mwaramutse!',
            'englishTranslation': 'Good morning!',
            'audioUrl': 'audio/dialogues/greeting_1.mp3',
            'context': 'Meeting a friend in the morning'
          },
          {
            'speaker': 'Person B',
            'kinyarwandaLine': 'Mwaramutse, amakuru?',
            'englishTranslation': 'Good morning, how are you?',
            'audioUrl': 'audio/dialogues/greeting_2.mp3',
            'context': 'Responding and asking how they are'
          },
          {
            'speaker': 'Person A',
            'kinyarwandaLine': 'Ni meza, none wowe?',
            'englishTranslation': 'I\'m fine, and you?',
            'audioUrl': 'audio/dialogues/greeting_3.mp3',
            'context': 'Saying you\'re fine and asking back'
          },
          {
            'speaker': 'Person B',
            'kinyarwandaLine': 'Nanjye ni meza, murakoze.',
            'englishTranslation': 'I\'m also fine, thank you.',
            'audioUrl': 'audio/dialogues/greeting_4.mp3',
            'context': 'Confirming you\'re also fine'
          },
        ],
        'culturalContext': 'This is a typical morning greeting between friends or acquaintances. The phrase "amakuru" literally means "news" but is used like "how are you?"'
      },
    );

    // Section 4: Pronunciation Practice
    SectionModel pronunciationSection = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Pronunciation Practice',
      type: 'audio_practice',
      order: 4,
      content: {
        'phrases': [
          {
            'phraseKinyarwanda': 'Muraho',
            'phraseEnglish': 'Hello',
            'audioUrl': 'audio/practice/muraho_practice.mp3',
            'tips': 'The "u" sounds like "oo" in "food". Roll the "r" slightly.'
          },
          {
            'phraseKinyarwanda': 'Mwaramutse',
            'phraseEnglish': 'Good morning',
            'audioUrl': 'audio/practice/mwaramutse_practice.mp3',
            'tips': 'Break it into syllables: mwa-ra-mut-se. Each syllable is equally stressed.'
          },
          {
            'phraseKinyarwanda': 'Murakoze cyane',
            'phraseEnglish': 'Thank you very much',
            'audioUrl': 'audio/practice/murakoze_cyane_practice.mp3',
            'tips': '"Cyane" (very much) is pronounced "cha-nay"'
          },
        ]
      },
    );

    // Create all sections
    await LessonService.createSection(lessonId, introSection);
    await LessonService.createSection(lessonId, vocabSection);
    await LessonService.createSection(lessonId, dialogueSection);
    await LessonService.createSection(lessonId, pronunciationSection);
  }

  static Future<void> _createGreetingsQuiz(String lessonId) async {
    QuizModel greetingsQuiz = QuizModel(
      id: '',
      title: 'Greetings Quiz',
      lessonId: lessonId,
      passingScore: 70,
      questions: [
        QuizQuestion(
          questionText: 'How do you say "Good morning" in Kinyarwanda?',
          type: 'multiple_choice',
          options: ['Mwiriwe', 'Mwaramutse', 'Ijoro ryiza', 'Muraho'],
          correctAnswer: 'Mwaramutse',
          explanation: 'Mwaramutse is the standard greeting used in the morning until around noon.',
        ),
        QuizQuestion(
          questionText: 'What is the appropriate response to "Amakuru?"',
          type: 'multiple_choice',
          options: ['Murakoze', 'Ni meza', 'Mwiriwe', 'Ijoro ryiza'],
          correctAnswer: 'Ni meza',
          explanation: '"Ni meza" means "I\'m fine" and is the standard response to "How are you?"',
        ),
        QuizQuestion(
          questionText: 'Complete the phrase: "Murakoze ____" (Thank you very much)',
          type: 'fill_in_the_blank',
          options: [],
          correctAnswer: 'cyane',
          explanation: '"Cyane" means "very much" or "a lot".',
        ),
        QuizQuestion(
          questionText: 'Which greeting would you use in the evening?',
          type: 'multiple_choice',
          options: ['Mwaramutse', 'Mwiriwe', 'Ijoro ryiza', 'All of the above'],
          correctAnswer: 'Mwiriwe',
          explanation: 'Mwiriwe is used from afternoon until evening. Ijoro ryiza is specifically for saying good night.',
        ),
        QuizQuestion(
          questionText: 'True or False: In Rwandan culture, it\'s acceptable to not greet someone you know.',
          type: 'true_false',
          options: ['True', 'False'],
          correctAnswer: 'False',
          explanation: 'In Rwandan culture, greeting people you know is very important and shows respect.',
        ),
      ],
    );

    await LessonService.createQuiz(greetingsQuiz);
  }

  static Future<void> _createBasicVocabularyLesson() async {
    LessonModel vocabLesson = LessonModel(
      id: '',
      title: 'Basic Vocabulary - Everyday Objects',
      description: 'Learn essential vocabulary for common objects and items used in daily life.',
      level: 'Beginner',
      order: 2,
      category: 'vocabulary',
      estimatedDuration: 25,
      objectives: [
        'Learn names of common household objects',
        'Practice pronunciation of basic vocabulary',
        'Understand noun classifications in Kinyarwanda',
        'Use new vocabulary in simple sentences'
      ],
    );

    String? lessonId = await LessonService.createLesson(vocabLesson);
    if (lessonId == null) return;

    await _createBasicVocabSections(lessonId);
  }

  static Future<void> _createBasicVocabSections(String lessonId) async {
    // Introduction Section
    SectionModel introSection = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Introduction to Kinyarwanda Nouns',
      type: 'text',
      order: 1,
      content: {
        'text': '''
Kinyarwanda, like other Bantu languages, organizes nouns into different classes. Each class has specific prefixes that help identify the type of object or concept being discussed.

In this lesson, we'll focus on:
• Common household objects
• Basic food items
• Everyday tools and items
• Simple sentence structures

Don't worry about memorizing all the grammar rules now - focus on learning the vocabulary first!
        ''',
      },
    );

    // Household Objects Vocabulary
    SectionModel householdVocab = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Household Objects',
      type: 'vocabulary',
      order: 2,
      content: {
        'vocabulary': [
          {
            'kinyarwandaWord': 'Inzu',
            'englishTranslation': 'House',
            'pronunciation': 'een-zoo',
            'category': 'household',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Icyumba',
            'englishTranslation': 'Room',
            'pronunciation': 'ee-choom-ba',
            'category': 'household',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Umwotsi',
            'englishTranslation': 'Door',
            'pronunciation': 'oom-wot-see',
            'category': 'household',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Idirishya',
            'englishTranslation': 'Window',
            'pronunciation': 'ee-dee-ree-sha',
            'category': 'household',
            'difficulty': 2,
          },
          {
            'kinyarwandaWord': 'Igitanda',
            'englishTranslation': 'Bed',
            'pronunciation': 'ee-gee-tan-da',
            'category': 'household',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Intebe',
            'englishTranslation': 'Chair',
            'pronunciation': 'een-te-bay',
            'category': 'household',
            'difficulty': 1,
          },
        ]
      },
    );

    await LessonService.createSection(lessonId, introSection);
    await LessonService.createSection(lessonId, householdVocab);
  }

  static Future<void> _createNumbersLesson() async {
    LessonModel numbersLesson = LessonModel(
      id: '',
      title: 'Numbers 1-20',
      description: 'Learn to count from 1 to 20 in Kinyarwanda and use numbers in basic contexts.',
      level: 'Beginner',
      order: 3,
      category: 'numbers',
      estimatedDuration: 20,
      objectives: [
        'Count from 1 to 20 in Kinyarwanda',
        'Understand number pronunciation',
        'Use numbers to express quantities',
        'Practice number-related conversations'
      ],
    );

    String? lessonId = await LessonService.createLesson(numbersLesson);
    if (lessonId == null) return;

    await _createNumbersSections(lessonId);
  }

  static Future<void> _createNumbersSections(String lessonId) async {
    SectionModel numbersVocab = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Numbers 1-20',
      type: 'vocabulary',
      order: 1,
      content: {
        'vocabulary': [
          {
            'kinyarwandaWord': 'Rimwe',
            'englishTranslation': 'One',
            'pronunciation': 'reem-way',
            'category': 'numbers',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Kabiri',
            'englishTranslation': 'Two',
            'pronunciation': 'ka-bee-ree',
            'category': 'numbers',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Gatatu',
            'englishTranslation': 'Three',
            'pronunciation': 'ga-ta-too',
            'category': 'numbers',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Kane',
            'englishTranslation': 'Four',
            'pronunciation': 'ka-nay',
            'category': 'numbers',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Gatanu',
            'englishTranslation': 'Five',
            'pronunciation': 'ga-ta-noo',
            'category': 'numbers',
            'difficulty': 1,
          },
        ]
      },
    );

    await LessonService.createSection(lessonId, numbersVocab);
  }

  static Future<void> _createFamilyMembersLesson() async {
    LessonModel familyLesson = LessonModel(
      id: '',
      title: 'Family Members',
      description: 'Learn vocabulary for family relationships and how to talk about your family in Kinyarwanda.',
      level: 'Beginner',
      order: 4,
      category: 'family',
      estimatedDuration: 25,
      objectives: [
        'Learn family member vocabulary',
        'Practice describing family relationships',
        'Understand cultural aspects of family in Rwanda',
        'Form simple sentences about family'
      ],
    );

    String? lessonId = await LessonService.createLesson(familyLesson);
    if (lessonId == null) return;

    await _createFamilySections(lessonId);
  }

  static Future<void> _createFamilySections(String lessonId) async {
    SectionModel familyVocab = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'Family Members Vocabulary',
      type: 'vocabulary',
      order: 1,
      content: {
        'vocabulary': [
          {
            'kinyarwandaWord': 'Umuryango',
            'englishTranslation': 'Family',
            'pronunciation': 'oo-moo-ryan-go',
            'category': 'family',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Papa / Se',
            'englishTranslation': 'Father',
            'pronunciation': 'pa-pa / say',
            'category': 'family',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Mama / Nyina',
            'englishTranslation': 'Mother',
            'pronunciation': 'ma-ma / nyee-na',
            'category': 'family',
            'difficulty': 1,
          },
          {
            'kinyarwandaWord': 'Umuvandimwe',
            'englishTranslation': 'Sibling',
            'pronunciation': 'oo-moo-van-dee-mway',
            'category': 'family',
            'difficulty': 2,
          },
          {
            'kinyarwandaWord': 'Umukobwa',
            'englishTranslation': 'Daughter/Girl',
            'pronunciation': 'oo-moo-ko-bwa',
            'category': 'family',
            'difficulty': 1,
          },
        ]
      },
    );

    await LessonService.createSection(lessonId, familyVocab);
  }

  static Future<void> _createDailyConversationsLesson() async {
    LessonModel conversationLesson = LessonModel(
      id: '',
      title: 'Daily Conversations',
      description: 'Practice common conversations you might have in daily life in Rwanda.',
      level: 'Intermediate',
      order: 5,
      category: 'conversation',
      estimatedDuration: 30,
      objectives: [
        'Practice realistic daily conversations',
        'Learn context-appropriate responses',
        'Build confidence in speaking',
        'Understand cultural conversation patterns'
      ],
    );

    String? lessonId = await LessonService.createLesson(conversationLesson);
    if (lessonId == null) return;

    await _createConversationSections(lessonId);
  }

  static Future<void> _createConversationSections(String lessonId) async {
    SectionModel marketConversation = SectionModel(
      id: '',
      lessonId: lessonId,
      title: 'At the Market',
      type: 'dialogue',
      order: 1,
      content: {
        'dialogue': [
          {
            'speaker': 'Customer',
            'kinyarwandaLine': 'Mwaramutse, amakuru?',
            'englishTranslation': 'Good morning, how are things?',
            'context': 'Greeting the vendor'
          },
          {
            'speaker': 'Vendor',
            'kinyarwandaLine': 'Ni meza, murakoze. Ufite iki?',
            'englishTranslation': 'They\'re fine, thank you. What do you need?',
            'context': 'Responding and asking what they want'
          },
          {
            'speaker': 'Customer',
            'kinyarwandaLine': 'Ndashaka amagi.',
            'englishTranslation': 'I want eggs.',
            'context': 'Stating what they want to buy'
          },
          {
            'speaker': 'Vendor',
            'kinyarwandaLine': 'Ni angahe ushaka?',
            'englishTranslation': 'How many do you want?',
            'context': 'Asking about quantity'
          },
        ],
        'culturalContext': 'Market interactions are important social moments in Rwanda. Always greet vendors respectfully before stating your business.'
      },
    );

    await LessonService.createSection(lessonId, marketConversation);
  }
}
