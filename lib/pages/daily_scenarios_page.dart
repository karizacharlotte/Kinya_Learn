import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../theme/app_theme.dart';
import '../components/navigation.dart';

class DailyScenariosPage extends StatefulWidget {
  const DailyScenariosPage({super.key});

  @override
  State<DailyScenariosPage> createState() => _DailyScenariosPageState();
}

class _DailyScenariosPageState extends State<DailyScenariosPage> {
  int _currentScenarioIndex = 0;
  int _currentDialogueIndex = 0;
  bool _showTranslation = false;
  late FlutterTts _flutterTts;
  bool _isSpeaking = false;

  final List<DailyScenario> _scenarios = [
    DailyScenario(
      title: "At the Market",
      description: "Learn how to buy fruits and vegetables",
      category: "Shopping",
      icon: Icons.store,
      color: AppTheme.success,
      dialogue: [
        DialogueLine(
          speaker: "Buyer",
          kinyarwanda: "Muraho! Amaki angahe?",
          english: "Hello! How much are the bananas?",
          phonetic: "Muu-rah-ho! Ah-mah-kee ah-nga-heh?",
        ),
        DialogueLine(
          speaker: "Seller",
          kinyarwanda: "Muraho! Amaki ni amafaranga magana atanu ku kilo.",
          english: "Hello! Bananas are 500 francs per kilo.",
          phonetic: "Muu-rah-ho! Ah-mah-kee nee ah-mah-fah-ran-ga mah-gah-nah ah-tah-nuu kuu kee-lo.",
        ),
        DialogueLine(
          speaker: "Buyer",
          kinyarwanda: "Ndashaka kilo ebyiri. Hari inyama?",
          english: "I want two kilos. Do you have meat?",
          phonetic: "N-dah-shah-kah kee-lo eh-byee-ree. Hah-ree ee-nyah-mah?",
        ),
        DialogueLine(
          speaker: "Seller",
          kinyarwanda: "Yego, hari inyama nziza. Igiciro ni amafaranga ibihumbi bitatu ku kilo.",
          english: "Yes, there is good meat. The price is 3000 francs per kilo.",
          phonetic: "Yeh-go, hah-ree ee-nyah-mah n-zee-zah. Ee-gee-chee-ro nee ah-mah-fah-ran-ga ee-bee-huum-bee bee-tah-tuu kuu kee-lo.",
        ),
        DialogueLine(
          speaker: "Buyer",
          kinyarwanda: "Sawa. Mpa amaki abiri n'inyama kilo imwe.",
          english: "Okay. Give me two bananas and one kilo of meat.",
          phonetic: "Sah-wah. M-pah ah-mah-kee ah-bee-ree nee-nyah-mah kee-lo eem-weh.",
        ),
        DialogueLine(
          speaker: "Seller",
          kinyarwanda: "Byose ni amafaranga ibihumbi bitatu n'amajana atanu.",
          english: "Everything is 3500 francs.",
          phonetic: "Byoh-seh nee ah-mah-fah-ran-ga ee-bee-huum-bee bee-tah-tuu nah-mah-jah-nah ah-tah-nuu.",
        ),
      ],
    ),
    DailyScenario(
      title: "At the Restaurant",
      description: "Order food and drinks in Kinyarwanda",
      category: "Dining",
      icon: Icons.restaurant,
      color: AppTheme.primaryOrange,
      dialogue: [
        DialogueLine(
          speaker: "Waiter",
          kinyarwanda: "Murakaza neza! Mwifuza iki?",
          english: "Welcome! What would you like?",
          phonetic: "Muu-rah-kah-zah neh-zah! Mwee-fuu-zah ee-kee?",
        ),
        DialogueLine(
          speaker: "Customer",
          kinyarwanda: "Ndashaka ubugali n'inyama y'inka.",
          english: "I want ugali and beef.",
          phonetic: "N-dah-shah-kah uu-buu-gah-lee nee-nyah-mah yeen-kah.",
        ),
        DialogueLine(
          speaker: "Waiter",
          kinyarwanda: "Mwifuza iki cyo kunywa?",
          english: "What would you like to drink?",
          phonetic: "Mwee-fuu-zah ee-kee cho kuu-nyah?",
        ),
        DialogueLine(
          speaker: "Customer",
          kinyarwanda: "Mpa amazi meza, ndashaka n'ibitoki.",
          english: "Give me clean water, and I want bananas too.",
          phonetic: "M-pah ah-mah-zee meh-zah, n-dah-shah-kah nee-bee-toh-kee.",
        ),
        DialogueLine(
          speaker: "Waiter",
          kinyarwanda: "Sawa. Biragutwara amasaha cumi n'atanu.",
          english: "Okay. It will take you fifteen minutes.",
          phonetic: "Sah-wah. Bee-rah-guu-twah-rah ah-mah-sah-hah chuu-mee nah-tah-nuu.",
        ),
      ],
    ),
    DailyScenario(
      title: "Asking for Directions",
      description: "Navigate and ask for help finding places",
      category: "Transportation",
      icon: Icons.directions,
      color: const Color(0xFF00A1DE),
      dialogue: [
        DialogueLine(
          speaker: "Tourist",
          kinyarwanda: "Mbabarira, aho ni hehe Kigali City Tower?",
          english: "Excuse me, where is Kigali City Tower?",
          phonetic: "M-bah-bah-ree-rah, ah-ho nee heh-heh Kee-gah-lee City Tower?",
        ),
        DialogueLine(
          speaker: "Local",
          kinyarwanda: "Ni hafi cyane. Jya unyuze mu muhanda mukuru.",
          english: "It's very close. Go through the main road.",
          phonetic: "Nee hah-fee chah-neh. Jah uu-nyuu-zeh muu muu-hahn-dah muu-kuu-ruu.",
        ),
        DialogueLine(
          speaker: "Tourist",
          kinyarwanda: "Bigenda bite kugera?",
          english: "How long does it take to get there?",
          phonetic: "Bee-gen-dah bee-teh kuu-geh-rah?",
        ),
        DialogueLine(
          speaker: "Local",
          kinyarwanda: "Ni amasaha atanu gusa ukagenda n'amaguru.",
          english: "It's only five minutes if you walk.",
          phonetic: "Nee ah-mah-sah-hah ah-tah-nuu guu-sah uu-kah-gen-dah nah-mah-guu-ruu.",
        ),
        DialogueLine(
          speaker: "Tourist",
          kinyarwanda: "Murakoze cyane!",
          english: "Thank you very much!",
          phonetic: "Muu-rah-koh-zeh chah-neh!",
        ),
        DialogueLine(
          speaker: "Local",
          kinyarwanda: "Nta kibazo. Urugendo rwiza!",
          english: "No problem. Safe journey!",
          phonetic: "N-tah kee-bah-zo. Uu-ruu-gen-do rwee-zah!",
        ),
      ],
    ),
    DailyScenario(
      title: "Meeting New People",
      description: "Introduce yourself and make friends",
      category: "Social",
      icon: Icons.people,
      color: AppTheme.primaryPurple,
      dialogue: [
        DialogueLine(
          speaker: "Person A",
          kinyarwanda: "Muraho! Nitwa John. Wowe witwa nde?",
          english: "Hello! My name is John. What's your name?",
          phonetic: "Muu-rah-ho! Nee-twah John. Woh-weh wee-twah n-deh?",
        ),
        DialogueLine(
          speaker: "Person B",
          kinyarwanda: "Muraho John! Nitwa Marie. Ukomoka he?",
          english: "Hello John! My name is Marie. Where are you from?",
          phonetic: "Muu-rah-ho John! Nee-twah Marie. Uu-koh-moh-kah heh?",
        ),
        DialogueLine(
          speaker: "Person A",
          kinyarwanda: "Nkomoka muri Amerika. Wowe ukomoka he?",
          english: "I'm from America. Where are you from?",
          phonetic: "N-koh-moh-kah muu-ree Amerika. Woh-weh uu-koh-moh-kah heh?",
        ),
        DialogueLine(
          speaker: "Person B",
          kinyarwanda: "Ndi umunyarwanda. Ugiye gukora iki muri Rwanda?",
          english: "I'm Rwandan. What are you going to do in Rwanda?",
          phonetic: "N-dee uu-muu-nyahr-wahn-dah. Uu-gee-yeh guu-koh-rah ee-kee muu-ree Rwanda?",
        ),
        DialogueLine(
          speaker: "Person A",
          kinyarwanda: "Naje kwiga Ikinyarwanda. Urashobora kumfasha?",
          english: "I came to learn Kinyarwanda. Can you help me?",
          phonetic: "Nah-jeh kwee-gah Ee-kee-nyahr-wahn-dah. Uu-rah-shoh-boh-rah kuum-fah-shah?",
        ),
        DialogueLine(
          speaker: "Person B",
          kinyarwanda: "Yego! Ndashobora kukufasha. Tujye tukabyumva hamwe.",
          english: "Yes! I can help you. Let's go understand it together.",
          phonetic: "Yeh-go! N-dah-shoh-boh-rah kuu-kuu-fah-shah. Tuu-jeh tuu-kah-byuum-vah hahm-weh.",
        ),
      ],
    ),
    DailyScenario(
      title: "At the Bank",
      description: "Handle banking transactions",
      category: "Financial",
      icon: Icons.account_balance,
      color: AppTheme.primaryGreen,
      dialogue: [
        DialogueLine(
          speaker: "Customer",
          kinyarwanda: "Muraho! Ndashaka gufungura konti.",
          english: "Hello! I want to open an account.",
          phonetic: "Muu-rah-ho! N-dah-shah-kah guu-fuun-guu-rah kon-tee.",
        ),
        DialogueLine(
          speaker: "Bank Teller",
          kinyarwanda: "Muraho! Ufite irangamimerere?",
          english: "Hello! Do you have an ID?",
          phonetic: "Muu-rah-ho! Uu-fee-teh ee-rahn-gah-mee-meh-reh-reh?",
        ),
        DialogueLine(
          speaker: "Customer",
          kinyarwanda: "Yego, ndi nafite. Konti iza guca amafaranga angahe?",
          english: "Yes, I have it. How much money will the account cost?",
          phonetic: "Yeh-go, n-dee nah-fee-teh. Kon-tee ee-zah guu-chah ah-mah-fah-ran-ga ahn-gah-heh?",
        ),
        DialogueLine(
          speaker: "Bank Teller",
          kinyarwanda: "Konti ntiyishyura kintu. Ariko ugomba gushyira amafaranga ibihumbi makumyabiri.",
          english: "The account doesn't cost anything. But you need to deposit 20,000 francs.",
          phonetic: "Kon-tee n-tee-yee-shyuu-rah keen-tuu. Ah-ree-ko uu-gohm-bah guu-shyee-rah ah-mah-fah-ran-ga ee-bee-huum-bee mah-kuum-yah-bee-ree.",
        ),
        DialogueLine(
          speaker: "Customer",
          kinyarwanda: "Sawa. Hari ibindi byangombwa?",
          english: "Okay. Are there other requirements?",
          phonetic: "Sah-wah. Hah-ree ee-been-dee byahn-gohm-bwah?",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("fr-FR"); // Using French for better Kinyarwanda pronunciation
    await _flutterTts.setPitch(0.9);
    await _flutterTts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakPhonetic(String phonetic) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    setState(() => _isSpeaking = true);
    
    // Convert phonetic to more French-like pronunciation
    String frenchified = phonetic
        .replaceAll('ch', 'sh')
        .replaceAll('uu', 'ou')
        .replaceAll('ee', 'i')
        .replaceAll('ah', 'a')
        .replaceAll('oh', 'o')
        .replaceAll('eh', 'é')
        .replaceAll('-', ' ');
    
    await _flutterTts.speak(frenchified);
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  void _nextDialogue() {
    setState(() {
      if (_currentDialogueIndex < _scenarios[_currentScenarioIndex].dialogue.length - 1) {
        _currentDialogueIndex++;
      } else {
        _showCompletionDialog();
      }
      _showTranslation = false;
    });
  }

  void _previousDialogue() {
    setState(() {
      if (_currentDialogueIndex > 0) {
        _currentDialogueIndex--;
        _showTranslation = false;
      }
    });
  }

  void _nextScenario() {
    setState(() {
      if (_currentScenarioIndex < _scenarios.length - 1) {
        _currentScenarioIndex++;
        _currentDialogueIndex = 0;
        _showTranslation = false;
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Scenario Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: AppTheme.success,
            ),
            const SizedBox(height: 16),
            Text(
              'You completed "${_scenarios[_currentScenarioIndex].title}"!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep practicing daily scenarios to improve your conversational Kinyarwanda!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (_currentScenarioIndex < _scenarios.length - 1)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextScenario();
              },
              child: const Text('Next Scenario'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentDialogueIndex = 0;
                _showTranslation = false;
              });
            },
            child: const Text('Replay'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenario = _scenarios[_currentScenarioIndex];
    final dialogue = scenario.dialogue[_currentDialogueIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          const Navigation(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [scenario.color, scenario.color.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(scenario.icon, color: Colors.white, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Daily Scenarios',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    scenario.title,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scenario.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress and Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: scenario.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          scenario.category,
                          style: TextStyle(
                            color: scenario.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        'Line ${_currentDialogueIndex + 1} of ${scenario.dialogue.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentDialogueIndex + 1) / scenario.dialogue.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(scenario.color),
                  ),
                  const SizedBox(height: 32),

                  // Dialogue Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Speaker
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: scenario.color.withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  color: scenario.color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                dialogue.speaker,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: scenario.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Kinyarwanda Text
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  dialogue.kinyarwanda,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _speakPhonetic(dialogue.phonetic),
                                icon: Icon(
                                  _isSpeaking ? Icons.stop : Icons.volume_up,
                                  color: scenario.color,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: scenario.color.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Phonetic
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dialogue.phonetic,
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Translation Toggle
                          InkWell(
                            onTap: () => setState(() => _showTranslation = !_showTranslation),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _showTranslation 
                                    ? scenario.color.withOpacity(0.1)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _showTranslation ? scenario.color : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _showTranslation 
                                          ? dialogue.english
                                          : 'Tap to see translation',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _showTranslation 
                                            ? scenario.color
                                            : Colors.grey[600],
                                        fontWeight: _showTranslation ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    _showTranslation ? Icons.visibility : Icons.visibility_off,
                                    color: _showTranslation ? scenario.color : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation Buttons
                  Row(
                    children: [
                      if (_currentDialogueIndex > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _previousDialogue,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      if (_currentDialogueIndex > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _nextDialogue,
                          icon: Icon(_currentDialogueIndex < scenario.dialogue.length - 1 
                              ? Icons.arrow_forward 
                              : Icons.check),
                          label: Text(_currentDialogueIndex < scenario.dialogue.length - 1 
                              ? 'Next' 
                              : 'Complete'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: scenario.color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Scenario Selection
                  const SizedBox(height: 32),
                  Text(
                    'Other Scenarios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _scenarios.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _currentScenarioIndex;
                        final scenarioItem = _scenarios[index];
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _currentScenarioIndex = index;
                                _currentDialogueIndex = 0;
                                _showTranslation = false;
                              });
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? scenarioItem.color.withOpacity(0.1)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? scenarioItem.color : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        scenarioItem.icon,
                                        color: isSelected ? scenarioItem.color : Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: scenarioItem.color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          scenarioItem.category,
                                          style: TextStyle(
                                            color: scenarioItem.color,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    scenarioItem.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isSelected ? scenarioItem.color : Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    scenarioItem.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyScenario {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final List<DialogueLine> dialogue;

  DailyScenario({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.dialogue,
  });
}

class DialogueLine {
  final String speaker;
  final String kinyarwanda;
  final String english;
  final String phonetic;

  DialogueLine({
    required this.speaker,
    required this.kinyarwanda,
    required this.english,
    required this.phonetic,
  });
}
