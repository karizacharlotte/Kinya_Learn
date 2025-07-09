import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../theme/app_theme.dart';

class ListeningExercisesPage extends StatefulWidget {
  const ListeningExercisesPage({super.key});

  @override
  State<ListeningExercisesPage> createState() => _ListeningExercisesPageState();
}

class _ListeningExercisesPageState extends State<ListeningExercisesPage> {
  int currentExerciseIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  bool isPlaying = false;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void initTts() {
    flutterTts = FlutterTts();
    
    // Configure TTS settings
    flutterTts.setLanguage("en-US"); // We'll use English for now since Kinyarwanda may not be supported
    flutterTts.setSpeechRate(0.6); // Slower speech rate for learning
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
    
    // Set up completion handler
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
    
    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio error: $msg')),
      );
    });
  }

  final List<Map<String, dynamic>> exercises = [
    {
      'audio': 'Muraho, witwa gute?',
      'phonetic': 'Moo-rah-ho, wee-twa goo-teh?',
      'question': 'What does this phrase mean?',
      'options': ['Hello, what is your name?', 'Good morning', 'How are you?', 'Goodbye'],
      'correct': 0,
    },
    {
      'audio': 'Mwaramutse ho',
      'phonetic': 'Mwa-rah-moot-seh ho',
      'question': 'When would you say this?',
      'options': ['Evening', 'Morning', 'Afternoon', 'Night'],
      'correct': 1,
    },
    {
      'audio': 'Murakoze cyane',
      'phonetic': 'Moo-rah-ko-zeh cha-neh',
      'question': 'This expression means:',
      'options': ['You\'re welcome', 'Thank you very much', 'Excuse me', 'I\'m sorry'],
      'correct': 1,
    },
    {
      'audio': 'Urabeho neza',
      'phonetic': 'Oo-rah-beh-ho neh-za',
      'question': 'This is used when:',
      'options': ['Greeting someone', 'Saying goodbye', 'Asking for help', 'Ordering food'],
      'correct': 1,
    },
    {
      'audio': 'Amakuru yawe?',
      'phonetic': 'Ah-mah-koo-roo ya-weh?',
      'question': 'The correct response would be:',
      'options': ['Ni meza', 'Murakoze', 'Urabeho', 'Nyabuneka'],
      'correct': 0,
    },
  ];

  void playAudio() async {
    setState(() {
      isPlaying = true;
    });
    
    try {
      // Stop any current speech
      await flutterTts.stop();
      
      // Get the current exercise
      final currentExercise = exercises[currentExerciseIndex];
      
      // Try to speak the phonetic version first (more likely to be pronounced correctly)
      // Since most TTS engines don't support Kinyarwanda, the phonetic version will sound better
      String textToSpeak = currentExercise['phonetic'] ?? currentExercise['audio'];
      
      await flutterTts.speak(textToSpeak);
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  void selectAnswer(int index) {
    if (!showResult) {
      setState(() {
        selectedAnswer = index.toString();
      });
    }
  }

  void checkAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void nextExercise() {
    setState(() {
      currentExerciseIndex = (currentExerciseIndex + 1) % exercises.length;
      selectedAnswer = null;
      showResult = false;
    });
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
          'Listening Exercises',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A1DE),
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
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00A1DE)),
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
            
            // Audio Player Section
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
                    Icons.headphones,
                    size: 60,
                    color: Color(0xFF00A1DE),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Listen to the audio',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentExercise['audio'],
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentExercise['phonetic'],
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Play Button
                  GestureDetector(
                    onTap: playAudio,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isTablet ? 100 : 80,
                      height: isTablet ? 100 : 80,
                      decoration: BoxDecoration(
                        color: isPlaying ? Colors.grey : const Color(0xFF00A1DE),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A1DE).withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: isPlaying ? 5 : 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: isTablet ? 50 : 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Question
            Text(
              currentExercise['question'],
              style: TextStyle(
                fontSize: isTablet ? 24 : 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Answer Options
            Expanded(
              child: ListView.builder(
                itemCount: currentExercise['options'].length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswer == index.toString();
                  final isCorrect = index == currentExercise['correct'];
                  
                  Color? backgroundColor;
                  Color? borderColor;
                  
                  if (showResult) {
                    if (isCorrect) {
                      backgroundColor = Colors.green.withValues(alpha: 0.1);
                      borderColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red.withValues(alpha: 0.1);
                      borderColor = Colors.red;
                    }
                  } else if (isSelected) {
                    backgroundColor = const Color(0xFF00A1DE).withValues(alpha: 0.1);
                    borderColor = const Color(0xFF00A1DE);
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => selectAnswer(index),
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: backgroundColor ?? AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor ?? AppTheme.border,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: isTablet ? 32 : 24,
                              height: isTablet ? 32 : 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor ?? AppTheme.border,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 20 : 16),
                            Expanded(
                              child: Text(
                                currentExercise['options'][index],
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            if (showResult && isCorrect)
                              const Icon(Icons.check_circle, color: Colors.green),
                            if (showResult && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer != null
                    ? (showResult ? nextExercise : checkAnswer)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A1DE),
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  showResult ? 'Next Exercise' : 'Check Answer',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
