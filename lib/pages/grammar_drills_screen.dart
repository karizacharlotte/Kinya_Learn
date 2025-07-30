import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GrammarDrillsScreen extends StatefulWidget {
  const GrammarDrillsScreen({super.key});

  @override
  State<GrammarDrillsScreen> createState() => _GrammarDrillsScreenState();
}

class _GrammarDrillsScreenState extends State<GrammarDrillsScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;
  int totalQuestions = 0;

  final List<Map<String, dynamic>> grammarQuestions = [
    {
      'question': 'Complete the sentence: "Ndashaka _____ amazi"',
      'options': ['kunywa', 'kurya', 'gukora', 'kwiga'],
      'correct': 0,
      'explanation': '"Kunywa" means "to drink", so "Ndashaka kunywa amazi" means "I want to drink water"',
    },
    {
      'question': 'What is the correct plural form of "umwana" (child)?',
      'options': ['abana', 'imwana', 'umwanas', 'bwana'],
      'correct': 0,
      'explanation': '"Abana" is the correct plural form of "umwana"',
    },
    {
      'question': 'Choose the correct greeting for morning:',
      'options': ['Mwiriwe', 'Mwaramutse', 'Muraho', 'Muramuke'],
      'correct': 1,
      'explanation': '"Mwaramutse" is the correct morning greeting',
    },
    {
      'question': 'Complete: "Ni _____ icyumba cy\'amafaranga?"',
      'options': ['hehe', 'ryari', 'kangahe', 'nde'],
      'correct': 0,
      'explanation': '"Hehe" means "where", so the sentence asks "Where is the bank?"',
    },
    {
      'question': 'What does "Nzaba" mean in English?',
      'options': ['I will be', 'I was', 'I am', 'I have'],
      'correct': 0,
      'explanation': '"Nzaba" is the future tense meaning "I will be"',
    },
    {
      'question': 'Choose the correct possessive: "My book"',
      'options': ['igitabo cyawe', 'igitabo cyanjye', 'igitabo cye', 'igitabo cyabo'],
      'correct': 1,
      'explanation': '"Igitabo cyanjye" means "my book"',
    },
    {
      'question': 'Complete the sentence: "Turagenda _____ ishuri"',
      'options': ['mu', 'ku', 'muri', 'kuri'],
      'correct': 0,
      'explanation': '"Mu" is used for "to/at school" - "Turagenda mu ishuri"',
    },
    {
      'question': 'What is the correct past tense of "kugenda" (to go)?',
      'options': ['nagiye', 'ngenda', 'nzagenda', 'ngende'],
      'correct': 0,
      'explanation': '"Nagiye" is the past tense meaning "I went"',
    },
    {
      'question': 'Choose the correct question word for "How many?":',
      'options': ['Angahe', 'Ryari', 'Hehe', 'Nde'],
      'correct': 0,
      'explanation': '"Angahe" means "how many"',
    },
    {
      'question': 'Complete: "Abana _____ mu ishuri"',
      'options': ['bari', 'ari', 'uri', 'ndi'],
      'correct': 0,
      'explanation': '"Bari" is used for plural subjects - "Children are at school"',
    },
  ];

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
  }

  void _shuffleQuestions() {
    grammarQuestions.shuffle();
  }

  void _checkAnswer() {
    final correctAnswer = grammarQuestions[currentQuestionIndex]['correct'];
    
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showResult = true;
      totalQuestions++;
      if (isCorrect) score++;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < grammarQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grammar Drills Complete!'),
        content: Text('Your score: $score / $totalQuestions'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Return to Practice'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                totalQuestions = 0;
                selectedAnswer = null;
                showResult = false;
              });
              _shuffleQuestions();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [theme.colorScheme.surface, theme.colorScheme.surface]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grammar Drills',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Master Kinyarwanda sentence structure',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.school,
                    color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                    size: isTablet ? 36 : 32),
              ],
            ),
          ),
          // Progress
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / grammarQuestions.length,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentQuestionIndex + 1}/${grammarQuestions.length}',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Question Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(
                      color: AppTheme.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: AppTheme.primaryOrange, size: isTablet ? 24 : 20),
                          SizedBox(width: isTablet ? 8 : 6),
                          Text(
                            'Score: $score / $totalQuestions',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Question
                      Text(
                        grammarQuestions[currentQuestionIndex]['question'],
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Options
                      ...List.generate(
                        grammarQuestions[currentQuestionIndex]['options'].length,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: showResult ? null : () {
                                setState(() {
                                  selectedAnswer = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                              child: Container(
                                padding: EdgeInsets.all(isTablet ? 16 : 12),
                                decoration: BoxDecoration(
                                  color: showResult
                                      ? (index == grammarQuestions[currentQuestionIndex]['correct']
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : (index == selectedAnswer && selectedAnswer != grammarQuestions[currentQuestionIndex]['correct']
                                              ? Colors.red.withValues(alpha: 0.1)
                                              : Colors.grey.withValues(alpha: 0.1)))
                                      : (selectedAnswer == index
                                          ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1)),
                                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                  border: Border.all(
                                    color: showResult
                                        ? (index == grammarQuestions[currentQuestionIndex]['correct']
                                            ? Colors.green
                                            : (index == selectedAnswer && selectedAnswer != grammarQuestions[currentQuestionIndex]['correct']
                                                ? Colors.red
                                                : Colors.grey))
                                        : (selectedAnswer == index
                                            ? AppTheme.primaryOrange
                                            : Colors.grey),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: isTablet ? 24 : 20,
                                      height: isTablet ? 24 : 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedAnswer == index
                                            ? AppTheme.primaryOrange
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: selectedAnswer == index
                                              ? AppTheme.primaryOrange
                                              : Colors.grey,
                                        ),
                                      ),
                                      child: selectedAnswer == index
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: isTablet ? 16 : 14,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    Expanded(
                                      child: Text(
                                        grammarQuestions[currentQuestionIndex]['options'][index],
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Explanation (shown after answer)
                      if (showResult) ...[
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explanation:',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: isTablet ? 8 : 4),
                              Text(
                                grammarQuestions[currentQuestionIndex]['explanation'],
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                      ],
                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: showResult ? _nextQuestion : (selectedAnswer != null ? _checkAnswer : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                            ),
                          ),
                          child: Text(
                            showResult ? 'Next Question' : 'Check Answer',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
