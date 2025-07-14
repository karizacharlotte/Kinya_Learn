import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DailyScenariosScreen extends StatefulWidget {
  const DailyScenariosScreen({super.key});

  @override
  State<DailyScenariosScreen> createState() => _DailyScenariosScreenState();
}

class _DailyScenariosScreenState extends State<DailyScenariosScreen> {
  int currentScenarioIndex = 0;
  int currentPhraseIndex = 0;
  bool showTranslation = false;

  final List<Map<String, dynamic>> scenarios = [
    {
      'title': 'At the Market',
      'description': 'Learn how to buy fruits and vegetables',
      'icon': Icons.shopping_cart,
      'color': const Color(0xFF4CAF50),
      'phrases': [
        {
          'kinyarwanda': 'Muraho! Mfite amaki menshi?',
          'english': 'Hello! Do you have many bananas?',
          'pronunciation': 'Moo-rah-ho! Mm-fee-tay ah-mah-kee men-she?',
        },
        {
          'kinyarwanda': 'Ni bangahe amaki?',
          'english': 'How much are the bananas?',
          'pronunciation': 'Nee bahn-gah-hay ah-mah-kee?',
        },
        {
          'kinyarwanda': 'Ndashaka gukura amaki atanu.',
          'english': 'I want to buy five bananas.',
          'pronunciation': 'Nn-dah-shah-kah goo-koo-rah ah-mah-kee ah-tah-noo.',
        },
        {
          'kinyarwanda': 'Murakoze cyane!',
          'english': 'Thank you very much!',
          'pronunciation': 'Moo-rah-ko-zay chah-nay!',
        },
      ],
    },
    {
      'title': 'At the Restaurant',
      'description': 'Order food and drinks',
      'icon': Icons.restaurant,
      'color': AppTheme.primaryOrange,
      'phrases': [
        {
          'kinyarwanda': 'Ndashaka kurya.',
          'english': 'I want to eat.',
          'pronunciation': 'Nn-dah-shah-kah koo-ree-ah.',
        },
        {
          'kinyarwanda': 'Ni iki gifite?',
          'english': 'What do you have?',
          'pronunciation': 'Nee ee-kee gee-fee-tay?',
        },
        {
          'kinyarwanda': 'Ndashaka ubwoba n\'amazi.',
          'english': 'I want rice and water.',
          'pronunciation': 'Nn-dah-shah-kah oo-bwo-bah nn ah-mah-zee.',
        },
        {
          'kinyarwanda': 'Ni bangahe byose?',
          'english': 'How much is everything?',
          'pronunciation': 'Nee bahn-gah-hay bee-oh-say?',
        },
      ],
    },
    {
      'title': 'Meeting New People',
      'description': 'Introduce yourself and make friends',
      'icon': Icons.people,
      'color': const Color(0xFF00A1DE),
      'phrases': [
        {
          'kinyarwanda': 'Nitwa...',
          'english': 'My name is...',
          'pronunciation': 'Nee-twa...',
        },
        {
          'kinyarwanda': 'Uziko witwa nde?',
          'english': 'What is your name?',
          'pronunciation': 'Oo-zee-ko wee-twa nn-day?',
        },
        {
          'kinyarwanda': 'Ni nshuti njye.',
          'english': 'Nice to meet you.',
          'pronunciation': 'Nee nn-shoo-tee nn-jye.',
        },
        {
          'kinyarwanda': 'Ufite imyaka ingahe?',
          'english': 'How old are you?',
          'pronunciation': 'Oo-fee-tay ee-mee-ah-kah een-gah-hay?',
        },
      ],
    },
    {
      'title': 'Asking for Directions',
      'description': 'Navigate around town',
      'icon': Icons.map,
      'color': const Color(0xFF9C27B0),
      'phrases': [
        {
          'kinyarwanda': 'Nsaba, ishuri riri hehe?',
          'english': 'Excuse me, where is the school?',
          'pronunciation': 'Nn-sah-bah, ee-shoo-ree ree-ree hay-hay?',
        },
        {
          'kinyarwanda': 'Ni hehe inzira igana kuri...',
          'english': 'Which way leads to...',
          'pronunciation': 'Nee hay-hay een-zee-rah ee-gah-nah koo-ree...',
        },
        {
          'kinyarwanda': 'Ni kure cyane?',
          'english': 'Is it very far?',
          'pronunciation': 'Nee koo-ray chah-nay?',
        },
        {
          'kinyarwanda': 'Murakoze kubamfasha.',
          'english': 'Thank you for helping me.',
          'pronunciation': 'Moo-rah-ko-zay koo-bam-fah-shah.',
        },
      ],
    },
    {
      'title': 'At the Hospital',
      'description': 'Health-related conversations',
      'icon': Icons.local_hospital,
      'color': Colors.red,
      'phrases': [
        {
          'kinyarwanda': 'Ndwaye.',
          'english': 'I am sick.',
          'pronunciation': 'Nn-dwa-yay.',
        },
        {
          'kinyarwanda': 'Mbarira intege.',
          'english': 'I have a headache.',
          'pronunciation': 'Mm-bah-ree-rah een-tay-gay.',
        },
        {
          'kinyarwanda': 'Ndashaka kujya kwa muganga.',
          'english': 'I want to go to the doctor.',
          'pronunciation': 'Nn-dah-shah-kah koo-jya kwa moo-gahn-gah.',
        },
        {
          'kinyarwanda': 'Ni imiti nzafata?',
          'english': 'What medicine should I take?',
          'pronunciation': 'Nee ee-mee-tee nn-zah-fah-tah?',
        },
      ],
    },
  ];

