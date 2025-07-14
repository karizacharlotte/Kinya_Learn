import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  int currentIndex = 0;
  bool isRecording = false;
  bool hasRecorded = false;
  
  final List<Map<String, String>> speakingExercises = [
    {
      'phrase': 'Muraho',
      'translation': 'Hello',
      'pronunciation': 'moo-rah-ho',
      'category': 'Greetings'
    },
    {
      'phrase': 'Mwaramutse',
      'translation': 'Good morning',
      'pronunciation': 'mwah-rah-moot-say',
      'category': 'Greetings'
    },
    {
      'phrase': 'Mwiriwe',
      'translation': 'Good evening',
      'pronunciation': 'mwee-ree-way',
      'category': 'Greetings'
    },
    {
      'phrase': 'Nitwa amazina yawe?',
      'translation': 'What is your name?',
      'pronunciation': 'nee-twa ah-mah-zee-nah yah-way',
      'category': 'Introductions'
    },
    {
      'phrase': 'Nitwa John',
      'translation': 'My name is John',
      'pronunciation': 'nee-twa john',
      'category': 'Introductions'
    },
    {
      'phrase': 'Ni ryari?',
      'translation': 'When is it?',
      'pronunciation': 'nee ree-yah-ree',
      'category': 'Questions'
    },
    {
      'phrase': 'Ni hehe?',
      'translation': 'Where is it?',
      'pronunciation': 'nee hay-hay',
      'category': 'Questions'
    },
    {
      'phrase': 'Murakoze',
      'translation': 'Thank you',
      'pronunciation': 'moo-rah-ko-zay',
      'category': 'Polite Expressions'
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
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange],
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
                        'Speaking Practice',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Practice pronunciation and speaking',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.mic,
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
                    value: (currentIndex + 1) / speakingExercises.length,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentIndex + 1}/${speakingExercises.length}',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Category
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 12,
                          vertical: isTablet ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          speakingExercises[currentIndex]['category']!,
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Kinyarwanda phrase
                      Text(
                        speakingExercises[currentIndex]['phrase']!,
                        style: TextStyle(
                          fontSize: isTablet ? 36 : 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      // Pronunciation guide
                      Text(
                        '[${speakingExercises[currentIndex]['pronunciation']}]',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 24 : 16),
                      // English translation
                      Text(
                        speakingExercises[currentIndex]['translation']!,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 48 : 32),
                      // Recording button
                      GestureDetector(
                        onTap: _toggleRecording,
                        child: Container(
                          width: isTablet ? 120 : 100,
                          height: isTablet ? 120 : 100,
                          decoration: BoxDecoration(
                            color: isRecording 
                                ? Colors.red.withValues(alpha: 0.2)
                                : AppTheme.primaryOrange.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isRecording ? Colors.red : AppTheme.primaryOrange,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            size: isTablet ? 48 : 40,
                            color: isRecording ? Colors.red : AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        isRecording ? 'Recording...' : 'Tap to record',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      if (hasRecorded) ...[
                        SizedBox(height: isTablet ? 24 : 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  hasRecorded = false;
                                });
                              },
                              icon: Icon(Icons.refresh),
                              label: Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.cardBackground,
                                foregroundColor: AppTheme.primaryOrange,
                                side: BorderSide(color: AppTheme.primaryOrange),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _nextExercise,
                              icon: Icon(Icons.check),
                              label: Text('Good!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryOrange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  void _toggleRecording() {
    setState(() {
      if (isRecording) {
        isRecording = false;
        hasRecorded = true;
        // Here you would stop recording and process the audio
      } else {
        isRecording = true;
        hasRecorded = false;
        // Here you would start recording
      }
    });

    // Simulate recording for 3 seconds
    if (isRecording) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && isRecording) {
          setState(() {
            isRecording = false;
            hasRecorded = true;
          });
        }
      });
    }
  }

  void _nextExercise() {
    if (currentIndex < speakingExercises.length - 1) {
      setState(() {
        currentIndex++;
        hasRecorded = false;
        isRecording = false;
      });
    } else {
      // Completed all exercises
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You\'ve completed all speaking exercises!'),
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
