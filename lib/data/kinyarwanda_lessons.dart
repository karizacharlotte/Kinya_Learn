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
        videoUrl: 'https://www.youtube.com/watch?v=BZCuHpFhuaQ&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=1&t=1s',
        videoTitle: 'Kinyarwanda Greetings - Hello, Good Morning & More',
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
        videoUrl: 'https://www.youtube.com/watch?v=q7Vl2eQIvIo&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=12',
        videoTitle: 'Family Members in Kinyarwanda - Mother, Father, Children',
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
        videoUrl: 'https://www.youtube.com/watch?v=pnSJPFRJ99g&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=4',
        videoTitle: 'Counting 1-10 in Kinyarwanda - Numbers Made Easy',
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
        videoUrl: 'https://www.youtube.com/watch?v=XNhXnuwUI5o',
        videoTitle: 'Rwandan Wisdom - Traditional Proverbs Explained',
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

      // New lessons based on your video content
      Lesson(
        id: 'alphabet-vocabulary',
        title: 'Alphabet & Vocabulary',
        description: 'Learn the 24 letters of Kinyarwanda alphabet and basic vocabulary',
        order: 5,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=xOU7nfCc_y4&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=2&t=2s',
        videoTitle: 'Kinyarwanda Alphabet (24 letters) & Vocabulary',
        exercises: [
          Exercise(
            id: 'alphabet1',
            type: ExerciseType.multipleChoice,
            question: 'How many letters are in the Kinyarwanda alphabet?',
            correctAnswer: '24',
            options: ['22', '24', '26', '28'],
          ),
          Exercise(
            id: 'alphabet2',
            type: ExerciseType.multipleChoice,
            question: 'Which letter is NOT in the Kinyarwanda alphabet?',
            correctAnswer: 'Q',
            options: ['R', 'W', 'Q', 'Y'],
          ),
        ],
      ),

      Lesson(
        id: 'introductions',
        title: 'How to Introduce Yourself',
        description: 'Learn to introduce yourself in Kinyarwanda',
        order: 6,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=tV0metUxKFo&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=3',
        videoTitle: 'How to Introduce Yourself in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'intro1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "My name is..." in Kinyarwanda?',
            correctAnswer: 'Nitwa...',
            options: ['Nitwa...', 'Ndi...', 'Nkora...', 'Ntuye...'],
          ),
          Exercise(
            id: 'intro2',
            type: ExerciseType.multipleChoice,
            question: 'How do you ask "What is your name?" in Kinyarwanda?',
            correctAnswer: 'Witwa rite?',
            options: ['Witwa rite?', 'Uri he?', 'Ukora iki?', 'Ufite imyaka ingahe?'],
          ),
        ],
      ),

      Lesson(
        id: 'age-birth-year',
        title: 'Age & Birth Year',
        description: 'Learn specific numbers for expressing age and birth year',
        order: 7,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=bFEK5uUkwS8&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=5',
        videoTitle: 'Specific Numbers: Age & Birth Year in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'age1',
            type: ExerciseType.multipleChoice,
            question: 'How do you ask "How old are you?" in Kinyarwanda?',
            correctAnswer: 'Ufite imyaka ingahe?',
            options: ['Ufite imyaka ingahe?', 'Wavutse ryari?', 'Witwa rite?', 'Ukomoka he?'],
          ),
          Exercise(
            id: 'age2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "I am 25 years old" in Kinyarwanda?',
            correctAnswer: 'Mfite imyaka makumyabiri na gatanu',
            options: [
              'Mfite imyaka makumyabiri na gatanu',
              'Mfite imyaka makumyabiri',
              'Mfite imyaka gatanu',
              'Mfite imyaka mirongo ibiri'
            ],
          ),
        ],
      ),

      Lesson(
        id: 'days-weeks-months',
        title: 'Days, Weeks & Months',
        description: 'Learn time expressions in Kinyarwanda',
        order: 8,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=xTkw_dSy6zU&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=6',
        videoTitle: 'Days, Weeks & Months in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'time1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "Monday" in Kinyarwanda?',
            correctAnswer: 'Ku wa mbere',
            options: ['Ku wa mbere', 'Ku wa kabiri', 'Ku wa gatatu', 'Ku wa kane'],
          ),
          Exercise(
            id: 'time2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "week" in Kinyarwanda?',
            correctAnswer: 'Icyumweru',
            options: ['Icyumweru', 'Ukwezi', 'Umunsi', 'Umwaka'],
          ),
        ],
      ),

      Lesson(
        id: 'body-parts',
        title: 'Body Parts',
        description: 'Learn names of body parts in Kinyarwanda',
        order: 9,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=uEIu7tYYMF0&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=11',
        videoTitle: 'Body Parts in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'body1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "head" in Kinyarwanda?',
            correctAnswer: 'Umutwe',
            options: ['Umutwe', 'Amaso', 'Ukuboko', 'Ukuguru'],
          ),
          Exercise(
            id: 'body2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "eyes" in Kinyarwanda?',
            correctAnswer: 'Amaso',
            options: ['Amaso', 'Amatwi', 'Umutwe', 'Ijisho'],
          ),
        ],
      ),

      Lesson(
        id: 'colors',
        title: 'Colors (Amabara)',
        description: 'Learn color names in Kinyarwanda',
        order: 10,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=RJAndvI_0FE&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=14',
        videoTitle: 'Amabara - Colors in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'color1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "red" in Kinyarwanda?',
            correctAnswer: 'Umutuku',
            options: ['Umutuku', 'Umweru', 'Ubururu', 'Umuhondo'],
          ),
          Exercise(
            id: 'color2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "white" in Kinyarwanda?',
            correctAnswer: 'Umweru',
            options: ['Umweru', 'Umwirabura', 'Umutuku', 'Ubururu'],
          ),
        ],
      ),

      Lesson(
        id: 'time-telling',
        title: 'How to Tell Time',
        description: 'Learn to express time in Kinyarwanda',
        order: 11,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=85N2bLIoG7o&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=10',
        videoTitle: 'How to Tell Time in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'clock1',
            type: ExerciseType.multipleChoice,
            question: 'How do you ask "What time is it?" in Kinyarwanda?',
            correctAnswer: 'Ni saa zingahe?',
            options: ['Ni saa zingahe?', 'Ni ryari?', 'Ni iki gihe?', 'Ni igihe ki?'],
          ),
          Exercise(
            id: 'clock2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "It\'s 3 o\'clock" in Kinyarwanda?',
            correctAnswer: 'Ni saa cumi na gatatu',
            options: ['Ni saa cumi na gatatu', 'Ni saa gatatu', 'Ni saa cumi', 'Ni saa icyenda'],
          ),
        ],
      ),

      Lesson(
        id: 'expression',
        title: 'How to Express Yourself',
        description: 'Learn expressions for feelings and emotions',
        order: 12,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=8YfxN6RIEoQ&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=15',
        videoTitle: 'How to Express Yourself in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'expr1',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "I am happy" in Kinyarwanda?',
            correctAnswer: 'Nishimye',
            options: ['Nishimye', 'Ndababaye', 'Mfite ubwoba', 'Ndakize'],
          ),
          Exercise(
            id: 'expr2',
            type: ExerciseType.multipleChoice,
            question: 'How do you say "I am sad" in Kinyarwanda?',
            correctAnswer: 'Ndababaye',
            options: ['Ndababaye', 'Nishimye', 'Ndaseka', 'Ndashaka'],
          ),
        ],
      ),

      Lesson(
        id: 'slang',
        title: 'Kinyarwanda Slang',
        description: 'Learn modern Kinyarwanda slang expressions',
        order: 13,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=OyeCndg3C5I&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=8&t=131s',
        videoTitle: 'Kinyarwanda Slang - Modern Expressions',
        exercises: [
          Exercise(
            id: 'slang1',
            type: ExerciseType.multipleChoice,
            question: 'What does "Bite" mean in Kinyarwanda slang?',
            correctAnswer: 'What\'s up?/How are things?',
            options: ['What\'s up?/How are things?', 'Goodbye', 'Thank you', 'See you later'],
          ),
          Exercise(
            id: 'slang2',
            type: ExerciseType.multipleChoice,
            question: 'What does "Sawa" mean in Kinyarwanda slang?',
            correctAnswer: 'Okay/Fine/Good',
            options: ['Okay/Fine/Good', 'Bad', 'Maybe', 'Never'],
          ),
        ],
      ),

      Lesson(
        id: 'national-anthem',
        title: 'National Anthem',
        description: 'Learn Rwanda\'s national anthem in Kinyarwanda',
        order: 14,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=5ben7uvu9rQ&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=7',
        videoTitle: 'Rwanda National Anthem in Kinyarwanda',
        exercises: [
          Exercise(
            id: 'anthem1',
            type: ExerciseType.multipleChoice,
            question: 'What is the first line of Rwanda\'s national anthem?',
            correctAnswer: 'Rwanda nziza Gihugu cyacu',
            options: [
              'Rwanda nziza Gihugu cyacu',
              'Reka tukurate ubwiyunge',
              'Ubwoba n\'ubugome biguhesha',
              'Horana Imana mubyukuri'
            ],
          ),
          Exercise(
            id: 'anthem2',
            type: ExerciseType.translation,
            question: 'Translate: "Rwanda nziza Gihugu cyacu"',
            correctAnswer: 'Beautiful Rwanda, our country',
            options: [
              'Beautiful Rwanda, our country',
              'Rwanda is our homeland',
              'We love our Rwanda',
              'Rwanda forever'
            ],
          ),
        ],
      ),

      Lesson(
        id: 'rwanda-geography',
        title: 'Rwanda Facts & Geography',
        description: 'Learn about Rwanda\'s geography and interesting facts',
        order: 15,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=aPxb2QdM60w&list=PLidQjiFmWUD30HiWl5ddWD7HWJc7Hugx1&index=13',
        videoTitle: 'Rwanda Facts & Geography',
        exercises: [
          Exercise(
            id: 'geo1',
            type: ExerciseType.multipleChoice,
            question: 'What is Rwanda commonly known as?',
            correctAnswer: 'Land of a Thousand Hills',
            options: [
              'Land of a Thousand Hills',
              'Heart of Africa',
              'Pearl of Africa',
              'Land of Lakes'
            ],
          ),
          Exercise(
            id: 'geo2',
            type: ExerciseType.multipleChoice,
            question: 'What is the capital city of Rwanda?',
            correctAnswer: 'Kigali',
            options: ['Kigali', 'Butare', 'Gisenyi', 'Ruhengeri'],
          ),
        ],
      ),

      // Cultural Content Section
      Lesson(
        id: 'storytelling',
        title: 'Traditional Storytelling',
        description: 'Experience traditional Rwandan storytelling',
        order: 16,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=AYGZy_aLiuI',
        videoTitle: 'Traditional Rwandan Storytelling',
        exercises: [
          Exercise(
            id: 'story1',
            type: ExerciseType.multipleChoice,
            question: 'Traditional Rwandan stories often begin with which phrase?',
            correctAnswer: 'Hashize ho...',
            options: ['Hashize ho...', 'Mu bihe bya kera...', 'Rimwe...', 'Mu Rwanda...'],
          ),
          Exercise(
            id: 'story2',
            type: ExerciseType.multipleChoice,
            question: 'What are traditional Rwandan stories called?',
            correctAnswer: 'Imigani',
            options: ['Imigani', 'Ibisigo', 'Imihango', 'Imiririmbagiye'],
          ),
        ],
      ),

      Lesson(
        id: 'traditional-celebrations',
        title: 'Traditional Celebrations',
        description: 'Learn about Rwandan cultural celebrations and festivals',
        order: 17,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=z9H-YzfG-YQ',
        videoTitle: 'Traditional Rwandan Celebrations',
        exercises: [
          Exercise(
            id: 'celeb1',
            type: ExerciseType.multipleChoice,
            question: 'What is the traditional Rwandan naming ceremony called?',
            correctAnswer: 'Kwita izina',
            options: ['Kwita izina', 'Guca urugo', 'Kuraguza ubwoba', 'Kwihangana'],
          ),
          Exercise(
            id: 'celeb2',
            type: ExerciseType.multipleChoice,
            question: 'What is the traditional Rwandan wedding ceremony called?',
            correctAnswer: 'Guca urugo',
            options: ['Guca urugo', 'Kwita izina', 'Kuraguza ubwoba', 'Kubyina'],
          ),
        ],
      ),

      Lesson(
        id: 'culture-etiquette',
        title: 'Cultural Etiquette',
        description: 'Learn proper behavior and manners in Rwandan culture',
        order: 18,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=dVqm40wcnL4',
        videoTitle: 'Rwandan Cultural Etiquette',
        exercises: [
          Exercise(
            id: 'etiq1',
            type: ExerciseType.multipleChoice,
            question: 'In Rwandan culture, how should you greet an elder?',
            correctAnswer: 'With both hands and a slight bow',
            options: [
              'With both hands and a slight bow',
              'With a firm handshake',
              'With a wave',
              'With a nod'
            ],
          ),
          Exercise(
            id: 'etiq2',
            type: ExerciseType.multipleChoice,
            question: 'What should you do when receiving something from someone in Rwanda?',
            correctAnswer: 'Use both hands',
            options: ['Use both hands', 'Use your right hand only', 'Use your left hand only', 'Point at it'],
          ),
        ],
      ),

      Lesson(
        id: 'rwanda-history',
        title: 'Rwanda History',
        description: 'Learn about the rich history of Rwanda',
        order: 19,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=TPAo8z4WUeY',
        videoTitle: 'Rwanda History - Past and Present',
        exercises: [
          Exercise(
            id: 'hist1',
            type: ExerciseType.multipleChoice,
            question: 'When did Rwanda gain independence?',
            correctAnswer: '1962',
            options: ['1962', '1960', '1959', '1964'],
          ),
          Exercise(
            id: 'hist2',
            type: ExerciseType.multipleChoice,
            question: 'What are the three traditional ethnic groups in Rwanda?',
            correctAnswer: 'Hutu, Tutsi, and Twa',
            options: [
              'Hutu, Tutsi, and Twa',
              'Bantu, Nilotic, and Pygmy',
              'Northern, Central, and Southern',
              'Farmers, Herders, and Hunters'
            ],
          ),
        ],
      ),

      Lesson(
        id: 'modern-rwanda',
        title: 'Modern Rwanda',
        description: 'Discover contemporary Rwanda and its development',
        order: 20,
        isUnlocked: true,
        isCompleted: false,
        videoUrl: 'https://www.youtube.com/watch?v=QQ7mscbSuLk',
        videoTitle: 'Modern Rwanda - Today and Tomorrow',
        exercises: [
          Exercise(
            id: 'modern1',
            type: ExerciseType.multipleChoice,
            question: 'What is Rwanda\'s vision for 2050 called?',
            correctAnswer: 'Vision 2050',
            options: ['Vision 2050', 'Rwanda 2050', 'Future Rwanda', 'New Rwanda'],
          ),
          Exercise(
            id: 'modern2',
            type: ExerciseType.multipleChoice,
            question: 'What sector is Rwanda particularly known for in technology?',
            correctAnswer: 'ICT and Innovation',
            options: ['ICT and Innovation', 'Manufacturing', 'Mining', 'Textiles'],
          ),
        ],
      ),
    ];
  }
}
