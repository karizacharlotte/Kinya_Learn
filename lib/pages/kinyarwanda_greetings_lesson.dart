import 'package:flutter/material.dart';
import '../components/image_lesson_player.dart';
import '../data/language_lessons.dart';
import '../models/lesson.dart';

class KinyarwandaGreetingsLesson extends StatefulWidget {
  const KinyarwandaGreetingsLesson({super.key});

  @override
  State<KinyarwandaGreetingsLesson> createState() => _KinyarwandaGreetingsLessonState();
}

class _KinyarwandaGreetingsLessonState extends State<KinyarwandaGreetingsLesson> {
  bool _showQuiz = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<int> _selectedAnswers = [];

  final List<LessonSlide> _greetingSlides = [
    LessonSlide(
      kinyarwandaText: 'Muraho',
      englishTranslation: 'Hello (formal)',
      pronunciation: 'moo-rah-ho',
      notes: 'Used when greeting someone older or in a formal setting. Shows respect.',
    ),
    LessonSlide(
      kinyarwandaText: 'Bite',
      englishTranslation: 'Hello (informal)',
      pronunciation: 'bee-tay',
      notes: 'Casual greeting used with friends, family, and people your age.',
    ),
    LessonSlide(
      kinyarwandaText: 'Mwaramutse',
      englishTranslation: 'Good morning',
      pronunciation: 'mwa-rah-moot-say',
      notes: 'Morning greeting used until around 10 AM.',
    ),
    LessonSlide(
      kinyarwandaText: 'Mwiriwe',
      englishTranslation: 'Good afternoon/evening',
      pronunciation: 'mwee-ree-way',
      notes: 'Used from afternoon until evening.',
    ),
    LessonSlide(
      kinyarwandaText: 'Ijoro ryiza',
      englishTranslation: 'Good night',
      pronunciation: 'ee-jo-ro ree-za',
      notes: 'Used when going to sleep or saying goodbye at night.',
    ),
    LessonSlide(
      kinyarwandaText: 'Murakoze',
      englishTranslation: 'Thank you',
      pronunciation: 'moo-rah-ko-zay',
      notes: 'Polite way to express gratitude.',
    ),
    LessonSlide(
      kinyarwandaText: 'Urakoze',
      englishTranslation: 'Thank you (informal)',
      pronunciation: 'oo-rah-ko-zay',
      notes: 'Casual way to say thank you to friends and family.',
    ),
  ];

  final List<QuizQuestion> _quizQuestions = [
    QuizQuestion(
      question: 'How do you say "Hello" formally in Kinyarwanda?',
      options: ['Bite', 'Muraho', 'Mwaramutse', 'Mwiriwe'],
      correctAnswer: 1,
      explanation: 'Muraho is the formal way to say hello, showing respect to the person you\'re greeting.',
    ),
    QuizQuestion(
      question: 'What does "Mwaramutse" mean?',
      options: ['Good evening', 'Good morning', 'Good night', 'Goodbye'],
      correctAnswer: 1,
      explanation: 'Mwaramutse means "Good morning" and is used until around 10 AM.',
    ),
    QuizQuestion(
      question: 'Which greeting would you use with your friends?',
      options: ['Muraho', 'Bite', 'Mwaramutse', 'Ijoro ryiza'],
      correctAnswer: 1,
      explanation: 'Bite is the informal greeting used with friends, family, and people your age.',
    ),
    QuizQuestion(
      question: 'How do you say "Thank you" politely in Kinyarwanda?',
      options: ['Urakoze', 'Murakoze', 'Bite', 'Muraho'],
      correctAnswer: 1,
      explanation: 'Murakoze is the polite way to express gratitude.',
    ),
    QuizQuestion(
      question: 'What greeting do you use in the afternoon?',
      options: ['Mwaramutse', 'Ijoro ryiza', 'Mwiriwe', 'Bite'],
      correctAnswer: 2,
      explanation: 'Mwiriwe is used from afternoon until evening.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(_quizQuestions.length, -1);
    // Start directly with the quiz since they watched the video already
    _showQuiz = true;
  }

  void _startQuiz() {
    setState(() {
      _showQuiz = true;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswers = List.filled(_quizQuestions.length, -1);
    });
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] == _quizQuestions[_currentQuestionIndex].correctAnswer) {
      _score++;
    }

    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final percentage = (_score / _quizQuestions.length * 100).round();
    final isExcellent = percentage >= 90;
    final isGood = percentage >= 70;
    
