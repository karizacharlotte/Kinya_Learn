import 'package:flutter/material.dart';
import '../services/kinyarwanda_tts_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_helper.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  late KinyarwandaTTSService _ttsService;
  bool _isKinyarwandaAvailable = false;
  String _currentLanguage = 'Unknown';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _ttsService = KinyarwandaTTSService();
    await _ttsService.initialize();
    
    final isAvailable = await _ttsService.isKinyarwandaAvailable();
    final currentLang = await _ttsService.getCurrentLanguage();
    
    setState(() {
      _isKinyarwandaAvailable = isAvailable;
      _currentLanguage = currentLang;
      _isLoading = false;
    });
  }

  Future<void> _testKinyarwandaPronunciation() async {
    await _ttsService.speak('Muraho! Mwaramutse. Urakoze cyane.', isKinyarwanda: true);
  }

  Future<void> _testEnglishPronunciation() async {
    await _ttsService.speak('Hello! Good morning. Thank you very much.', isKinyarwanda: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings'),
        backgroundColor: ThemeHelper.getAppBarBackgroundColor(context),
        foregroundColor: ThemeHelper.getAppBarForegroundColor(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TTS Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Text-to-Speech Status',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getAccentColor(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatusRow(
                            'Kinyarwanda Support',
                            _isKinyarwandaAvailable,
                            _isKinyarwandaAvailable 
                                ? 'Native Kinyarwanda TTS available'
                                : 'Using fallback language for Kinyarwanda',
                          ),
                          const SizedBox(height: 8),
                          _buildStatusRow(
                            'Current Language',
                            true,
                            _currentLanguage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Test Pronunciation Section
                  Text(
                    'Test Pronunciation',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getAccentColor(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Kinyarwanda Test
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getContainerColor(context, alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kinyarwanda Test',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ThemeHelper.getAccentColor(context),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Muraho! Mwaramutse. Urakoze cyane.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hello! Good morning. Thank you very much.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: _testKinyarwandaPronunciation,
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text('Test Kinyarwanda'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeHelper.getButtonBackgroundColor(context),
                                    foregroundColor: ThemeHelper.getButtonForegroundColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // English Test
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'English Test',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ThemeHelper.getAccentColor(context),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Hello! Good morning. Thank you very much.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: _testEnglishPronunciation,
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text('Test English'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeHelper.getButtonBackgroundColor(context),
                                    foregroundColor: ThemeHelper.getButtonForegroundColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Instructions Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pronunciation Tips',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ThemeHelper.getAccentColor(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTipItem(
                            'If Kinyarwanda TTS is not available on your device, the app will use the best available language.',
                          ),
                          _buildTipItem(
                            'For the most authentic pronunciation, ensure your device has Kinyarwanda language support installed.',
                          ),
                          _buildTipItem(
                            'The app includes phonetic guides to help you learn correct pronunciation even without native TTS.',
                          ),
                          _buildTipItem(
                            'Listen carefully to the audio and try to repeat each word several times.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusRow(String label, bool isGood, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isGood ? Icons.check_circle : Icons.warning,
          color: isGood ? Colors.green : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }
}
