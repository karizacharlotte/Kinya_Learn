import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ListeningExercisesScreen extends StatefulWidget {
  const ListeningExercisesScreen({super.key});

  @override
  State<ListeningExercisesScreen> createState() => _ListeningExercisesScreenState();
}

class _ListeningExercisesScreenState extends State<ListeningExercisesScreen> {
  int currentIndex = 0;
  bool isPlaying = false;
  String? selectedAnswer;
  bool showResult = false;
  
  final List<Map<String, dynamic>> listeningExercises = [
    {
      'audio': 'Muraho',
      'question': 'What did you hear?',
      'options': ['Hello', 'Goodbye', 'Thank you', 'Good morning'],
      'correctAnswer': 'Hello',
      'kinyarwanda': 'Muraho',
    },
    {
      'audio': 'Mwaramutse',
      'question': 'What greeting was spoken?',
      'options': ['Good evening', 'Good morning', 'Good night', 'Hello'],
      'correctAnswer': 'Good morning',
      'kinyarwanda': 'Mwaramutse',
    },
    {
      'audio': 'Murakoze',
      'question': 'What expression was used?',
      'options': ['Please', 'Thank you', 'Excuse me', 'Sorry'],
      'correctAnswer': 'Thank you',
      'kinyarwanda': 'Murakoze',
    },
    {
      'audio': 'Nitwa amazina yawe?',
      'question': 'What question was asked?',
      'options': ['How are you?', 'Where are you from?', 'What is your name?', 'How old are you?'],
      'correctAnswer': 'What is your name?',
      'kinyarwanda': 'Nitwa amazina yawe?',
    },
    {
      'audio': 'Mwiriwe',
      'question': 'What time of day greeting was this?',
      'options': ['Morning', 'Afternoon', 'Evening', 'Night'],
      'correctAnswer': 'Evening',
      'kinyarwanda': 'Mwiriwe',
    },
    {
      'audio': 'Ni ryari?',
      'question': 'What type of question was asked?',
      'options': ['Where', 'When', 'Why', 'Who'],
      'correctAnswer': 'When',
      'kinyarwanda': 'Ni ryari?',
    },
  ];

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
                    : [const Color(0xFF00A1DE), const Color(0xFF00A1DE)],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back,
                      color: isDark ? theme.colorScheme.onSurface : Colors.white),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Listening Exercises',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Train your listening comprehension',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.headphones,
                    color: isDark ? theme.colorScheme.onSurface : Colors.white,
                    size: isTablet ? 36 : 32),
              ],
            ),
          ),
          // Progress
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / listeningExercises.length,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00A1DE)),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentIndex + 1}/${listeningExercises.length}',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
          // Exercise Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: AppTheme.border, width: 1),
                  ),
                  padding: EdgeInsets.all(isTablet ? 32 : 24),
                  child: Column(
                    children: [
                      // Audio Player
                      Container(
                        padding: EdgeInsets.all(isTablet ? 24 : 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A1DE).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        child: Column(
                          children: [
                            // Play button
                            GestureDetector(
                              onTap: _toggleAudio,
                              child: Container(
                                width: isTablet ? 80 : 70,
                                height: isTablet ? 80 : 70,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A1DE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: isTablet ? 36 : 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 16 : 12),
                            Text(
                              isPlaying ? 'Playing...' : 'Tap to listen',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                            // Show the text being played (for demo purposes)
                            if (isPlaying) ...[
                              SizedBox(height: isTablet ? 16 : 12),
                              Text(
                                listeningExercises[currentIndex]['kinyarwanda'],
                                style: TextStyle(
                                  fontSize: isTablet ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00A1DE),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Question
                      Text(
                        listeningExercises[currentIndex]['question'],
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: listeningExercises[currentIndex]['options'].length,
                          itemBuilder: (context, index) {
                            final option = listeningExercises[currentIndex]['options'][index];
                            final isSelected = selectedAnswer == option;
                            final isCorrect = option == listeningExercises[currentIndex]['correctAnswer'];
                            
                            Color cardColor = AppTheme.cardBackground;
                            Color borderColor = AppTheme.border;
                            
                            if (showResult && isCorrect) {
                              cardColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
                              borderColor = const Color(0xFF4CAF50);
                            } else if (showResult && isSelected && !isCorrect) {
                              cardColor = Colors.red.withValues(alpha: 0.1);
                              borderColor = Colors.red;
                            } else if (isSelected) {
                              cardColor = const Color(0xFF00A1DE).withValues(alpha: 0.1);
                              borderColor = const Color(0xFF00A1DE);
                            }
                            
                            return Container(
                              margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                    border: Border.all(color: borderColor, width: 2),
                                  ),
                                  child: InkWell(
                                    onTap: showResult ? null : () => _selectAnswer(option),
                                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                    child: Padding(
                                      padding: EdgeInsets.all(isTablet ? 16 : 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: isTablet ? 24 : 20,
                                            height: isTablet ? 24 : 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected ? borderColor : Colors.transparent,
                                              border: Border.all(color: borderColor, width: 2),
                                            ),
                                            child: isSelected
                                                ? Icon(Icons.check, size: isTablet ? 16 : 12, color: Colors.white)
                                                : null,
                                          ),
                                          SizedBox(width: isTablet ? 16 : 12),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: isTablet ? 18 : 16,
                                                color: AppTheme.textPrimary,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (showResult && isCorrect)
                                            Icon(Icons.check_circle, 
                                                color: const Color(0xFF4CAF50), 
                                                size: isTablet ? 24 : 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Action buttons
                      if (selectedAnswer != null && !showResult)
                        ElevatedButton(
                          onPressed: _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A1DE),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 48 : 32,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            'Check Answer',
                            style: TextStyle(fontSize: isTablet ? 18 : 16),
                          ),
                        ),
                      if (showResult)
                        ElevatedButton(
                          onPressed: _nextExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A1DE),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 48 : 32,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            currentIndex < listeningExercises.length - 1 ? 'Next' : 'Finish',
                            style: TextStyle(fontSize: isTablet ? 18 : 16),
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

  void _toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
    
    if (isPlaying) {
      // Simulate audio playback for 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void _nextExercise() {
    if (currentIndex < listeningExercises.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        showResult = false;
        isPlaying = false;
      });
    } else {
      // Completed all exercises
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You\'ve completed all listening exercises!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        ),
      );
    }
  }
}
