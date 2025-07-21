import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../data/language_lessons.dart';
import '../theme/app_theme.dart';

class LessonNavigation extends StatelessWidget {
  final Lesson currentLesson;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const LessonNavigation({
    Key? key,
    required this.currentLesson,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lessons = KinyarwandaLanguageLessons.getLanguageLessons();
    final currentIndex = lessons.indexWhere((lesson) => lesson.id == currentLesson.id);
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex < lessons.length - 1;
    final nextLesson = hasNext ? lessons[currentIndex + 1] : null;
    final previousLesson = hasPrevious ? lessons[currentIndex - 1] : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.navigation, color: AppTheme.primaryOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Lesson Navigation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress indicator
          Row(
            children: [
              Text(
                'Lesson ${currentIndex + 1} of ${lessons.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${((currentIndex + 1) / lessons.length * 100).round()}% Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress bar
          LinearProgressIndicator(
            value: (currentIndex + 1) / lessons.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
            minHeight: 6,
          ),
          const SizedBox(height: 20),

          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (hasPrevious)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (onPrevious != null) {
                        onPrevious!();
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          '/lesson-detail',
                          arguments: previousLesson,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Previous',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          previousLesson?.title ?? '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              
              if (hasPrevious && hasNext) const SizedBox(width: 12),
              
              // Next button
              if (hasNext)
                Expanded(
                  flex: hasPrevious ? 1 : 2,
                  child: ElevatedButton.icon(
                    onPressed: currentLesson.isCompleted
                        ? () {
                            if (onNext != null) {
                              onNext!();
                            } else {
                              // Unlock next lesson
                              nextLesson!.isUnlocked = true;
                              Navigator.pushReplacementNamed(
                                context,
                                '/lesson-detail',
                                arguments: nextLesson,
                              );
                            }
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLesson.isCompleted ? 'Next Lesson' : 'Complete Current First',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          nextLesson?.title ?? '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentLesson.isCompleted 
                          ? AppTheme.primaryOrange 
                          : Colors.grey.shade300,
                      foregroundColor: currentLesson.isCompleted 
                          ? Colors.white 
                          : Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Completion indicator
          if (!hasNext)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.celebration, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Congratulations! You\'ve completed all lessons!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
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
}
