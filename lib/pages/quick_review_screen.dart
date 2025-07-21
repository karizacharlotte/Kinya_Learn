import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickReviewScreen extends StatefulWidget {
  const QuickReviewScreen({super.key});

  @override
  State<QuickReviewScreen> createState() => _QuickReviewScreenState();
}

class _QuickReviewScreenState extends State<QuickReviewScreen> {
  int currentIndex = 0;
  bool showAnswer = false;
  bool isFlipped = false;
  
  final List<Map<String, String>> flashcards = [
    {
      'kinyarwanda': 'Muraho',
      'english': 'Hello',
      'category': 'Greetings',
      'pronunciation': 'moo-rah-ho'
    },
    {
      'kinyarwanda': 'Mwaramutse',
      'english': 'Good morning',
      'category': 'Greetings',
      'pronunciation': 'mwah-rah-moot-say'
    },
    {
      'kinyarwanda': 'Mwiriwe',
      'english': 'Good evening',
      'category': 'Greetings',
      'pronunciation': 'mwee-ree-way'
    },
    {
      'kinyarwanda': 'Murakoze',
      'english': 'Thank you',
      'category': 'Polite Expressions',
      'pronunciation': 'moo-rah-ko-zay'
    },
    {
      'kinyarwanda': 'Urakoze',
      'english': 'You\'re welcome',
      'category': 'Polite Expressions',
      'pronunciation': 'oo-rah-ko-zay'
    },
    {
      'kinyarwanda': 'Nitwa amazina yawe?',
      'english': 'What is your name?',
      'category': 'Questions',
      'pronunciation': 'nee-twa ah-mah-zee-nah yah-way'
    },
    {
      'kinyarwanda': 'Nitwa...',
      'english': 'My name is...',
      'category': 'Responses',
      'pronunciation': 'nee-twa'
    },
    {
      'kinyarwanda': 'Ni ryari?',
      'english': 'When is it?',
      'category': 'Questions',
      'pronunciation': 'nee ree-yah-ree'
    },
    {
      'kinyarwanda': 'Ni hehe?',
      'english': 'Where is it?',
      'category': 'Questions',
      'pronunciation': 'nee hay-hay'
    },
    {
      'kinyarwanda': 'Ni nde?',
      'english': 'Who is it?',
      'category': 'Questions',
      'pronunciation': 'nee n-day'
    },
    {
      'kinyarwanda': 'Uraho?',
      'english': 'How are you?',
      'category': 'Greetings',
      'pronunciation': 'oo-rah-ho'
    },
    {
      'kinyarwanda': 'Ndaho neza',
      'english': 'I am fine',
      'category': 'Responses',
      'pronunciation': 'n-dah-ho nay-zah'
    },
    {
      'kinyarwanda': 'Umunsi mwiza',
      'english': 'Good day',
      'category': 'Greetings',
      'pronunciation': 'oo-moon-see mwee-zah'
    },
    {
      'kinyarwanda': 'Urabona',
      'english': 'You see',
      'category': 'Common Phrases',
      'pronunciation': 'oo-rah-bo-nah'
    },
    {
      'kinyarwanda': 'Ndabona',
      'english': 'I see',
      'category': 'Common Phrases',
      'pronunciation': 'n-dah-bo-nah'
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
                    : [const Color(0xFF00A651), const Color(0xFF00A651)],
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
                        'Quick Review',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Flash cards & vocabulary review',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.quiz,
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
                    value: (currentIndex + 1) / flashcards.length,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF00A651)),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Text(
                  '${currentIndex + 1}/${flashcards.length}',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
          // Flashcard
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: showAnswer 
                            ? const Color(0xFF00A651).withValues(alpha: 0.1)
                            : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        border: Border.all(
                          color: showAnswer ? const Color(0xFF00A651) : AppTheme.border,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 40 : 32),
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
                                color: const Color(0xFF00A651).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                flashcards[currentIndex]['category']!,
                                style: TextStyle(
                                  color: const Color(0xFF00A651),
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 40 : 32),
                            // Front side (Kinyarwanda)
                            if (!showAnswer) ...[
                              Icon(
                                Icons.language,
                                size: isTablet ? 48 : 40,
                                color: const Color(0xFF00A651),
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              Text(
                                flashcards[currentIndex]['kinyarwanda']!,
                                style: TextStyle(
                                  fontSize: isTablet ? 40 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              Text(
                                '[${flashcards[currentIndex]['pronunciation']}]',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            // Back side (English)
                            if (showAnswer) ...[
                              Icon(
                                Icons.translate,
                                size: isTablet ? 48 : 40,
                                color: const Color(0xFF00A651),
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              Text(
                                flashcards[currentIndex]['english']!,
                                style: TextStyle(
                                  fontSize: isTablet ? 36 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              Text(
                                flashcards[currentIndex]['kinyarwanda']!,
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 18,
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            SizedBox(height: isTablet ? 40 : 32),
                            // Instruction
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16,
                                vertical: isTablet ? 12 : 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.textSecondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                showAnswer ? 'Tap to continue' : 'Tap to reveal answer',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: isTablet ? 16 : 14,
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
            ),
          ),
          // Action buttons
          if (showAnswer)
            Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markDifficult,
                      icon: Icon(Icons.refresh),
                      label: Text('Review Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextCard,
                      icon: Icon(Icons.check),
                      label: Text('Got It!'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _flipCard() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void _markDifficult() {
    // Add to review pile (in a real app, this would be saved)
    _nextCard();
  }

  void _nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    } else {
      // Completed all flashcards
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Great Job!'),
          content: Text('You\'ve reviewed all flashcards!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentIndex = 0;
                  showAnswer = false;
                });
              },
              child: Text('Review Again'),
            ),
          ],
        ),
      );
    }
  }
}
