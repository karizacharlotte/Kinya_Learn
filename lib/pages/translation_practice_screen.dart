import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TranslationPracticeScreen extends StatefulWidget {
  const TranslationPracticeScreen({super.key});

  @override
  State<TranslationPracticeScreen> createState() => _TranslationPracticeScreenState();
}

class _TranslationPracticeScreenState extends State<TranslationPracticeScreen> {
  int currentPhraseIndex = 0;
  String userAnswer = '';
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;
  int totalQuestions = 0;

  final List<Map<String, String>> translationPhrases = [
    {'kinyarwanda': 'Muraho', 'english': 'Hello'},
    {'kinyarwanda': 'Murakoze', 'english': 'Thank you'},
    {'kinyarwanda': 'Murakaza neza', 'english': 'Welcome'},
    {'kinyarwanda': 'Ndashaka amazi', 'english': 'I want water'},
    {'kinyarwanda': 'Ni bangahe?', 'english': 'How much is it?'},
    {'kinyarwanda': 'Ndagukunda', 'english': 'I love you'},
    {'kinyarwanda': 'Nzahora nkwibuka', 'english': 'I will always remember you'},
    {'kinyarwanda': 'Urafite ubwoba?', 'english': 'Are you afraid?'},
    {'kinyarwanda': 'Twese tuli abanyarwanda', 'english': 'We are all Rwandans'},
    {'kinyarwanda': 'Ubwiyunge ni inkomoko y\'ubwoba', 'english': 'Pride is the source of fear'},
    {'kinyarwanda': 'Amasaha menshi', 'english': 'Many hours'},
    {'kinyarwanda': 'Nkunda kurya ubwoba', 'english': 'I like to eat bananas'},
    {'kinyarwanda': 'Ubunyangamugayo', 'english': 'Integrity'},
    {'kinyarwanda': 'Ubwoba bwanjye', 'english': 'My fear'},
    {'kinyarwanda': 'Ndashaka kujya mu ishuri', 'english': 'I want to go to school'},
  ];

  @override
  void initState() {
    super.initState();
    _shufflePhrases();
  }

  void _shufflePhrases() {
    translationPhrases.shuffle();
  }

  void _checkAnswer() {
    final correctAnswer = translationPhrases[currentPhraseIndex]['english']!.toLowerCase();
    final userAnswerTrimmed = userAnswer.trim().toLowerCase();
    
    setState(() {
      isCorrect = userAnswerTrimmed == correctAnswer;
      showResult = true;
      totalQuestions++;
      if (isCorrect) score++;
    });
  }

  void _nextPhrase() {
    if (currentPhraseIndex < translationPhrases.length - 1) {
      setState(() {
        currentPhraseIndex++;
        userAnswer = '';
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
        title: const Text('Translation Practice Complete!'),
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
                currentPhraseIndex = 0;
                score = 0;
                totalQuestions = 0;
                userAnswer = '';
                showResult = false;
              });
              _shufflePhrases();
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
                    : [const Color(0xFFFAD201), const Color(0xFFFAD201)],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Translation Practice',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Translate from Kinyarwanda to English',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.translate,
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
                    value: (currentPhraseIndex + 1) / translationPhrases.length,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFAD201)),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentPhraseIndex + 1}/${translationPhrases.length}',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Translation Card
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Score display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: const Color(0xFFFAD201), size: isTablet ? 24 : 20),
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
                      // Kinyarwanda phrase
                      Text(
                        'Translate this phrase:',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAD201).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                        ),
                        child: Text(
                          translationPhrases[currentPhraseIndex]['kinyarwanda']!,
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Input field
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            userAnswer = value;
                          });
                        },
                        onSubmitted: (_) {
                          if (!showResult && userAnswer.isNotEmpty) {
                            _checkAnswer();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter English translation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                        ),
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                        enabled: !showResult,
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Result display
                      if (showResult) ...[
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: isTablet ? 24 : 20,
                                  ),
                                  SizedBox(width: isTablet ? 8 : 6),
                                  Text(
                                    isCorrect ? 'Correct!' : 'Incorrect',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isCorrect) ...[
                                SizedBox(height: isTablet ? 12 : 8),
                                Text(
                                  'Correct answer: ${translationPhrases[currentPhraseIndex]['english']}',
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                      ],
                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: showResult ? _nextPhrase : (userAnswer.isNotEmpty ? _checkAnswer : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAD201),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                            ),
                          ),
                          child: Text(
                            showResult ? 'Next Phrase' : 'Check Answer',
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
