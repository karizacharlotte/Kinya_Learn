import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(VoiceTestApp());
}

class VoiceTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Test',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: VoiceTestScreen(),
    );
  }
}

class VoiceTestScreen extends StatefulWidget {
  @override
  _VoiceTestScreenState createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  bool _ttsReady = false;
  String _currentVoice = 'Not set';

  final List<String> kinyarwandaPhrases = [
    'Muraho',
    'Murakoze cyane',
    'Amakuru',
    'Ese umeze gute',
    'Urabeho',
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(0.8);
      
      // Try to get available voices
      List<dynamic> voices = await _flutterTts.getVoices;
      if (voices.isNotEmpty) {
        var preferredVoice = voices.firstWhere(
          (voice) {
            String name = voice["name"].toString().toLowerCase();
            return name.contains("female") || name.contains("karen") || name.contains("zira");
          },
          orElse: () => voices.first,
        );
        await _flutterTts.setVoice(preferredVoice);
        setState(() {
          _currentVoice = preferredVoice["name"];
        });
      }
      
      setState(() {
        _ttsReady = true;
      });

      _flutterTts.setStartHandler(() {
        setState(() {
          _isPlaying = true;
        });
      });

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isPlaying = false;
        });
      });

      _flutterTts.setErrorHandler((msg) {
        setState(() {
          _isPlaying = false;
        });
        print('TTS Error: $msg');
      });

    } catch (e) {
      print('TTS initialization error: $e');
      setState(() {
        _ttsReady = false;
      });
    }
  }

  Future<void> _speak(String text) async {
    if (!_ttsReady) return;
    
    try {
      if (_isPlaying) {
        await _flutterTts.stop();
      } else {
        // Enhance pronunciation
        String enhanced = text.replaceAll('Muraho', 'Mu-ra-ho')
            .replaceAll('Murakoze', 'Mu-ra-ko-ze')
            .replaceAll('cyane', 'cha-ne')
            .replaceAll('Amakuru', 'A-ma-ku-ru')
            .replaceAll('Ese', 'E-se')
            .replaceAll('umeze', 'u-me-ze')
            .replaceAll('gute', 'gu-te')
            .replaceAll('Urabeho', 'U-ra-be-ho');
        
        await _flutterTts.speak(enhanced);
      }
    } catch (e) {
      print('TTS speak error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('African Voice Test'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.record_voice_over,
                      size: 48,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'African Voice Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _ttsReady ? 'Ready' : 'Not Ready',
                      style: TextStyle(
                        color: _ttsReady ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Current Voice: $_currentVoice',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Kinyarwanda Phrases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: kinyarwandaPhrases.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        kinyarwandaPhrases[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          color: Colors.orange,
                        ),
                        onPressed: _ttsReady 
                            ? () => _speak(kinyarwandaPhrases[index])
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
