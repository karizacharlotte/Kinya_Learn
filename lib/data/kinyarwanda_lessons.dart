import '../models/lesson.dart';

class KinyarwandaLessons {
  static List<Lesson> getLessons() {
    return [
      Lesson(
        id: 'basics1',
        title: 'Basic Greetings',
        description: 'Learn essential greetings and polite expressions used in daily Kinyarwanda conversations. Master the art of saying hello, goodbye, and showing respect.',
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'assets/videos/greetings_basic.mp4',
        exercises: [
          Exercise(
            id: 'greeting1',
            question: 'How do you say "Hello" in Kinyarwanda?',
            options: ['Muraho', 'Mwaramutse', 'Muriho', 'Amahoro'],
            correctAnswer: 'Muraho',
            explanation: 'Muraho is the most common and versatile greeting in Kinyarwanda. It can be used at any time of day and is appropriate for both formal and informal situations.',
          ),
          Exercise(
            id: 'greeting2',
            question: 'How do you say "Good morning" in Kinyarwanda?',
            options: ['Muraho', 'Mwaramutse', 'Muriho', 'Amahoro'],
            correctAnswer: 'Mwaramutse',
            explanation: 'Mwaramutse is specifically used to greet someone in the morning. It shows respect and is commonly used in formal situations.',
          ),
          Exercise(
            id: 'greeting3',
            question: 'How do you say "Thank you" in Kinyarwanda?',
            options: ['Urakoze', 'Uraho', 'Amahoro', 'Muriho'],
            correctAnswer: 'Urakoze',
            explanation: 'Urakoze means thank you. It\'s an essential polite expression that shows gratitude and respect in Kinyarwanda culture.',
          ),
          Exercise(
            id: 'greeting4',
            question: 'How do you say "Goodbye" in Kinyarwanda?',
            options: ['Muraho', 'Mwaramutse', 'Muriho', 'Amahoro'],
            correctAnswer: 'Muriho',
            explanation: 'Muriho is used when parting ways with someone. It\'s the standard way to say goodbye in Kinyarwanda.',
          ),
          Exercise(
            id: 'greeting5',
            question: 'How do you say "Peace" in Kinyarwanda?',
            options: ['Urakoze', 'Uraho', 'Amahoro', 'Muriho'],
            correctAnswer: 'Amahoro',
            explanation: 'Amahoro means peace. It\'s often used as a greeting and reflects the importance of peace in Rwandan culture.',
          ),
        ],
      ),
      
      Lesson(
        id: 'family1',
        title: 'Family Members',
        description: 'Discover the words for family members in Kinyarwanda. Learn how to talk about your family and understand family relationships.',
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'assets/videos/family_members.mp4',
        exercises: [
          Exercise(
            id: 'family1',
            question: 'How do you say "mother" in Kinyarwanda?',
            options: ['Mama', 'Papa', 'Mwana', 'Murumuna'],
            correctAnswer: 'Mama',
            explanation: 'Mama means mother in Kinyarwanda. It\'s a universal term of endearment and respect.',
          ),
          Exercise(
            id: 'family2',
            question: 'How do you say "father" in Kinyarwanda?',
            options: ['Papa', 'Mama', 'Data', 'Nyoko'],
            correctAnswer: 'Papa',
            explanation: 'Papa means father. While "Data" is also used, "Papa" is more commonly used in everyday conversation.',
          ),
          Exercise(
            id: 'family3',
            question: 'How do you say "child" in Kinyarwanda?',
            options: ['Umwana', 'Murumuna', 'Mushiki', 'Musaza'],
            correctAnswer: 'Umwana',
            explanation: 'Umwana means child. The "u-" prefix indicates singular form in Kinyarwanda.',
          ),
          Exercise(
            id: 'family4',
            question: 'How do you say "brother" in Kinyarwanda?',
            options: ['Murumuna', 'Mushiki', 'Musaza', 'Umwana'],
            correctAnswer: 'Murumuna',
            explanation: 'Murumuna means younger brother. For older brother, "Musaza" is used.',
          ),
          Exercise(
            id: 'family5',
            question: 'How do you say "sister" in Kinyarwanda?',
            options: ['Mushiki', 'Murumuna', 'Mama', 'Umwana'],
            correctAnswer: 'Mushiki',
            explanation: 'Mushiki means sister. This term is used for sisters regardless of age.',
          ),
        ],
      ),
      
      Lesson(
        id: 'numbers1',
        title: 'Numbers 1-10',
        description: 'Master the basic numbers in Kinyarwanda from 1 to 10. Essential for counting, age, time, and everyday conversations.',
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'assets/videos/numbers_basic.mp4',
        exercises: [
          Exercise(
            id: 'numbers1',
            question: 'How do you say "one" in Kinyarwanda?',
            options: ['Rimwe', 'Kabiri', 'Gatatu', 'Kane'],
            correctAnswer: 'Rimwe',
            explanation: 'Rimwe means one. It\'s the foundation of counting in Kinyarwanda.',
          ),
          Exercise(
            id: 'numbers2',
            question: 'How do you say "two" in Kinyarwanda?',
            options: ['Rimwe', 'Kabiri', 'Gatatu', 'Kane'],
            correctAnswer: 'Kabiri',
            explanation: 'Kabiri means two. Notice the "ka-" prefix which is common in Kinyarwanda numbers.',
          ),
          Exercise(
            id: 'numbers3',
            question: 'How do you say "three" in Kinyarwanda?',
            options: ['Kabiri', 'Gatatu', 'Kane', 'Gatanu'],
            correctAnswer: 'Gatatu',
            explanation: 'Gatatu means three. The "ga-" prefix is another common pattern in Kinyarwanda numbers.',
          ),
          Exercise(
            id: 'numbers4',
            question: 'How do you say "five" in Kinyarwanda?',
            options: ['Kane', 'Gatanu', 'Gatandatu', 'Karindwi'],
            correctAnswer: 'Gatanu',
            explanation: 'Gatanu means five. It\'s a key number for counting and time expressions.',
          ),
          Exercise(
            id: 'numbers5',
            question: 'How do you say "ten" in Kinyarwanda?',
            options: ['Umunani', 'Icyenda', 'Icumi', 'Karindwi'],
            correctAnswer: 'Icumi',
            explanation: 'Icumi means ten. It\'s the base for counting higher numbers in Kinyarwanda.',
          ),
        ],
      ),
      
      Lesson(
        id: 'daily1',
        title: 'Daily Conversations',
        description: 'Practice common phrases and expressions used in everyday Kinyarwanda conversations. From asking "How are you?" to basic responses.',
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'assets/videos/daily_conversations.mp4',
        exercises: [
          Exercise(
            id: 'daily1',
            question: 'How do you ask "How are you?" in Kinyarwanda?',
            options: ['Amakuru?', 'Urakoze', 'Muraho', 'Muriho'],
            correctAnswer: 'Amakuru?',
            explanation: 'Amakuru? literally means "what news?" and is the standard way to ask "How are you?" in Kinyarwanda.',
          ),
          Exercise(
            id: 'daily2',
            question: 'How do you respond "I\'m fine" in Kinyarwanda?',
            options: ['Ni meza', 'Amakuru', 'Urakoze', 'Muraho'],
            correctAnswer: 'Ni meza',
            explanation: 'Ni meza means "I\'m fine" or "It\'s good". It\'s the standard positive response to Amakuru?',
          ),
          Exercise(
            id: 'daily3',
            question: 'How do you say "Please" in Kinyarwanda?',
            options: ['Nyabuna', 'Urakoze', 'Mwihangane', 'Muraho'],
            correctAnswer: 'Nyabuna',
            explanation: 'Nyabuna means please. It\'s an essential polite expression in Kinyarwanda.',
          ),
          Exercise(
            id: 'daily4',
            question: 'How do you say "Excuse me" in Kinyarwanda?',
            options: ['Mwihangane', 'Urakoze', 'Nyabuna', 'Muraho'],
            correctAnswer: 'Mwihangane',
            explanation: 'Mwihangane means excuse me or sorry. It\'s used to get attention or apologize politely.',
          ),
          Exercise(
            id: 'daily5',
            question: 'How do you say "Yes" in Kinyarwanda?',
            options: ['Yego', 'Oya', 'Amakuru', 'Muraho'],
            correctAnswer: 'Yego',
            explanation: 'Yego means yes. It\'s the standard affirmative response in Kinyarwanda.',
          ),
        ],
      ),
      
      Lesson(
        id: 'traditional-proverbs',
        title: 'Traditional Proverbs',
        description: 'Explore the wisdom of Kinyarwanda through traditional proverbs and sayings. Understand the cultural context and deeper meanings.',
        isUnlocked: false,
        isCompleted: false,
        videoUrl: 'assets/videos/traditional_proverbs.mp4',
        exercises: [
          Exercise(
            id: 'proverb1',
            question: 'What does "Umwana ni umwana w\'umuntu" mean?',
            options: ['A child is a child of a person', 'A child is precious', 'Children are important', 'A child belongs to everyone'],
            correctAnswer: 'A child belongs to everyone',
            explanation: 'This proverb emphasizes the communal responsibility for raising children in Rwandan culture.',
          ),
          Exercise(
            id: 'proverb2',
            question: 'What does "Kwihangana ni umuti" mean?',
            options: ['Patience is medicine', 'Patience is important', 'Medicine is good', 'Patience is hard'],
            correctAnswer: 'Patience is medicine',
            explanation: 'This proverb teaches that patience can heal and solve problems, just like medicine.',
          ),
          Exercise(
            id: 'proverb3',
            question: 'What does "Ubwoba ni inzira y\'ubupfu" mean?',
            options: ['Fear is the path to poverty', 'Fear is bad', 'Poverty is fear', 'Fear causes problems'],
            correctAnswer: 'Fear is the path to poverty',
            explanation: 'This proverb warns that fear can prevent success and lead to missed opportunities.',
          ),
        ],
      ),
    ];
  }
}