  void _nextPhrase() {
    if (currentPhraseIndex < scenarios[currentScenarioIndex]['phrases'].length - 1) {
      setState(() {
        currentPhraseIndex++;
        showTranslation = false;
      });
    }
  }

  void _previousPhrase() {
    if (currentPhraseIndex > 0) {
      setState(() {
        currentPhraseIndex--;
        showTranslation = false;
      });
    }
  }

  void _nextScenario() {
    if (currentScenarioIndex < scenarios.length - 1) {
      setState(() {
        currentScenarioIndex++;
        currentPhraseIndex = 0;
        showTranslation = false;
      });
    }
  }

  void _previousScenario() {
    if (currentScenarioIndex > 0) {
      setState(() {
        currentScenarioIndex--;
        currentPhraseIndex = 0;
        showTranslation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentScenario = scenarios[currentScenarioIndex];
    final currentPhrase = currentScenario['phrases'][currentPhraseIndex];

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Scenarios',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Practice real-life conversations',
                        style: TextStyle(
                          color: isDark ? theme.colorScheme.onSurface.withValues(alpha: 0.7) : Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chat_bubble,
                    color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                    size: isTablet ? 36 : 32),
              ],
            ),
          ),
          // Scenario Navigation
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: currentScenarioIndex > 0 ? _previousScenario : null,
                  icon: Icon(Icons.arrow_back_ios),
                  color: currentScenarioIndex > 0 ? AppTheme.textPrimary : Colors.grey,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        currentScenario['title'],
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        currentScenario['description'],
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        '${currentScenarioIndex + 1} / ${scenarios.length}',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: currentScenarioIndex < scenarios.length - 1 ? _nextScenario : null,
                  icon: Icon(Icons.arrow_forward_ios),
                  color: currentScenarioIndex < scenarios.length - 1 ? AppTheme.textPrimary : Colors.grey,
                ),
              ],
            ),
          ),
          // Phrase Card
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
                      // Scenario icon
                      Container(
                        width: isTablet ? 80 : 60,
                        height: isTablet ? 80 : 60,
                        decoration: BoxDecoration(
                          color: currentScenario['color'].withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          currentScenario['icon'],
                          color: currentScenario['color'],
                          size: isTablet ? 40 : 30,
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      // Kinyarwanda phrase
                      Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: currentScenario['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                        ),
                        child: Text(
                          currentPhrase['kinyarwanda'],
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      // Pronunciation
                      Text(
                        currentPhrase['pronunciation'],
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: AppTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Show translation button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showTranslation = !showTranslation;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentScenario['color'],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 24 : 16,
                            vertical: isTablet ? 12 : 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                        ),
                        child: Text(
                          showTranslation ? 'Hide Translation' : 'Show Translation',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Translation
                      if (showTranslation) ...[
                        SizedBox(height: isTablet ? 20 : 16),
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                          ),
                          child: Text(
                            currentPhrase['english'],
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Phrase navigation
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPhraseIndex > 0 ? _previousPhrase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPhraseIndex > 0 ? AppTheme.cardBackground : Colors.grey.shade300,
                    foregroundColor: currentPhraseIndex > 0 ? AppTheme.textPrimary : Colors.grey,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 12 : 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: isTablet ? 20 : 16),
                      SizedBox(width: isTablet ? 8 : 4),
                      Text(
                        'Previous',
                        style: TextStyle(fontSize: isTablet ? 16 : 14),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${currentPhraseIndex + 1} / ${currentScenario['phrases'].length}',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                ElevatedButton(
                  onPressed: currentPhraseIndex < currentScenario['phrases'].length - 1 ? _nextPhrase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPhraseIndex < currentScenario['phrases'].length - 1 ? currentScenario['color'] : Colors.grey.shade300,
                    foregroundColor: currentPhraseIndex < currentScenario['phrases'].length - 1 ? Colors.white : Colors.grey,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 12 : 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(fontSize: isTablet ? 16 : 14),
                      ),
                      SizedBox(width: isTablet ? 8 : 4),
                      Icon(Icons.arrow_forward, size: isTablet ? 20 : 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
