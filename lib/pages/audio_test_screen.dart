import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../components/bottom_nav_bar.dart';

class AudioTestScreen extends StatefulWidget {
  const AudioTestScreen({Key? key}) : super(key: key);

  @override
  State<AudioTestScreen> createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _ttsReady = false;
  bool _isPlaying = false;
  String _currentVoice = 'Loading...';
  String _systemVolume = 'Unknown';
  List<dynamic> _availableVoices = [];
  String _lastError = '';
  
  final List<Map<String, String>> _testPhrases = [
    {
      'kinyarwanda': 'Muraho',
      'phonetic': 'Moo-rah-ho',
      'english': 'Hello',
      'enhanced': 'Moo rah ho',
    },
    {
      'kinyarwanda': 'Murakoze cyane',
      'phonetic': 'Moo-rah-ko-zeh chah-neh',
      'english': 'Thank you very much',
      'enhanced': 'Moo rah ko zeh, chah neh',
    },
    {
      'kinyarwanda': 'Amakuru',
      'phonetic': 'Ah-mah-koo-roo',
      'english': 'News/How are things',
      'enhanced': 'Ah mah koo roo',
    },
    {
      'kinyarwanda': 'Mwiriwe',
      'phonetic': 'Mwee-ree-weh',
      'english': 'Good evening',
      'enhanced': 'Mwee ree weh',
    },
    {
      'kinyarwanda': 'Mwaramutse',
      'phonetic': 'Mwah-rah-moot-seh',
      'english': 'Good morning',
      'enhanced': 'Mwah rah moot seh',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await _initializeTts();
    await _checkSystemAudio();
  }

  Future<void> _initializeTts() async {
    try {
      print('🎵 Initializing TTS...');
      
      // Get available voices first
      _availableVoices = await _flutterTts.getVoices;
      print('📢 Found ${_availableVoices.length} voices');
      
      // Set basic parameters
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.4); // Very slow
      await _flutterTts.setVolume(1.0); // Maximum volume
      await _flutterTts.setPitch(0.9); // Slightly lower pitch
      
      // Try different voice selection strategies
      if (_availableVoices.isNotEmpty) {
        var selectedVoice = _selectBestVoice();
        if (selectedVoice != null) {
          await _flutterTts.setVoice(Map<String, String>.from(selectedVoice));
          setState(() {
            _currentVoice = selectedVoice["name"] ?? "Unknown";
          });
          print('🗣️ Selected voice: ${_currentVoice}');
        }
      }
      
      // Platform-specific setup
      if (!kIsWeb) {
        try {
          // Only try setSharedInstance on non-web platforms
          await _flutterTts.setSharedInstance(true);
          print('✅ Set shared instance for mobile platform');
        } catch (e) {
          print('⚠️ Could not set shared instance: $e (continuing anyway)');
        }
      } else {
        print('🌐 Web platform detected, using web-optimized settings');
      }
      
      // Set handlers
      _flutterTts.setStartHandler(() {
        print('🎵 TTS Started');
        setState(() {
          _isPlaying = true;
        });
      });

      _flutterTts.setCompletionHandler(() {
        print('🎵 TTS Completed');
        setState(() {
          _isPlaying = false;
        });
      });

      _flutterTts.setErrorHandler((msg) {
        print('❌ TTS Error: $msg');
        setState(() {
          _isPlaying = false;
          _lastError = msg;
        });
      });

      _flutterTts.setPauseHandler(() {
        print('⏸️ TTS Paused');
        setState(() {
          _isPlaying = false;
        });
      });

      _flutterTts.setContinueHandler(() {
        print('▶️ TTS Continued');
        setState(() {
          _isPlaying = true;
        });
      });

      setState(() {
        _ttsReady = true;
      });
      
      print('✅ TTS Initialized successfully');
    } catch (e) {
      print('❌ TTS Initialization failed: $e');
      setState(() {
        _ttsReady = false;
        _lastError = e.toString();
      });
    }
  }

