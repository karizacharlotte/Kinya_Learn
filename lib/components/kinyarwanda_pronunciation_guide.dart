import 'package:flutter/material.dart';
import '../services/kinyarwanda_tts_service.dart';
import '../theme/app_theme.dart';

class KinyarwandaPronunciationGuide extends StatefulWidget {
  const KinyarwandaPronunciationGuide({super.key});

  @override
  State<KinyarwandaPronunciationGuide> createState() => _KinyarwandaPronunciationGuideState();
}

class _KinyarwandaPronunciationGuideState extends State<KinyarwandaPronunciationGuide> {
  late KinyarwandaTTSService _ttsService;
  bool _isPlaying = false;
  String _currentPlayingWord = '';

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _ttsService = KinyarwandaTTSService();
    await _ttsService.initialize();
  }

  Future<void> _speakWord(String word) async {
    if (_isPlaying && _currentPlayingWord == word) {
      await _ttsService.stop();
      setState(() {
        _isPlaying = false;
        _currentPlayingWord = '';
      });
      return;
    }

    setState(() {
      _isPlaying = true;
      _currentPlayingWord = word;
    });

    await _ttsService.speak(word, isKinyarwanda: true);

    setState(() {
      _isPlaying = false;
      _currentPlayingWord = '';
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonWords = KinyarwandaTTSService.getCommonWords();
    final pronunciationTips = KinyarwandaTTSService.getKinyarwandaPronunciationTips();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Kinyarwanda Pronunciation Guide',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Pronunciation Tips Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.tips_and_updates, color: AppTheme.primaryOrange),
                  const SizedBox(width: 8),
                  const Text(
                    'Pronunciation Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...pronunciationTips.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Common Words Section
        const Text(
          'Common Words with Audio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Words Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: commonWords.length,
          itemBuilder: (context, index) {
            final word = commonWords.keys.elementAt(index);
            final wordData = commonWords[word]!;
            final isCurrentlyPlaying = _isPlaying && _currentPlayingWord == word;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrentlyPlaying 
                      ? AppTheme.primaryBlue 
                      : Theme.of(context).dividerColor,
                  width: isCurrentlyPlaying ? 2 : 1,
                ),
                boxShadow: isCurrentlyPlaying
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _speakWord(word),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Kinyarwanda word
                        Text(
                          word,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        
                        // Phonetic
                        Text(
                          wordData['phonetic']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        // English meaning
                        Text(
                          wordData['meaning']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        // Audio button
                        Icon(
                          isCurrentlyPlaying ? Icons.volume_up : Icons.play_arrow,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Audio Settings Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  const Text(
                    'Audio Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '• Audio is optimized for Kinyarwanda pronunciation\n'
                '• Slower speech rate for better learning\n'
                '• Tap any word to hear its pronunciation\n'
                '• If Kinyarwanda voice is unavailable, the app uses the closest available language',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
