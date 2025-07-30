import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class LessonViewer extends StatefulWidget {
  final LessonModel lesson;
  final List<SectionModel> sections;
  final Function(String sectionId, double progress, int score) onSectionComplete;

  const LessonViewer({
    super.key,
    required this.lesson,
    required this.sections,
    required this.onSectionComplete,
  });

  @override
  State<LessonViewer> createState() => _LessonViewerState();
}

class _LessonViewerState extends State<LessonViewer> {
  int currentSectionIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  String? currentPlayingAudio;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _nextSection() {
    if (currentSectionIndex < widget.sections.length - 1) {
      setState(() {
        currentSectionIndex++;
      });
    } else {
      // Lesson complete
      _completeLessonDialog();
    }
  }

  void _previousSection() {
    if (currentSectionIndex > 0) {
      setState(() {
        currentSectionIndex--;
      });
    }
  }

  void _completeLessonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Lesson Complete!'),
          content: Text('Great job completing "${widget.lesson.title}"!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to lessons list
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      if (currentPlayingAudio == audioUrl && isAudioPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isAudioPlaying = false;
        });
      } else {
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          isAudioPlaying = true;
          currentPlayingAudio = audioUrl;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not play audio')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    if (widget.sections.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lesson.title)),
        body: const Center(child: Text('No sections available for this lesson')),
      );
    }

    final currentSection = widget.sections[currentSectionIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: isDark ? theme.colorScheme.surface : AppTheme.primaryOrange,
        foregroundColor: isDark ? theme.colorScheme.onSurface : Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : AppTheme.primaryOrange,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Section ${currentSectionIndex + 1} of ${widget.sections.length}',
                      style: TextStyle(
                        color: isDark ? theme.colorScheme.onSurface : Colors.white,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Text(
                      '${((currentSectionIndex + 1) / widget.sections.length * 100).round()}%',
                      style: TextStyle(
                        color: isDark ? theme.colorScheme.onSurface : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 12 : 8),
                LinearProgressIndicator(
                  value: (currentSectionIndex + 1) / widget.sections.length,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppTheme.primaryOrange : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Section content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSection.title,
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.headlineSmall?.color,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  
                  // Render section content based on type
                  _buildSectionContent(currentSection, isTablet, theme),
                ],
              ),
            ),
          ),

          // Navigation controls
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                top: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentSectionIndex > 0 ? _previousSection : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 12,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: isTablet ? 16 : 12),
                
                // Next/Complete button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _nextSection,
                    icon: Icon(
                      currentSectionIndex == widget.sections.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      currentSectionIndex == widget.sections.length - 1
                          ? 'Complete'
                          : 'Next',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(SectionModel section, bool isTablet, ThemeData theme) {
    switch (section.type) {
      case 'text':
        return _buildTextSection(section.content, isTablet, theme);
      case 'vocabulary':
        return _buildVocabularySection(section.content, isTablet, theme);
      case 'dialogue':
        return _buildDialogueSection(section.content, isTablet, theme);
      case 'audio_practice':
        return _buildAudioPracticeSection(section.content, isTablet, theme);
      default:
        return Text(
          'Unknown section type: ${section.type}',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        );
    }
  }

  Widget _buildTextSection(dynamic content, bool isTablet, ThemeData theme) {
    Map<String, dynamic> textContent = content as Map<String, dynamic>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textContent['text'] ?? '',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            height: 1.6,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        
        if (textContent['culturalNote'] != null) ...[
          SizedBox(height: isTablet ? 24 : 16),
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryOrange,
                      size: isTablet ? 24 : 20,
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'Cultural Note',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 12 : 8),
                Text(
                  textContent['culturalNote'],
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVocabularySection(dynamic content, bool isTablet, ThemeData theme) {
    Map<String, dynamic> vocabContent = content as Map<String, dynamic>;
    List<dynamic> vocabulary = vocabContent['vocabulary'] ?? [];

    return Column(
      children: vocabulary.map<Widget>((vocabItem) {
        VocabularyItem item = VocabularyItem.fromMap(vocabItem);
        
        return Container(
          margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.kinyarwandaWord,
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 4),
                        Text(
                          item.englishTranslation,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (item.pronunciation != null) ...[
                          SizedBox(height: isTablet ? 8 : 4),
                          Text(
                            'Pronunciation: ${item.pronunciation}',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              fontStyle: FontStyle.italic,
                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  if (item.audioUrl != null)
                    IconButton(
                      onPressed: () => _playAudio(item.audioUrl!),
                      icon: Icon(
                        isAudioPlaying && currentPlayingAudio == item.audioUrl
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: isTablet ? 40 : 32,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDialogueSection(dynamic content, bool isTablet, ThemeData theme) {
    Map<String, dynamic> dialogueContent = content as Map<String, dynamic>;
    List<dynamic> dialogue = dialogueContent['dialogue'] ?? [];
    String? culturalContext = dialogueContent['culturalContext'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...dialogue.map<Widget>((dialogueItem) {
          DialogueItem item = DialogueItem.fromMap(dialogueItem);
          
          return Container(
            margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: isTablet ? 60 : 50,
                  height: isTablet ? 60 : 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      item.speaker[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.speaker,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 4),
                        Text(
                          item.kinyarwandaLine,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: isTablet ? 6 : 4),
                        Text(
                          item.englishTranslation,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                          ),
                        ),
                        if (item.audioUrl != null) ...[
                          SizedBox(height: isTablet ? 8 : 6),
                          IconButton(
                            onPressed: () => _playAudio(item.audioUrl!),
                            icon: Icon(
                              isAudioPlaying && currentPlayingAudio == item.audioUrl
                                  ? Icons.pause_circle_outlined
                                  : Icons.play_circle_outlined,
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        if (culturalContext != null) ...[
          SizedBox(height: isTablet ? 24 : 16),
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.blue,
                      size: isTablet ? 24 : 20,
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'Cultural Context',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 12 : 8),
                Text(
                  culturalContext,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioPracticeSection(dynamic content, bool isTablet, ThemeData theme) {
    Map<String, dynamic> practiceContent = content as Map<String, dynamic>;
    List<dynamic> phrases = practiceContent['phrases'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Listen and repeat the following phrases:',
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: isTablet ? 20 : 16),
        
        ...phrases.map<Widget>((phraseItem) {
          Map<String, dynamic> phrase = phraseItem as Map<String, dynamic>;
          
          return Container(
            margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phrase['phraseKinyarwanda'] ?? '',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 4),
                          Text(
                            phrase['phraseEnglish'] ?? '',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (phrase['audioUrl'] != null)
                      IconButton(
                        onPressed: () => _playAudio(phrase['audioUrl']),
                        icon: Icon(
                          isAudioPlaying && currentPlayingAudio == phrase['audioUrl']
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: isTablet ? 40 : 32,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                  ],
                ),
                
                if (phrase['tips'] != null) ...[
                  SizedBox(height: isTablet ? 12 : 8),
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: Colors.green,
                          size: isTablet ? 20 : 16,
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                        Expanded(
                          child: Text(
                            phrase['tips'],
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
