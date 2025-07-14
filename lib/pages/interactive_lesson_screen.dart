import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../components/in_app_video_player.dart';

class InteractiveLessonScreen extends StatefulWidget {
  final Lesson lesson;

  const InteractiveLessonScreen({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  State<InteractiveLessonScreen> createState() => _InteractiveLessonScreenState();
}

class _InteractiveLessonScreenState extends State<InteractiveLessonScreen> {
  int _currentQuestionIndex = 0;
  Map<String, String> _userAnswers = {};
  bool _showVideo = true;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.lesson.exercises[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showVideo ? Icons.quiz : Icons.video_library),
            onPressed: () {
              setState(() {
                _showVideo = !_showVideo;
              });
            },
            tooltip: _showVideo ? 'Show Questions' : 'Show Video',
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Section (expandable)
          if (_showVideo && widget.lesson.videoUrl != null)
            Container(
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.video_library, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Watch the lesson video first',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      InAppVideoPlayer(
                        videoUrl: widget.lesson.videoUrl!,
                        title: 'Kinyarwanda ${widget.lesson.title}',
                        subtitle: 'Interactive lesson video',
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Watch the video to learn Kinyarwanda greetings, then answer the questions below.',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Questions Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress indicator
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${widget.lesson.exercises.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) / widget.lesson.exercises.length,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ).expanded(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Question
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.question,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Answer options
                          ...exercise.options.map((option) {
                            final isSelected = _userAnswers[exercise.id!] == option;
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _userAnswers[exercise.id!] = option;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? Colors.orange : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: isSelected ? Colors.orange.shade50 : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                        color: isSelected ? Colors.orange : Colors.grey,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isSelected ? Colors.orange.shade800 : Colors.black87,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  
                  Spacer(),
                  
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentQuestionIndex > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentQuestionIndex--;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Previous'),
                          ),
                        ),
                      
                      if (_currentQuestionIndex > 0) SizedBox(width: 16),
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _userAnswers.containsKey(exercise.id!) ? () {
                            if (_currentQuestionIndex < widget.lesson.exercises.length - 1) {
                              setState(() {
                                _currentQuestionIndex++;
                              });
                            } else {
                              _showResults();
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _currentQuestionIndex < widget.lesson.exercises.length - 1 
                              ? 'Next' 
                              : 'Finish'
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResults() {
    int correctAnswers = 0;
    for (var exercise in widget.lesson.exercises) {
      if (_userAnswers[exercise.id!] == exercise.correctAnswer) {
        correctAnswers++;
      }
    }
    
    final percentage = (correctAnswers / widget.lesson.exercises.length * 100).round();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.info_outline,
              color: percentage >= 70 ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 8),
            Text('Lesson Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You got $correctAnswers out of ${widget.lesson.exercises.length} questions correct.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: percentage >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 70 ? Colors.green : Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              percentage >= 70 
                ? 'Great job! You understand Kinyarwanda greetings well.'
                : 'Good try! Consider watching the video again and practicing more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: percentage >= 70 ? Colors.green.shade700 : Colors.orange.shade700,
              ),
            ),
          ],
        ),
        actions: [
          if (percentage < 70)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _userAnswers.clear();
                  _showVideo = true;
                });
              },
              child: Text('Try Again'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}

extension ExpandedWidget on Widget {
  Widget expanded() => Expanded(child: this);
}
