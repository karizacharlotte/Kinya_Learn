import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TranslationPracticePage extends StatefulWidget {
  const TranslationPracticePage({super.key});

  @override
  State<TranslationPracticePage> createState() => _TranslationPracticePageState();
}

class _TranslationPracticePageState extends State<TranslationPracticePage> {
  int currentExerciseIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  bool showResult = false;
  bool isCorrect = false;

  final List<Map<String, String>> exercises = [
    {'english': 'Hello', 'kinyarwanda': 'muraho'},
    {'english': 'Thank you', 'kinyarwanda': 'murakoze'},
    {'english': 'Good morning', 'kinyarwanda': 'mwaramutse'},
    {'english': 'How are you?', 'kinyarwanda': 'amakuru'},
    {'english': 'Goodbye', 'kinyarwanda': 'urabeho'},
    {'english': 'Please', 'kinyarwanda': 'nyabuneka'},
    {'english': 'Excuse me', 'kinyarwanda': 'mbabarira'},
    {'english': 'Yes', 'kinyarwanda': 'yego'},
    {'english': 'No', 'kinyarwanda': 'oya'},
    {'english': 'Water', 'kinyarwanda': 'amazi'},
    {'english': 'Food', 'kinyarwanda': 'ibiryo'},
    {'english': 'House', 'kinyarwanda': 'inzu'},
    {'english': 'School', 'kinyarwanda': 'ishuri'},
    {'english': 'I am fine', 'kinyarwanda': 'ni meza'},
    {'english': 'See you later', 'kinyarwanda': 'tugonane'},
  ];

  void checkAnswer() {
    final userAnswer = _answerController.text.toLowerCase().trim();
    final correctAnswer = exercises[currentExerciseIndex]['kinyarwanda']!.toLowerCase();
    
    setState(() {
      isCorrect = userAnswer == correctAnswer;
      showResult = true;
    });
  }

  void nextExercise() {
    setState(() {
      currentExerciseIndex = (currentExerciseIndex + 1) % exercises.length;
      _answerController.clear();
      showResult = false;
      isCorrect = false;
    });
  }

  void getHint() {
    final correctAnswer = exercises[currentExerciseIndex]['kinyarwanda']!;
    final hint = correctAnswer.substring(0, (correctAnswer.length / 2).ceil());
    
    setState(() {
      _answerController.text = hint;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hint: The word starts with "$hint"'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final theme = Theme.of(context);
    final currentExercise = exercises[currentExerciseIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Translation Practice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFAD201),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (currentExerciseIndex + 1) / exercises.length,
              backgroundColor: theme.colorScheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFAD201)),
            ),
            const SizedBox(height: 8),
            Text(
              'Exercise ${currentExerciseIndex + 1} of ${exercises.length}',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            
            // Translation Card
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.translate,
                    size: 60,
                    color: Color(0xFFFAD201),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Translate to Kinyarwanda',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // English word to translate
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAD201).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFAD201).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      currentExercise['english']!,
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB8860B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Answer Input
                  TextField(
                    controller: _answerController,
                    enabled: !showResult,
                    decoration: InputDecoration(
                      hintText: 'Type your answer in Kinyarwanda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFFAD201), width: 2),
                      ),
                      filled: true,
                      fillColor: AppTheme.cardBackground,
                      suffixIcon: !showResult
                          ? IconButton(
                              icon: const Icon(Icons.lightbulb_outline, color: Colors.orange),
                              onPressed: getHint,
                              tooltip: 'Get Hint',
                            )
                          : null,
                    ),
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  if (showResult) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: isCorrect 
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: isTablet ? 28 : 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isCorrect ? 'Correct!' : 'Incorrect',
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          if (!isCorrect) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Correct answer: ${currentExercise['kinyarwanda']}',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const Spacer(),
            
            // Action Buttons
            if (!showResult)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _answerController.text.isNotEmpty ? checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAD201),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Check Answer',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: nextExercise,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    'Next Exercise',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAD201),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