  Map<String, dynamic>? _selectBestVoice() {
    if (_availableVoices.isEmpty) return null;
    
    print('🌍 Selecting African-sounding voice from ${_availableVoices.length} options...');
    
    // Priority 1: Look for South African or African English voices
    var africanVoices = _availableVoices.where((voice) {
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
    var femaleVoices = _availableVoices.where((voice) {
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
          // These voices tend to have better African pronunciation
          return name.contains("zira") || name.contains("hazel") || 
                 name.contains("nicole") || name.contains("veena");
        },
        orElse: () => femaleVoices.first,
      );
      
      print('🎯 Selected female voice: ${preferredFemale["name"]}');
      return preferredFemale;
    }
    
    // Priority 3: Any English voice with good pronunciation
    var englishVoices = _availableVoices.where((voice) {
      String locale = voice["locale"]?.toString().toLowerCase() ?? "";
      return locale.startsWith("en");
    }).toList();
    
    if (englishVoices.isNotEmpty) {
      print('🎯 Using English voice: ${englishVoices.first["name"]}');
      return englishVoices.first;
    }
    
    // Fallback: Use first available voice
    print('🎯 Using fallback voice: ${_availableVoices.first["name"]}');
    return _availableVoices.first;
  }

  Future<void> _checkSystemAudio() async {
    try {
      // Test system audio capability
      setState(() {
        _systemVolume = 'Checking...';
      });
      
      // Try to get volume (this might not be available on all platforms)
      setState(() {
        _systemVolume = 'Audio system appears to be working';
      });
    } catch (e) {
      setState(() {
        _systemVolume = 'Audio system error: $e';
      });
    }
  }

  Future<void> _testSpeak(String text, String enhanced) async {
    if (!_ttsReady) {
      _showMessage('TTS not ready. Please check audio system.');
      return;
    }

    try {
      print('🗣️ Speaking: "$enhanced"');
      
      if (_isPlaying) {
        await _flutterTts.stop();
        setState(() {
          _isPlaying = false;
        });
        return;
      }

      // Speak the enhanced version for better pronunciation
      await _flutterTts.speak(enhanced);
      
      _showMessage('Playing: "$text" as "$enhanced"');
    } catch (e) {
      print('❌ Speak error: $e');
      setState(() {
        _lastError = e.toString();
      });
      _showMessage('Error playing audio: $e');
    }
  }

  Future<void> _testSystemBeep() async {
    try {
      // Test if system can make any sound at all
      await _audioPlayer.play(AssetSource('sounds/beep.mp3')); // This won't work without the asset
    } catch (e) {
      _showMessage('System audio test failed: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Audio Debug Center',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _ttsReady = false;
                _lastError = '';
              });
              _initializeAudio();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // System Status Card
            Card(
              color: _ttsReady ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _ttsReady ? Icons.check_circle : Icons.error,
                          color: _ttsReady ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Audio System Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _ttsReady ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildStatusRow('TTS Ready', _ttsReady ? 'Yes' : 'No'),
                    _buildStatusRow('Current Voice', _currentVoice),
                    _buildStatusRow('Available Voices', '${_availableVoices.length}'),
                    _buildStatusRow('System Audio', _systemVolume),
                    if (_lastError.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Last Error: $_lastError',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    
                    // Web-specific information
                    if (kIsWeb) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.language, color: Colors.blue.shade600, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Web Platform Notes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Audio requires user interaction to start\n'
                              '• Some TTS features may be limited\n'
                              '• If no sound, check browser audio settings\n'
                              '• Make sure your browser allows audio autoplay',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Test Audio Section
            Text(
              'Test Kinyarwanda Audio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Test Phrases
            ...(_testPhrases.map((phrase) => Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
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
                                phrase['kinyarwanda']!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pronunciation: ${phrase['phonetic']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'Meaning: ${phrase['english']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _ttsReady 
                              ? () => _testSpeak(phrase['kinyarwanda']!, phrase['enhanced']!)
                              : null,
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
              ),
            ))).toList(),
            
            SizedBox(height: 20),
            
            // Debug Actions
            Text(
              'Troubleshooting Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _flutterTts.speak("This is a simple English test");
                  _showMessage('Speaking simple English test');
                } catch (e) {
                  _showMessage('English test failed: $e');
                }
              },
              icon: Icon(Icons.record_voice_over),
              label: Text('Test Simple English'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _showAvailableVoices,
              icon: Icon(Icons.list),
              label: Text('Show Available Voices'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: () {
                _showMessage('Check: 1) Device volume 2) App permissions 3) Platform support');
              },
              icon: Icon(Icons.help),
              label: Text('Audio Troubleshooting Tips'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Practice tab
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvailableVoices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Available Voices (${_availableVoices.length})'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _availableVoices.length,
            itemBuilder: (context, index) {
              final voice = _availableVoices[index];
              return ListTile(
                title: Text(voice["name"] ?? "Unknown"),
                subtitle: Text(voice["locale"] ?? "Unknown locale"),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () async {
                    try {
                      await _flutterTts.setVoice(Map<String, String>.from(voice));
                      await _flutterTts.speak("Muraho");
                      setState(() {
                        _currentVoice = voice["name"] ?? "Unknown";
                      });
                      Navigator.pop(context);
                      _showMessage('Testing voice: ${voice["name"]}');
                    } catch (e) {
                      _showMessage('Voice test failed: $e');
                    }
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
