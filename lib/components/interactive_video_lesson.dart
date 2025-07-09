import 'package:flutter/material.dart';
import '../services/kinyarwanda_tts_service.dart';

class InteractiveVideoLesson extends StatefulWidget {
  final String lessonTitle;
  final List<VideoSlide> slides;
  final VoidCallback? onCompleted;

  const InteractiveVideoLesson({
    super.key,
    required this.lessonTitle,
    required this.slides,
    this.onCompleted,
  });

  @override
  State<InteractiveVideoLesson> createState() => _InteractiveVideoLessonState();
}

class _InteractiveVideoLessonState extends State<InteractiveVideoLesson> {
  late KinyarwandaTTSService _ttsService;
  int _currentSlideIndex = 0;
  bool _isPlaying = false;
  bool _isAutoPlay = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _ttsService = KinyarwandaTTSService();
    await _ttsService.initialize();
  }

  Future<void> _speakText(String text, {bool isKinyarwanda = false}) async {
    setState(() {
      _isPlaying = true;
    });
    
    await _ttsService.speak(text, isKinyarwanda: isKinyarwanda);
    
    setState(() {
      _isPlaying = false;
    });
  }

  void _nextSlide() {
    if (_currentSlideIndex < widget.slides.length - 1) {
      setState(() {
        _currentSlideIndex++;
      });
      if (_isAutoPlay) {
        final currentSlide = widget.slides[_currentSlideIndex];
        final textToSpeak = currentSlide.kinyarwandaText ?? currentSlide.text;
        final isKinyarwanda = currentSlide.kinyarwandaText != null;
        _speakText(textToSpeak, isKinyarwanda: isKinyarwanda);
      }
    } else {
      widget.onCompleted?.call();
    }
  }

  void _previousSlide() {
    if (_currentSlideIndex > 0) {
      setState(() {
        _currentSlideIndex--;
      });
      if (_isAutoPlay) {
        final currentSlide = widget.slides[_currentSlideIndex];
        final textToSpeak = currentSlide.kinyarwandaText ?? currentSlide.text;
        final isKinyarwanda = currentSlide.kinyarwandaText != null;
        _speakText(textToSpeak, isKinyarwanda: isKinyarwanda);
      }
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = widget.slides[_currentSlideIndex];
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                currentSlide.backgroundColor ?? theme.primaryColor,
                (currentSlide.backgroundColor ?? theme.primaryColor).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPatternPainter(),
                ),
              ),
              
              // Main content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.lessonTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentSlideIndex + 1} / ${widget.slides.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Main content area
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Kinyarwanda text
                          if (currentSlide.kinyarwandaText != null)
                            Text(
                              currentSlide.kinyarwandaText!,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          
                          const SizedBox(height: 16),
                          
                          // Phonetic pronunciation
                          if (currentSlide.phoneticText != null)
                            Text(
                              currentSlide.phoneticText!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          
                          const SizedBox(height: 24),
                          
                          // English translation
                          Text(
                            currentSlide.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Audio button
                          ElevatedButton.icon(
                            onPressed: () {
                              final textToSpeak = currentSlide.kinyarwandaText ?? currentSlide.text;
                              final isKinyarwanda = currentSlide.kinyarwandaText != null;
                              _speakText(textToSpeak, isKinyarwanda: isKinyarwanda);
                            },
                            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                            label: Text(_isPlaying ? 'Stop' : 'Listen'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Progress bar
                    LinearProgressIndicator(
                      value: (_currentSlideIndex + 1) / widget.slides.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Navigation controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _currentSlideIndex > 0 ? _previousSlide : null,
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          iconSize: 32,
                        ),
                        
                        // Auto-play toggle
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isAutoPlay = !_isAutoPlay;
                            });
                          },
                          icon: Icon(
                            _isAutoPlay ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 32,
                        ),
                        
                        IconButton(
                          onPressed: _nextSlide,
                          icon: const Icon(Icons.arrow_forward, color: Colors.white),
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoSlide {
  final String text;
  final String? kinyarwandaText;
  final String? phoneticText;
  final Color? backgroundColor;

  VideoSlide({
    required this.text,
    this.kinyarwandaText,
    this.phoneticText,
    this.backgroundColor,
  });
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw subtle pattern
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        canvas.drawCircle(
          Offset(
            (i * size.width / 4) + (size.width / 8),
            (j * size.height / 4) + (size.height / 8),
          ),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
