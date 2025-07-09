import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../theme/theme_helper.dart';
import '../components/interactive_video_lesson.dart';
import '../utils/responsive_helper.dart';
import '../services/kinyarwanda_tts_service.dart';
import 'enhanced_practice_quiz_screen.dart';

class EnhancedLessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const EnhancedLessonDetailScreen({super.key, required this.lesson});

  @override
  State<EnhancedLessonDetailScreen> createState() => _EnhancedLessonDetailScreenState();
}

class _EnhancedLessonDetailScreenState extends State<EnhancedLessonDetailScreen> {
  bool isVideoCompleted = false;
  bool isContentCompleted = false;
  int currentSection = 0; // 0: Video, 1: Content, 2: Quiz
  late KinyarwandaTTSService _ttsService;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _ttsService = KinyarwandaTTSService();
    await _ttsService.initialize();
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeHelper.getAppBarBackgroundColor(context),
        elevation: 0,
        title: Text(
          widget.lesson.title,
          style: TextStyle(
            color: ThemeHelper.getAppBarForegroundColor(context),
            fontSize: ResponsiveHelper.getResponsiveTitleFontSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: ThemeHelper.getAppBarForegroundColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border,
                color: ThemeHelper.getAppBarForegroundColor(context)),
            onPressed: () {
              // Add bookmark functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentSection + 1) / 3,
            backgroundColor: theme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          
          // Section tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSectionTab(
                  context,
                  'Video',
                  Icons.play_circle_outline,
                  0,
                  isVideoCompleted,
                ),
                _buildSectionTab(
                  context,
                  'Content',
                  Icons.menu_book,
                  1,
                  isContentCompleted,
                ),
                _buildSectionTab(
                  context,
                  'Quiz',
                  Icons.quiz,
                  2,
                  false,
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
              child: _buildCurrentSection(context, isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTab(
    BuildContext context,
    String title,
    IconData icon,
    int index,
    bool isCompleted,
  ) {
    final theme = Theme.of(context);
    final isActive = currentSection == index;
    final isAccessible = index == 0 || (index == 1 && isVideoCompleted) || (index == 2 && isContentCompleted);

    return Expanded(
      child: GestureDetector(
        onTap: isAccessible ? () => setState(() => currentSection = index) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? theme.primaryColor
                : isAccessible
                    ? theme.colorScheme.surface
                    : theme.disabledColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isActive
                  ? theme.primaryColor
                  : theme.dividerColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isCompleted ? Icons.check_circle : icon,
                color: isActive
                    ? Colors.white
                    : isAccessible
                        ? theme.colorScheme.onSurface
                        : theme.disabledColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : isAccessible
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSection(BuildContext context, bool isDarkMode) {
    switch (currentSection) {
      case 0:
        return _buildVideoSection(context, isDarkMode);
      case 1:
        return _buildContentSection(context, isDarkMode);
      case 2:
        return _buildQuizSection(context, isDarkMode);
      default:
        return _buildVideoSection(context, isDarkMode);
    }
  }

  Widget _buildVideoSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interactive video lesson
        InteractiveVideoLesson(
          lessonTitle: widget.lesson.title,
          slides: _getVideoSlides(),
          onCompleted: () {
            setState(() {
              isVideoCompleted = true;
            });
          },
        ),
        
        const SizedBox(height: 24),
        
        // Video description
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About this lesson',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.lesson.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              if (isVideoCompleted)
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.success),
                    const SizedBox(width: 8),
                    const Text(
                      'Video completed!',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isVideoCompleted = true;
                    });
                  },
                  child: const Text('Mark Video as Watched'),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Next section button
        if (isVideoCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => currentSection = 1),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue to Lesson Content'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lesson content
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lesson Content',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Key vocabulary
              if (widget.lesson.id == 'basics1')
                _buildGreetingsContent(context),
              
              const SizedBox(height: 24),
              
              // Complete button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isContentCompleted
                      ? null
                      : () {
                          setState(() {
                            isContentCompleted = true;
                          });
                        },
                  child: Text(
                    isContentCompleted
                        ? '✓ Content Completed'
                        : 'Mark Content as Complete',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Next section button
        if (isContentCompleted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => currentSection = 2),
              icon: const Icon(Icons.quiz),
              label: const Text('Take Practice Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuizSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Practice Quiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Quiz preview
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.quiz, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.lesson.exercises.length} Questions',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Test your knowledge of the lesson material with interactive questions.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnhancedPracticeQuizScreen(lesson: widget.lesson),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Quiz'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Vocabulary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Vocabulary cards
        _buildVocabularyCard('Muraho', 'Hello', 'moo-RAH-ho'),
        _buildVocabularyCard('Mwaramutse', 'Good morning', 'mwah-rah-MOOT-say'),
        _buildVocabularyCard('Urakoze', 'Thank you', 'oo-rah-KOH-zay'),
        _buildVocabularyCard('Muriho', 'Goodbye', 'moo-REE-ho'),
        _buildVocabularyCard('Amahoro', 'Peace', 'ah-mah-HOH-ro'),
      ],
    );
  }

  Widget _buildVocabularyCard(String kinyarwanda, String english, String phonetic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kinyarwanda,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  english,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phonetic,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _ttsService.speak(kinyarwanda, isKinyarwanda: true);
            },
            icon: const Icon(Icons.volume_up),
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  List<VideoSlide> _getVideoSlides() {
    if (widget.lesson.id == 'basics1') {
      return [
        VideoSlide(
          text: 'Welcome to Kinyarwanda Basic Greetings',
          backgroundColor: AppTheme.primaryOrange,
        ),
        VideoSlide(
          text: 'Hello',
          kinyarwandaText: 'Muraho',
          phoneticText: 'moo-RAH-ho',
          backgroundColor: AppTheme.primaryBlue,
        ),
        VideoSlide(
          text: 'Good morning',
          kinyarwandaText: 'Mwaramutse',
          phoneticText: 'mwah-rah-MOOT-say',
          backgroundColor: AppTheme.primaryOrange,
        ),
        VideoSlide(
          text: 'Thank you',
          kinyarwandaText: 'Urakoze',
          phoneticText: 'oo-rah-KOH-zay',
          backgroundColor: AppTheme.primaryBlue,
        ),
        VideoSlide(
          text: 'Goodbye',
          kinyarwandaText: 'Muriho',
          phoneticText: 'moo-REE-ho',
          backgroundColor: AppTheme.primaryOrange,
        ),
        VideoSlide(
          text: 'Peace',
          kinyarwandaText: 'Amahoro',
          phoneticText: 'ah-mah-HOH-ro',
          backgroundColor: AppTheme.primaryBlue,
        ),
      ];
    }
    
    return [
      VideoSlide(
        text: 'Lesson content will be here',
        backgroundColor: AppTheme.primaryOrange,
      ),
    ];
  }
}
