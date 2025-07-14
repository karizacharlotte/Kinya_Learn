import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../components/bottom_nav_bar.dart';

class AfricanVoiceDemoScreen extends StatefulWidget {
  const AfricanVoiceDemoScreen({Key? key}) : super(key: key);

  @override
  State<AfricanVoiceDemoScreen> createState() => _AfricanVoiceDemoScreenState();
}

class _AfricanVoiceDemoScreenState extends State<AfricanVoiceDemoScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _ttsReady = false;
  bool _isPlaying = false;
  String _currentVoice = 'Loading...';
  List<dynamic> _availableVoices = [];

  final List<Map<String, String>> _demoSentences = [
    {
      'kinyarwanda': 'Muraho',
      'phonetic': 'Moo-rah-ho',
      'english': 'Hello',
      'enhanced': 'Moo-rah-hoh',
    },
    {
      'kinyarwanda': 'Murakoze cyane',
      'phonetic': 'Moo-rah-koh-zeh chah-neh',
      'english': 'Thank you very much',
      'enhanced': 'Moo-rah-koh-zeh... chah-neh',
    },
    {
      'kinyarwanda': 'Amakuru',
      'phonetic': 'Ah-mah-koo-roo',
      'english': 'How are things?',
      'enhanced': 'Ah-mah-koo-roo',
    },
    {
      'kinyarwanda': 'Mwiriwe',
      'phonetic': 'Mwee-ree-weh',
      'english': 'Good evening',
      'enhanced': 'Mwee-ree-weh',
    },
    {
      'kinyarwanda': 'Mwaramutse',
      'phonetic': 'Mwah-rah-moot-seh',
      'english': 'Good morning',
      'enhanced': 'Mwah-rah-moot-seh',
    },
    {
      'kinyarwanda': 'Ese umeze gute',
      'phonetic': 'Eh-seh oo-meh-zeh goo-teh',
      'english': 'How are you?',
      'enhanced': 'Eh-seh? oo-meh-zeh? goo-teh',
    },
    {
      'kinyarwanda': 'Nitwa Rwanda',
      'phonetic': 'Nee-twah Roo-wah-n-dah',
      'english': 'It is called Rwanda',
      'enhanced': 'Nee-twah... Roo-wah-n-dah',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAfrikanVoice();
  }

  Future<void> _initializeAfrikanVoice() async {
    try {
      print('🌍 Initializing African voice for Kinyarwanda...');
      
      // Get available voices
      _availableVoices = await _flutterTts.getVoices;
      print('📢 Found ${_availableVoices.length} voices');
      
      // African voice selection
      var africanVoice = _selectAfricanVoice(_availableVoices);
      await _flutterTts.setVoice(Map<String, String>.from(africanVoice));
      
      // Optimize settings for authentic African accent
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.32); // Even slower for authentic African rhythm
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(0.70); // Lower pitch for authentic African tone
      
      // Platform-specific setup
      if (!kIsWeb) {
        try {
          await _flutterTts.setSharedInstance(true);
        } catch (e) {
          print('⚠️ Could not set shared instance: $e');
        }
      }
      
      setState(() {
        _ttsReady = true;
        _currentVoice = africanVoice["name"] ?? "Unknown";
      });
      
      // Set handlers
      _flutterTts.setStartHandler(() {
        setState(() => _isPlaying = true);
      });
      
      _flutterTts.setCompletionHandler(() {
        setState(() => _isPlaying = false);
      });
      
      _flutterTts.setErrorHandler((msg) {
        print('❌ TTS Error: $msg');
        setState(() => _isPlaying = false);
      });
      
      print('✅ African voice initialized: ${_currentVoice}');
      
    } catch (e) {
      print('❌ African voice initialization failed: $e');
      setState(() {
        _ttsReady = false;
      });
    }
  }

  Map<String, dynamic> _selectAfricanVoice(List<dynamic> voices) {
    print('🌍 Selecting African-sounding voice from ${voices.length} options...');
    
    // Priority 1: Look for South African or African English voices
    var africanVoices = voices.where((voice) {
      String name = voice["name"].toString().toLowerCase();
      String locale = voice["locale"]?.toString().toLowerCase() ?? "";
      
      // South African English voices
      if (locale.contains("za") || locale.contains("south") || 
          name.contains("south african") || name.contains("za")) {
        return true;
      }
      
      // Other African English variants
      if (locale.contains("ng") || locale.contains("gh") || 
          locale.contains("ke") || locale.contains("tz") ||
          name.contains("african") || name.contains("nigeria") ||
          name.contains("ghana") || name.contains("kenya")) {
        return true;
      }
      
      return false;
    }).toList();
    
    if (africanVoices.isNotEmpty) {
      print('🎯 Found African voice: ${africanVoices.first["name"]}');
      return africanVoices.first;
    }
    
    // Priority 2: Female voices with deeper tone (more African-sounding)
    var femaleVoices = voices.where((voice) {
      String name = voice["name"].toString().toLowerCase();
      String locale = voice["locale"]?.toString().toLowerCase() ?? "";
      
      // Look for female voices in English that sound more African
      if (locale.startsWith("en") && (
          name.contains("female") ||
          name.contains("woman") ||
          // Specific voices known to have good African pronunciation
          name.contains("zira") ||
          name.contains("hazel") ||
          name.contains("susan") ||
          name.contains("karen") ||
          name.contains("nicole") ||
          name.contains("veena") ||
          name.contains("tessa") ||
          name.contains("fiona"))) {
        return true;
      }
      
      return false;
    }).toList();
    
    if (femaleVoices.isNotEmpty) {
      // Prefer voices that might sound more African
      var preferredFemale = femaleVoices.firstWhere(
        (voice) {
          String name = voice["name"].toString().toLowerCase();
          return name.contains("zira") || name.contains("hazel") || 
                 name.contains("nicole") || name.contains("veena");
        },
        orElse: () => femaleVoices.first,
      );
      
      print('🎯 Selected female voice: ${preferredFemale["name"]}');
      return preferredFemale;
    }
    
    // Priority 3: Any English voice
    var englishVoices = voices.where((voice) {
      String locale = voice["locale"]?.toString().toLowerCase() ?? "";
      return locale.startsWith("en");
    }).toList();
    
    if (englishVoices.isNotEmpty) {
      print('🎯 Using English voice: ${englishVoices.first["name"]}');
      return englishVoices.first;
    }
    
    // Fallback
    print('🎯 Using fallback voice: ${voices.first["name"]}');
    return voices.first;
  }

  Future<void> _playAfrican(String enhanced) async {
    if (!_ttsReady) return;
    
    try {
      if (_isPlaying) {
        await _flutterTts.stop();
      } else {
        print('🎵 Playing African pronunciation: $enhanced');
        await _flutterTts.speak(enhanced);
      }
    } catch (e) {
      print('❌ Playback error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('African Voice Demo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌍 African Voice for Kinyarwanda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Authentic pronunciation with African voice synthesis',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Voice Status
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _ttsReady ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _ttsReady ? Colors.green.shade200 : Colors.red.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _ttsReady ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Status: ${_ttsReady ? "Ready" : "Initializing..."}'),
                  Text('Voice: $_currentVoice'),
                  Text('Total Voices: ${_availableVoices.length}'),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Demo Sentences
            Text(
              'Demo Sentences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 12),
            
            ..._demoSentences.map((sentence) => Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentence['kinyarwanda']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Text(
                              'Phonetic: ${sentence['phonetic']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'English: ${sentence['english']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _ttsReady ? () => _playAfrican(sentence['enhanced']!) : null,
                        icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Stop' : 'Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
            
            SizedBox(height: 20),
            
            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 How to Use African Voice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Voice selection prioritizes African and South African English voices\n'
                    '• Slower speech rate (0.35x) for clear pronunciation\n'
                    '• Lower pitch (0.75) for more authentic African tone\n'
                    '• Enhanced phonetic spelling for better TTS output\n'
                    '• Syllable separation with pauses for clarity',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Practice tab
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
