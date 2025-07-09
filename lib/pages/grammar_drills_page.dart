import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../components/navigation.dart';

class GrammarDrillsPage extends StatefulWidget {
  const GrammarDrillsPage({super.key});

  @override
  State<GrammarDrillsPage> createState() => _GrammarDrillsPageState();
}

class _GrammarDrillsPageState extends State<GrammarDrillsPage> {
  int _currentDrillIndex = 0;
  int _score = 0;
  int _totalQuestions = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;

  final List<GrammarDrill> _grammarDrills = [
    GrammarDrill(
      question: "Complete the sentence: 'Ndashaka ______ amazi'",
      description: "Choose the correct word to express 'I want to drink water'",
      options: ["gukoresha", "kunywa", "kurya", "kwandika"],
      correctAnswer: "kunywa",
      explanation: "'Kunywa' means 'to drink'. The infinitive form is used after 'ndashaka' (I want).",
      category: "Verbs - Infinitive Form",
    ),
    GrammarDrill(
      question: "What is the correct plural form of 'umuntu' (person)?",
      description: "Choose the proper noun class transformation",
      options: ["abantu", "untu", "umuuntu", "bantu"],
      correctAnswer: "abantu",
      explanation: "'Umuntu' (person) becomes 'abantu' (people) in plural. This follows the mu-/aba- noun class pattern.",
      category: "Noun Classes - Plural Forms",
    ),
    GrammarDrill(
      question: "Fill in the blank: 'Uyu ni ______ wanjye'",
      description: "Complete: 'This is my ______' (brother)",
      options: ["murumuna", "mushiki", "mama", "papa"],
      correctAnswer: "murumuna",
      explanation: "'Murumuna' means 'younger brother'. 'Mushiki' is sister, 'mama' is mother, 'papa' is father.",
      category: "Family Vocabulary",
    ),
    GrammarDrill(
      question: "Choose the correct present tense: 'I am reading'",
      description: "Select the proper present continuous form",
      options: ["Ndagasoma", "Narasoma", "Ndasoma", "Nasomye"],
      correctAnswer: "Ndasoma",
      explanation: "'Ndasoma' is the present tense form. 'Nasomye' is past perfect, 'Narasoma' uses the wrong tense marker.",
      category: "Verb Tenses - Present",
    ),
    GrammarDrill(
      question: "What does 'ubwoba' mean?",
      description: "Identify the meaning of this abstract noun",
      options: ["happiness", "fear", "love", "anger"],
      correctAnswer: "fear",
      explanation: "'Ubwoba' means fear. It belongs to the ubu- noun class for abstract concepts.",
      category: "Abstract Nouns",
    ),
    GrammarDrill(
      question: "Complete: 'Ejo ______ kuri Kigali'",
      description: "Choose the correct future tense for 'Tomorrow I will go to Kigali'",
      options: ["nzajya", "njya", "nagiye", "ngiye"],
      correctAnswer: "nzajya",
      explanation: "'Nzajya' is the future tense form. 'Njya' is present, 'nagiye' and 'ngiye' are past forms.",
      category: "Verb Tenses - Future",
    ),
  ];

  void _selectAnswer(String answer) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _showResult = true;
      _isCorrect = _selectedAnswer == _grammarDrills[_currentDrillIndex].correctAnswer;
      _totalQuestions++;
      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextDrill() {
    setState(() {
      if (_currentDrillIndex < _grammarDrills.length - 1) {
        _currentDrillIndex++;
        _selectedAnswer = null;
        _showResult = false;
        _isCorrect = false;
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _resetDrills() {
    setState(() {
      _currentDrillIndex = 0;
      _score = 0;
      _totalQuestions = 0;
      _selectedAnswer = null;
      _showResult = false;
      _isCorrect = false;
    });
  }

  void _showCompletionDialog() {
    final percentage = (_score / _totalQuestions * 100).round();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Grammar Drills Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.lightbulb_outline,
              size: 64,
              color: percentage >= 70 ? AppTheme.success : AppTheme.warning,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_score/$_totalQuestions ($percentage%)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              percentage >= 70 
                ? 'Excellent work! You have a strong grasp of Kinyarwanda grammar.'
                : 'Good effort! Keep practicing to improve your grammar skills.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetDrills();
            },
            child: const Text('Practice Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drill = _grammarDrills[_currentDrillIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const Navigation(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryOrange, AppTheme.primaryOrange.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.school, color: Colors.white, size: 32),
                            const SizedBox(width: 12),
                            const Text(
                              'Grammar Drills',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Master Kinyarwanda sentence structure and grammar rules',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentDrillIndex + 1} of ${_grammarDrills.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (_totalQuestions > 0)
                        Text(
                          'Score: $_score/$_totalQuestions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.success,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentDrillIndex + 1) / _grammarDrills.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                  ),
                  const SizedBox(height: 32),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      drill.category,
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drill.question,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            drill.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...drill.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == drill.correctAnswer;
                    
                    Color? cardColor;
                    Color? textColor;
                    
                    if (_showResult) {
                      if (isCorrect) {
                        cardColor = AppTheme.success.withOpacity(0.1);
                        textColor = AppTheme.success;
                      } else if (isSelected && !isCorrect) {
                        cardColor = AppTheme.error.withOpacity(0.1);
                        textColor = AppTheme.error;
                      }
                    } else if (isSelected) {
                      cardColor = AppTheme.primaryOrange.withOpacity(0.1);
                      textColor = AppTheme.primaryOrange;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: cardColor,
                        child: InkWell(
                          onTap: () => _selectAnswer(option),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: textColor ?? theme.textTheme.bodyLarge!.color!,
                                      width: 2,
                                    ),
                                    color: isSelected || (_showResult && isCorrect) 
                                        ? (textColor ?? AppTheme.primaryOrange) 
                                        : Colors.transparent,
                                  ),
                                  child: (isSelected || (_showResult && isCorrect))
                                      ? Icon(
                                          _showResult && isCorrect ? Icons.check : Icons.circle,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                if (_showResult && isCorrect)
                                  Icon(Icons.check_circle, color: AppTheme.success),
                                if (_showResult && isSelected && !isCorrect)
                                  Icon(Icons.cancel, color: AppTheme.error),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedAnswer != null 
                          ? (_showResult ? _nextDrill : _checkAnswer)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _showResult 
                            ? (_currentDrillIndex < _grammarDrills.length - 1 ? 'Next Question' : 'View Results')
                            : 'Check Answer',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  // Explanation
                  if (_showResult) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: _isCorrect 
                          ? AppTheme.success.withOpacity(0.1) 
                          : AppTheme.info.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isCorrect ? Icons.check_circle : Icons.info,
                                  color: _isCorrect ? AppTheme.success : AppTheme.info,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isCorrect ? 'Correct!' : 'Explanation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _isCorrect ? AppTheme.success : AppTheme.info,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              drill.explanation,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GrammarDrill {
  final String question;
  final String description;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String category;

  GrammarDrill({
    required this.question,
    required this.description,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.category,
  });
}
