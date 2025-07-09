import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpeakingPracticePage extends StatefulWidget {
  const SpeakingPracticePage({super.key});

  @override
  State<SpeakingPracticePage> createState() => _SpeakingPracticePageState();
}

class _SpeakingPracticePageState extends State<SpeakingPracticePage> {
  int currentWordIndex = 0;
  bool isRecording = false;

  final List<Map<String, String>> practiceWords = [
    {'kinyarwanda': 'Muraho', 'english': 'Hello', 'pronunciation': 'moo-rah-ho'},
    {'kinyarwanda': 'Mwaramutse', 'english': 'Good morning', 'pronunciation': 'mwa-ra-moot-say'},
    {'kinyarwanda': 'Mwiriwe', 'english': 'Good evening', 'pronunciation': 'mwee-ree-way'},
    {'kinyarwanda': 'Murakoze', 'english': 'Thank you', 'pronunciation': 'moo-ra-ko-zay'},
    {'kinyarwanda': 'Urabeho', 'english': 'Goodbye', 'pronunciation': 'oo-ra-bay-ho'},
    {'kinyarwanda': 'Yego', 'english': 'Yes', 'pronunciation': 'yay-go'},
    {'kinyarwanda': 'Oya', 'english': 'No', 'pronunciation': 'oh-ya'},
    {'kinyarwanda': 'Nyabuneka', 'english': 'Please', 'pronunciation': 'nya-boo-nay-ka'},
    {'kinyarwanda': 'Mbabarira', 'english': 'Excuse me', 'pronunciation': 'mba-ba-ree-ra'},
    {'kinyarwanda': 'Amakuru?', 'english': 'How are you?', 'pronunciation': 'ah-ma-koo-roo'},
  ];

  void nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % practiceWords.length;
    });
  }

  void previousWord() {
    setState(() {
      currentWordIndex = currentWordIndex > 0 ? currentWordIndex - 1 : practiceWords.length - 1;
    });
  }

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    
    // Simulate recording feedback
    if (isRecording) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            isRecording = false;
          });
          _showFeedback();
        }
      });
    }
  }

  void _showFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job!'),
        content: const Text('Your pronunciation is improving! Keep practicing.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nextWord();
            },
            child: const Text('Next Word'),
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
    final currentWord = practiceWords[currentWordIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Speaking Practice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (currentWordIndex + 1) / practiceWords.length,
              backgroundColor: theme.colorScheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
            ),
            const SizedBox(height: 8),
            Text(
              '${currentWordIndex + 1} of ${practiceWords.length}',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            
            // Word Card
            Expanded(
              child: Center(
                child: Container(
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
                  padding: EdgeInsets.all(isTablet ? 40 : 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentWord['kinyarwanda']!,
                        style: TextStyle(
                          fontSize: isTablet ? 48 : 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentWord['english']!,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pronunciation: ${currentWord['pronunciation']}',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            color: AppTheme.primaryOrange,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Recording Button
                      GestureDetector(
                        onTap: toggleRecording,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isTablet ? 120 : 100,
                          height: isTablet ? 120 : 100,
                          decoration: BoxDecoration(
                            color: isRecording ? Colors.red : AppTheme.primaryOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isRecording ? Colors.red : AppTheme.primaryOrange)
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: isRecording ? 10 : 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: isTablet ? 50 : 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isRecording ? 'Recording...' : 'Tap to Practice',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: previousWord,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text('Previous', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 20, 
                      vertical: isTablet ? 16 : 12
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: nextWord,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text('Next', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 20, 
                      vertical: isTablet ? 16 : 12
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