    // Mark greetings lesson as completed
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    final greetingsLesson = lessons.firstWhere((lesson) => lesson.id == 'greetings');
    greetingsLesson.isCompleted = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isExcellent 
                ? [Color(0xFF4CAF50), Color(0xFF66BB6A)]
                : isGood 
                  ? [Color(0xFF2196F3), Color(0xFF42A5F5)]
                  : [Color(0xFFFF9800), Color(0xFFFFB74D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isExcellent ? Icons.star : isGood ? Icons.thumb_up : Icons.lightbulb,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              
              SizedBox(height: 24),
              
              // Title
              Text(
                isExcellent ? 'Outstanding!' : isGood ? 'Well Done!' : 'Good Effort!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 8),
              
              // Subtitle
              Text(
                isExcellent 
                  ? 'You\'ve mastered Kinyarwanda greetings!'
                  : isGood 
                    ? 'You have a good grasp of the greetings!'
                    : 'Keep practicing to improve your skills!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 32),
              
              // Score Display
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ' / ${_quizQuestions.length}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showQuiz = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Review Lesson',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showQuiz = true;
                          _currentQuestionIndex = 0;
                          _score = 0;
                          _selectedAnswers = List.filled(_quizQuestions.length, -1);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isExcellent ? Color(0xFF4CAF50) : isGood ? Color(0xFF2196F3) : Color(0xFFFF9800),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Next Lesson Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    _navigateToNextLesson();
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    'Continue to Next Lesson',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _navigateToNextLesson() {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    final currentIndex = lessons.indexWhere((lesson) => lesson.id == 'greetings');
    
    if (currentIndex < lessons.length - 1) {
      // Unlock next lesson
      final nextLesson = lessons[currentIndex + 1];
      nextLesson.isUnlocked = true;
      
      // Navigate to next lesson
      Navigator.of(context).pushReplacementNamed(
        '/lesson-detail',
        arguments: nextLesson,
      );
    } else {
      // Last lesson completed - go back to lessons screen
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Congratulations! You completed all lessons!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          _showQuiz ? 'Greetings Quiz' : 'Kinyarwanda Greetings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _showQuiz ? _buildQuizView() : _buildLessonView(),
    );
  }

  Widget _buildLessonView() {
    return Column(
      children: [
        Expanded(
          child: ImageLessonPlayer(
            title: 'Kinyarwanda Greetings',
            subtitle: 'Master essential greetings and expressions',
            slides: _greetingSlides,
            onCompleted: _startQuiz,
          ),
        ),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.quiz_outlined, size: 20),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Start Knowledge Quiz',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizView() {
    final question = _quizQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _quizQuestions.length;

    return Column(
      children: [
        // Professional Progress Header
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          'of ${_quizQuestions.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Score: $_score',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Question Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.indigo.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.blue.shade600,
                        size: 28,
                      ),
                      SizedBox(height: 16),
                      Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Answer Options
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = _selectedAnswers[_currentQuestionIndex] == index;
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Color(0xFF4CAF50) : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? Color(0xFF4CAF50) : Colors.grey.shade200,
                                  border: Border.all(
                                    color: isSelected ? Color(0xFF4CAF50) : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? Color(0xFF2E7D32) : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Professional Navigation
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showQuiz = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Back to Lesson',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _selectedAnswers[_currentQuestionIndex] != -1 ? _nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentQuestionIndex == _quizQuestions.length - 1 ? 'Finish Quiz' : 'Next Question',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            _currentQuestionIndex == _quizQuestions.length - 1 ? Icons.check_circle : Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
