import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class KinyarwandaAudioService {
  static final KinyarwandaAudioService _instance = KinyarwandaAudioService._internal();
  factory KinyarwandaAudioService() => _instance;
  KinyarwandaAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isPlaying = false;

  // Audio file mapping for each Kinyarwanda phrase
  final Map<String, String> _audioFiles = {
    'Muraho': 'assets/audio/kinyarwanda/muraho.mp3',
    'Murakoze cyane': 'assets/audio/kinyarwanda/murakoze_cyane.mp3',
    'Mwiriwe': 'assets/audio/kinyarwanda/mwiriwe.mp3',
    'Mwaramutse': 'assets/audio/kinyarwanda/mwaramutse.mp3',
    'Muramuke neza': 'assets/audio/kinyarwanda/muramuke_neza.mp3',
    'Ni mwiza': 'assets/audio/kinyarwanda/ni_mwiza.mp3',
    'Amakuru': 'assets/audio/kinyarwanda/amakuru.mp3',
    'Ese umeze gute': 'assets/audio/kinyarwanda/ese_umeze_gute.mp3',
  };

  // Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('🎵 Initializing Kinyarwanda Audio Service...');
      
      // Initialize audio player
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setBalance(0.0);
      
      // Initialize TTS as fallback
      await _initializeTtsFallback();
      
      _isInitialized = true;
      print('✅ Kinyarwanda Audio Service initialized successfully');
    } catch (e) {
      print('❌ Error initializing audio service: $e');
      throw Exception('Failed to initialize audio service: $e');
    }
  }

  // Initialize TTS as fallback for when audio files are not available
  Future<void> _initializeTtsFallback() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.6); // More natural speed for African rhythm
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(0.75); // Slightly higher pitch for better clarity
      
      // Select African-sounding voice if available
      List<dynamic> voices = await _flutterTts.getVoices;
      if (voices.isNotEmpty) {
        var preferredVoice = _selectAfricanVoice(voices);
        if (preferredVoice != null) {
          Map<String, String> voiceMap = {};
          preferredVoice.forEach((key, value) {
            if (key != null && value != null) {
              voiceMap[key.toString()] = value.toString();
            }
          });
          if (voiceMap.isNotEmpty) {
            await _flutterTts.setVoice(voiceMap);
          }
        }
      }
      
      if (!kIsWeb) {
        await _flutterTts.setSharedInstance(true);
      }
      await _flutterTts.awaitSpeakCompletion(true);
      
      print('🗣️ TTS fallback initialized');
    } catch (e) {
      print('⚠️ TTS fallback initialization failed: $e');
    }
  }

  // Select the best African-sounding voice
  dynamic _selectAfricanVoice(List<dynamic> voices) {
    try {
      // Priority list for authentic African accent
      List<String> preferredVoices = [
        'en-za', 'en-ke', 'en-ng', 'en-gh', 'en-ug', // African English variants
        'en-au', 'en-in', // Commonwealth English (closer to African accent)
        'en-gb', // British English
        'en-us', // American English as last resort
      ];
      
      // Look for female voices with African/Commonwealth locales
      for (String locale in preferredVoices) {
        for (var voice in voices) {
          try {
            String voiceLocale = voice['locale']?.toString().toLowerCase() ?? '';
            String voiceName = voice['name']?.toString().toLowerCase() ?? '';
            
            if (voiceLocale.contains(locale.toLowerCase())) {
              // Prefer female voices for softer, more authentic sound
              if (voiceName.contains('female') || 
                  voiceName.contains('woman') || 
                  voiceName.contains('lady') ||
                  voiceName.contains('zira') ||
                  voiceName.contains('hazel') ||
                  voiceName.contains('susan')) {
                return voice;
              }
            }
          } catch (e) {
            continue;
          }
        }
      }
      
      // Fallback to first available voice
      return voices.first;
    } catch (e) {
      print('⚠️ Voice selection error: $e');
      return null;
    }
  }

  // Play authentic African voice audio for a Kinyarwanda phrase
  Future<bool> playKinyarwandaPhrase(String phrase, {
    VoidCallback? onStart,
    VoidCallback? onComplete,
    Function(String)? onError,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isPlaying) {
      await stop();
    }

    try {
      String audioFile = _audioFiles[phrase] ?? '';
      
      if (audioFile.isNotEmpty) {
        // Try to play pre-recorded authentic audio first
        bool audioSuccess = await _playPreRecordedAudio(audioFile, onStart, onComplete, onError);
        if (audioSuccess) {
          print('🎵 Playing authentic African voice: $phrase');
          return true;
        }
      }
      
      // Fallback to enhanced TTS
      print('🔄 Falling back to TTS for: $phrase');
      return await _playTtsFallback(phrase, onStart, onComplete, onError);
      
    } catch (e) {
      print('❌ Error playing phrase "$phrase": $e');
      onError?.call('Failed to play audio: $e');
      return false;
    }
  }

  // Play pre-recorded authentic audio
  Future<bool> _playPreRecordedAudio(String audioFile, VoidCallback? onStart, VoidCallback? onComplete, Function(String)? onError) async {
    try {
      _isPlaying = true;
      onStart?.call();
      
      // Check if audio file exists
      try {
        await rootBundle.load(audioFile);
      } catch (e) {
        print('⚠️ Audio file not found: $audioFile');
        return false;
      }
      
      // Play the audio file
      await _audioPlayer.play(AssetSource(audioFile.replaceFirst('assets/', '')));
      
      // Set up completion listener
      _audioPlayer.onPlayerComplete.listen((event) {
        _isPlaying = false;
        onComplete?.call();
      });
      
      return true;
    } catch (e) {
      print('❌ Error playing pre-recorded audio: $e');
      _isPlaying = false;
      return false;
    }
  }

  // Enhanced TTS fallback with African accent optimization
  Future<bool> _playTtsFallback(String phrase, VoidCallback? onStart, VoidCallback? onComplete, Function(String)? onError) async {
    try {
      _isPlaying = true;
      onStart?.call();
      
      // Apply pronunciation adjustments for African accent
      String adjustedPhrase = _adjustPronunciationForAfricanAccent(phrase);
      
      // Set up TTS handlers
      _flutterTts.setStartHandler(() {
        print('🎵 TTS started for: $phrase');
      });
      
      _flutterTts.setCompletionHandler(() {
        print('🎵 TTS completed for: $phrase');
        _isPlaying = false;
        onComplete?.call();
      });
      
      _flutterTts.setErrorHandler((msg) {
        print('❌ TTS error: $msg');
        _isPlaying = false;
        onError?.call('TTS error: $msg');
      });
      
      // Speak the phrase
      await _flutterTts.speak(adjustedPhrase);
      return true;
      
    } catch (e) {
      print('❌ TTS fallback error: $e');
      _isPlaying = false;
      onError?.call('TTS error: $e');
      return false;
    }
  }

  // Adjust pronunciation to sound more like African accent
  String _adjustPronunciationForAfricanAccent(String phrase) {
    // Common African accent patterns
    Map<String, String> pronunciationMap = {
      'Muraho': 'Moo-rah-ho',
      'Murakoze cyane': 'Moo-rah-koh-zeh chah-neh',
      'Mwiriwe': 'Mwee-ree-weh',
      'Mwaramutse': 'Mwah-rah-moot-seh',
      'Muramuke neza': 'Moo-rah-moo-keh neh-zah',
      'Ni mwiza': 'Nee mwee-zah',
      'Amakuru': 'Ah-mah-koo-roo',
      'Ese umeze gute': 'Eh-seh oo-meh-zeh goo-teh',
    };
    
    return pronunciationMap[phrase] ?? phrase;
  }

  // Stop current audio playback
  Future<void> stop() async {
    if (_isPlaying) {
      try {
        await _audioPlayer.stop();
        await _flutterTts.stop();
        _isPlaying = false;
        print('🛑 Audio stopped');
      } catch (e) {
        print('⚠️ Error stopping audio: $e');
      }
    }
  }

  // Check if audio is currently playing
  bool get isPlaying => _isPlaying;

  // Dispose of resources
  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
    await _flutterTts.stop();
    _isInitialized = false;
    print('🗑️ Audio service disposed');
  }
}
