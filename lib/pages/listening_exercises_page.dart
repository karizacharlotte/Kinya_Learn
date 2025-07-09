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
  String currentLanguage = "fr-FR"; // Start with French for better Kinyarwanda sounds

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
    
    // Try different language settings for better Kinyarwanda pronunciation
    // We'll try French first as it has similar vowel sounds to Kinyarwanda
    _configureTtsForKinyarwanda();
    
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

  void _configureTtsForKinyarwanda() async {
    // Try French first (better vowel pronunciation for Kinyarwanda)
    try {
      await flutterTts.setLanguage("fr-FR");
      await flutterTts.setSpeechRate(0.5); // Even slower for clarity
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(0.9); // Slightly lower pitch
    } catch (e) {
      // Fallback to English if French fails
      try {
        await flutterTts.setLanguage("en-US");
        await flutterTts.setSpeechRate(0.4); // Very slow
        await flutterTts.setPitch(0.8);
      } catch (e2) {
        print('TTS configuration failed: $e2');
      }
    }
  }

  void _configureTtsLanguage(String language) async {
    try {
      await flutterTts.setLanguage(language);
      // Adjust settings based on language
      switch (language) {
        case "fr-FR":
          await flutterTts.setSpeechRate(0.5);
          await flutterTts.setPitch(0.9);
          break;
        case "it-IT":
          await flutterTts.setSpeechRate(0.6);
          await flutterTts.setPitch(1.0);
          break;
        case "en-US":
          await flutterTts.setSpeechRate(0.3);
          await flutterTts.setPitch(0.8);
          break;
      }
    } catch (e) {
      print('Failed to set language $language: $e');
    }
  }

  final List<Map<String, dynamic>> exercises = [
    {
      'audio': 'Muraho, witwa gute?',
      'phonetic': 'Mourahho, ouitoua gouteh?', // French-like spelling for better pronunciation
      'phoneticDisplay': 'Moo-rah-ho, wee-twa goo-teh?', // What user sees
      'question': 'What does this phrase mean?',
      'options': ['Hello, what is your name?', 'Good morning', 'How are you?', 'Goodbye'],
      'correct': 0,
    },
    {
      'audio': 'Mwaramutse ho',
      'phonetic': 'Mouaramoutsé ho', // Better French-style phonetics
      'phoneticDisplay': 'Mwa-rah-moot-seh ho',
      'question': 'When would you say this?',
      'options': ['Evening', 'Morning', 'Afternoon', 'Night'],
      'correct': 1,
    },
    {
      'audio': 'Murakoze cyane',
      'phonetic': 'Mourakozé tchané', // French 'tch' for 'cy' sound
      'phoneticDisplay': 'Moo-rah-ko-zeh cha-neh',
      'question': 'This expression means:',
      'options': ['You\'re welcome', 'Thank you very much', 'Excuse me', 'I\'m sorry'],
      'correct': 1,
    },
    {
      'audio': 'Urabeho neza',
      'phonetic': 'Ourabého néza', // French accent marks for tone
      'phoneticDisplay': 'Oo-rah-beh-ho neh-za',
      'question': 'This is used when:',
      'options': ['Greeting someone', 'Saying goodbye', 'Asking for help', 'Ordering food'],
      'correct': 1,
    },
    {
      'audio': 'Amakuru yawe?',
      'phonetic': 'Amakouroù yaouè?', // French-style vowel combinations
      'phoneticDisplay': 'Ah-mah-koo-roo ya-weh?',
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
      
      // Use the French-style phonetic version for better Kinyarwanda pronunciation
      String textToSpeak = currentExercise['phonetic'] ?? currentExercise['audio'];
      
      // Try to speak with French settings first for better vowel sounds
      await _speakKinyarwandaText(textToSpeak);
      
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  Future<void> _speakKinyarwandaText(String text) async {
    try {
      // Use the currently selected language
      await flutterTts.setLanguage(currentLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      try {
        // If selected language fails, try French as backup
        await flutterTts.setLanguage("fr-FR");
        await flutterTts.speak(text);
      } catch (e2) {
        try {
          // Final fallback to English with very slow speech
          await flutterTts.setLanguage("en-US");
          await flutterTts.setSpeechRate(0.3);
          await flutterTts.speak(text);
        } catch (e3) {
          throw e3;
        }
      }
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
                    currentExercise['phoneticDisplay'] ?? currentExercise['phonetic'],
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
                  const SizedBox(height: 12),
                  
                  // Language mode selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pronunciation: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      DropdownButton<String>(
                        value: currentLanguage,
                        underline: Container(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                        items: const [
                          DropdownMenuItem(value: "fr-FR", child: Text("French-style")),
                          DropdownMenuItem(value: "it-IT", child: Text("Italian-style")),
                          DropdownMenuItem(value: "en-US", child: Text("English-style")),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              currentLanguage = newValue;
                            });
                            _configureTtsLanguage(newValue);
                          }
                        },
                      ),
                    ],
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
