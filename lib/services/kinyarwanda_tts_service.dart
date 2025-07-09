import 'package:flutter_tts/flutter_tts.dart';

class KinyarwandaTTSService {
  static final KinyarwandaTTSService _instance = KinyarwandaTTSService._internal();
  factory KinyarwandaTTSService() => _instance;
  KinyarwandaTTSService._internal();

  FlutterTts? _tts;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _tts = FlutterTts();
    await _configureForKinyarwanda();
    _isInitialized = true;
  }

  Future<void> _configureForKinyarwanda() async {
    if (_tts == null) return;

    // Configure speech parameters for better Kinyarwanda pronunciation
    await _tts!.setSpeechRate(0.6); // Slower for clarity
    await _tts!.setVolume(1.0);
    await _tts!.setPitch(1.0);
    
    // Check available languages and voices
    var languages = await _tts!.getLanguages;
    var voices = await _tts!.getVoices;
    
    print('Available languages: $languages');
    print('Available voices: $voices');
    
    // Try multiple Kinyarwanda language codes in order of preference
    final kinyarwandaCodes = ['rw-RW', 'rw', 'kin-RW', 'kin'];
    bool kinyarwandaSet = false;
    
    if (languages != null) {
      for (String code in kinyarwandaCodes) {
        if (languages.contains(code)) {
          await _tts!.setLanguage(code);
          kinyarwandaSet = true;
          print('Successfully set Kinyarwanda language: $code');
          break;
        }
      }
    }
    
    // Try to find the best voice for Kinyarwanda
    if (voices != null && kinyarwandaSet) {
      var kinyarwandaVoice = voices.firstWhere(
        (voice) => voice['name']?.toString().toLowerCase().contains('kinyarwanda') == true ||
                   voice['name']?.toString().toLowerCase().contains('rwanda') == true ||
                   voice['locale']?.toString().toLowerCase().contains('rw') == true ||
                   voice['locale']?.toString().toLowerCase().contains('kin') == true,
        orElse: () => null,
      );
      
      if (kinyarwandaVoice != null) {
        await _tts!.setVoice(kinyarwandaVoice);
        print('Successfully set Kinyarwanda voice: ${kinyarwandaVoice['name']}');
      }
    }
    
    // If no Kinyarwanda support found, use fallback
    if (!kinyarwandaSet) {
      await _setFallbackLanguage(languages);
    }
  }

  Future<void> _setFallbackLanguage(List<dynamic>? languages) async {
    if (_tts == null || languages == null) return;
    
    // Priority order for fallback languages
    final fallbackOrder = [
      'sw-KE', // Swahili (Kenya)
      'sw-TZ', // Swahili (Tanzania)
      'fr-FR', // French (commonly spoken in Rwanda)
      'fr-CA', // French (Canada)
      'en-US', // English (US)
      'en-GB', // English (UK)
    ];
    
    for (String lang in fallbackOrder) {
      if (languages.contains(lang)) {
        await _tts!.setLanguage(lang);
        print('Using fallback language: $lang');
        break;
      }
    }
  }

  Future<void> speak(String text, {bool isKinyarwanda = false}) async {
    if (!_isInitialized) await initialize();
    if (_tts == null) return;
    
    await _tts!.stop(); // Stop any current speech
    
    if (isKinyarwanda) {
      // For Kinyarwanda text, use optimized settings
      await _tts!.setSpeechRate(0.5); // Even slower for Kinyarwanda clarity
      await _tts!.setPitch(1.1); // Slightly higher pitch for Kinyarwanda
      
      // Try to set Kinyarwanda language again before speaking
      var languages = await _tts!.getLanguages;
      final kinyarwandaCodes = ['rw-RW', 'rw', 'kin-RW', 'kin'];
      
      if (languages != null) {
        for (String code in kinyarwandaCodes) {
          if (languages.contains(code)) {
            await _tts!.setLanguage(code);
            break;
          }
        }
      }
      
      // Pre-process text for better Kinyarwanda pronunciation
      String processedText = _preprocessKinyarwandaText(text);
      await _tts!.speak(processedText);
    } else {
      // For English text, use normal settings
      await _tts!.setSpeechRate(0.7);
      await _tts!.setPitch(1.0);
      
      // Set to English for non-Kinyarwanda text
      await _tts!.setLanguage('en-US');
      await _tts!.speak(text);
    }
  }

  // Pre-process Kinyarwanda text for better pronunciation
  String _preprocessKinyarwandaText(String text) {
    // Add spaces around certain letter combinations for better pronunciation
    String processed = text;
    
    // Handle common Kinyarwanda sound patterns
    processed = processed.replaceAll('rw', 'r w');
    processed = processed.replaceAll('ny', 'n y');
    processed = processed.replaceAll('nk', 'n k');
    processed = processed.replaceAll('ng', 'n g');
    processed = processed.replaceAll('mb', 'm b');
    processed = processed.replaceAll('nd', 'n d');
    
    // Handle specific difficult words
    final wordReplacements = {
      'Mwaramutse': 'M-wa-ra-mu-tse',
      'Urakoze': 'U-ra-ko-ze',
      'Muraho': 'Mu-ra-ho',
      'Murabeho': 'Mu-ra-be-ho',
      'Amahoro': 'A-ma-ho-ro',
      'Amakuru': 'A-ma-ku-ru',
    };
    
    for (var entry in wordReplacements.entries) {
      processed = processed.replaceAll(entry.key, entry.value);
    }
    
    return processed;
  }

  Future<void> stop() async {
    if (_tts != null) {
      await _tts!.stop();
    }
  }

  Future<void> pause() async {
    if (_tts != null) {
      await _tts!.pause();
    }
  }

  Future<bool> isKinyarwandaAvailable() async {
    if (!_isInitialized) await initialize();
    if (_tts == null) return false;
    
    var languages = await _tts!.getLanguages;
    if (languages == null) return false;
    
    final kinyarwandaCodes = ['rw-RW', 'rw', 'kin-RW', 'kin'];
    return kinyarwandaCodes.any((code) => languages.contains(code));
  }

  Future<String> getCurrentLanguage() async {
    if (!_isInitialized) await initialize();
    if (_tts == null) return 'Unknown';
    
    try {
      var languages = await _tts!.getLanguages;
      return languages?.first ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  void dispose() {
    _tts?.stop();
    _tts = null;
    _isInitialized = false;
  }

  // Get pronunciation tips for common Kinyarwanda sounds
  static Map<String, String> getKinyarwandaPronunciationTips() {
    return {
      'r': 'Rolled R sound, like in Spanish',
      'rw': 'R followed by W sound, like "Rwanda"',
      'ny': 'Similar to "ny" in "canyon"',
      'sh': 'Sharp "sh" sound',
      'zh': 'Soft "zh" sound like "measure"',
      'mb': 'Nasal "mb" sound',
      'nd': 'Nasal "nd" sound',
      'ng': 'Nasal "ng" sound like "sing"',
      'nk': 'Nasal "nk" sound',
    };
  }

  // Common Kinyarwanda words with phonetic pronunciation
  static Map<String, Map<String, String>> getCommonWords() {
    return {
      'Muraho': {
        'phonetic': 'moo-RAH-ho',
        'meaning': 'Hello',
        'tips': 'Stress on the second syllable RAH',
      },
      'Mwaramutse': {
        'phonetic': 'mwah-rah-MOOT-say',
        'meaning': 'Good morning',
        'tips': 'Start with "mwah" sound, stress on MOOT',
      },
      'Urakoze': {
        'phonetic': 'oo-rah-KOH-zay',
        'meaning': 'Thank you',
        'tips': 'Stress on KOH, roll the R',
      },
      'Murabeho': {
        'phonetic': 'moo-rah-BEH-ho',
        'meaning': 'Goodbye',
        'tips': 'Stress on BEH, roll the R',
      },
      'Amahoro': {
        'phonetic': 'ah-mah-HOH-ro',
        'meaning': 'Peace',
        'tips': 'Stress on HOH, roll the final R',
      },
      'Mama': {
        'phonetic': 'MAH-mah',
        'meaning': 'Mother',
        'tips': 'Stress on first syllable',
      },
      'Papa': {
        'phonetic': 'PAH-pah',
        'meaning': 'Father',
        'tips': 'Stress on first syllable',
      },
      'Umwana': {
        'phonetic': 'oom-WAH-nah',
        'meaning': 'Child',
        'tips': 'Start with "oom" sound, stress on WAH',
      },
      'Rimwe': {
        'phonetic': 'REEM-weh',
        'meaning': 'One',
        'tips': 'Roll the R, stress on REEM',
      },
      'Kabiri': {
        'phonetic': 'kah-BEE-ree',
        'meaning': 'Two',
        'tips': 'Stress on BEE, roll the final R',
      },
      'Gatatu': {
        'phonetic': 'gah-TAH-too',
        'meaning': 'Three',
        'tips': 'Stress on TAH',
      },
      'Amakuru': {
        'phonetic': 'ah-mah-KOO-roo',
        'meaning': 'How are you?',
        'tips': 'Stress on KOO, roll the R',
      },
      'Ni meza': {
        'phonetic': 'nee MEH-zah',
        'meaning': 'I am fine',
        'tips': 'Stress on MEH',
      },
      'Yego': {
        'phonetic': 'YEH-go',
        'meaning': 'Yes',
        'tips': 'Stress on YEH',
      },
      'Oya': {
        'phonetic': 'OH-yah',
        'meaning': 'No',
        'tips': 'Stress on OH',
      },
    };
  }
}
