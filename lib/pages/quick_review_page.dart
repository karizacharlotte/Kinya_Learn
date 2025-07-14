import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickReviewPage extends StatefulWidget {
  const QuickReviewPage({super.key});

  @override
  State<QuickReviewPage> createState() => _QuickReviewPageState();
}

class _QuickReviewPageState extends State<QuickReviewPage> {
  int currentCardIndex = 0;
  bool showAnswer = false;

  final List<Map<String, String>> flashCards = [
    {'front': 'Hello', 'back': 'Muraho'},
    {'front': 'Thank you', 'back': 'Murakoze'},
    {'front': 'Good morning', 'back': 'Mwaramutse'},
    {'front': 'Good evening', 'back': 'Mwiriwe'},
    {'front': 'Goodbye', 'back': 'Urabeho'},
    {'front': 'Yes', 'back': 'Yego'},
    {'front': 'No', 'back': 'Oya'},
    {'front': 'Please', 'back': 'Nyabuneka'},
    {'front': 'Excuse me', 'back': 'Mbabarira'},
    {'front': 'How are you?', 'back': 'Amakuru?'},
    {'front': 'I am fine', 'back': 'Ni meza'},
    {'front': 'Water', 'back': 'Amazi'},
    {'front': 'Food', 'back': 'Ibiryo'},
    {'front': 'House', 'back': 'Inzu'},
    {'front': 'School', 'back': 'Ishuri'},
  ];

  void flipCard() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void nextCard() {
    setState(() {
      currentCardIndex = (currentCardIndex + 1) % flashCards.length;
      showAnswer = false;
    });
  }

  void previousCard() {
    setState(() {
      currentCardIndex = currentCardIndex > 0 ? currentCardIndex - 1 : flashCards.length - 1;
      showAnswer = false;
    });
  }

  void markEasy() {
    _showFeedback('Great! You know this word well.', Colors.green);
    Future.delayed(const Duration(seconds: 1), nextCard);
  }

  void markHard() {
    _showFeedback('No worries! Keep practicing.', Colors.orange);
    Future.delayed(const Duration(seconds: 1), nextCard);
  }

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final theme = Theme.of(context);
    final currentCard = flashCards[currentCardIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Quick Review',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A651),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (currentCardIndex + 1) / flashCards.length,
              backgroundColor: theme.colorScheme.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
            ),
            const SizedBox(height: 8),
            Text(
              'Card ${currentCardIndex + 1} of ${flashCards.length}',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            
            // Flash Card
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey(showAnswer),
                      width: double.infinity,
                      height: isTablet ? 400 : 300,
                      constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: showAnswer 
                              ? [const Color(0xFF00A651), const Color(0xFF007A40)]
                              : [const Color(0xFF00A1DE), const Color(0xFF0080B7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            showAnswer ? Icons.translate : Icons.quiz,
                            color: Colors.white,
                            size: isTablet ? 50 : 40,
                          ),
                          SizedBox(height: isTablet ? 32 : 24),
                          Text(
                            showAnswer ? currentCard['back']! : currentCard['front']!,
                            style: TextStyle(
                              fontSize: isTablet ? 40 : 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Text(
                            showAnswer ? 'Kinyarwanda' : 'English',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 16,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: isTablet ? 40 : 32),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              showAnswer ? 'Tap to see English' : 'Tap to see Kinyarwanda',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
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
            
            const SizedBox(height: 32),
            
            // Difficulty Buttons (show only when answer is visible)
            if (showAnswer) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: markHard,
                      icon: const Icon(Icons.sentiment_dissatisfied, color: Colors.white),
                      label: const Text('Hard', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: markEasy,
                      icon: const Icon(Icons.sentiment_satisfied, color: Colors.white),
                      label: const Text('Easy', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20 : 16),
            ],
            
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: previousCard,
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
                  onPressed: nextCard,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text('Next', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
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
