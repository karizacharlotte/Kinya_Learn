import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';
import '../components/in_app_video_player.dart';
import 'kinyarwanda_greetings_lesson.dart';
import 'generic_quiz_lesson.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool isContentCompleted = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: Text(
          widget.lesson.title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lesson.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.lesson.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lesson Content
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson Content',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    widget.lesson.description,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Video Section
            if (widget.lesson.videoUrl != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: _buildVideoPlayer(),
              ),

            // Mark as Complete Button (after video)
            if (widget.lesson.videoUrl != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isContentCompleted
                        ? null
                        : () {
                            setState(() {
                              isContentCompleted = true;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isContentCompleted ? Colors.grey.shade400 : AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isContentCompleted ? Icons.check_circle : Icons.play_circle_fill,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          isContentCompleted
                              ? '✓ Video Watched'
                              : 'Mark Video as Watched',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Quiz Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.quiz,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Your Knowledge',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Take a quiz to reinforce what you learned',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isContentCompleted
                          ? () {
                              // For greetings lesson, start the interactive quiz
                              if (widget.lesson.title.toLowerCase().contains('greeting')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KinyarwandaGreetingsLesson(),
                                  ),
                                );
                              } else {
                                // For all other lessons, use the generic quiz
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenericQuizLesson(lesson: widget.lesson),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 20),
                          SizedBox(width: 8),
                          Text(
                            isContentCompleted ? 'Start Quiz' : 'Watch Video First',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Additional Action Buttons
            Column(
              children: [

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isContentCompleted
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: widget.lesson,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Final Quiz & Certificate - \$9.99'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        // Use in-app video player for all lessons
        InAppVideoPlayer(
          videoUrl: widget.lesson.videoUrl!,
          title: widget.lesson.title,
          subtitle: widget.lesson.description,
        ),
      ],
    );
  }
}