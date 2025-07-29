import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import '../services/lesson_service.dart';
import '../services/content_seeder.dart';
import '../providers/auth_provider.dart';
import '../components/lesson_viewer.dart';

class EnhancedLessonsScreen extends StatefulWidget {
  const EnhancedLessonsScreen({super.key});

  @override
  State<EnhancedLessonsScreen> createState() => _EnhancedLessonsScreenState();
}

class _EnhancedLessonsScreenState extends State<EnhancedLessonsScreen> {
  List<LessonModel> lessons = [];
  Map<String, List<ProgressModel>> userProgress = {};
  bool isLoading = true;
  String selectedCategory = 'All';
  String selectedLevel = 'All';

  final List<String> categories = [
    'All', 'greetings', 'vocabulary', 'numbers', 'family', 'conversation'
  ];
  
  final List<String> levels = [
    'All', 'Beginner', 'Intermediate', 'Advanced'
  ];

  @override
  void initState() {
    super.initState();
    _initializeContent();
  }

  Future<void> _initializeContent() async {
    try {
      // Seed content if this is the first time
      await ContentSeeder.seedInitialContent();
      
      // Load lessons and user progress
      await _loadLessons();
      await _loadUserProgress();
    } catch (e) {
      print('Error initializing content: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadLessons() async {
    try {
      List<LessonModel> allLessons = await LessonService.getAllLessons();
      setState(() {
        lessons = allLessons;
      });
    } catch (e) {
      print('Error loading lessons: $e');
    }
  }

  Future<void> _loadUserProgress() async {
    try {
      for (LessonModel lesson in lessons) {
        List<ProgressModel> progress = await LessonService.getUserLessonProgress(lesson.id);
        userProgress[lesson.id] = progress;
      }
      setState(() {});
    } catch (e) {
      print('Error loading user progress: $e');
    }
  }

  List<LessonModel> get filteredLessons {
    return lessons.where((lesson) {
      bool categoryMatch = selectedCategory == 'All' || lesson.category == selectedCategory;
      bool levelMatch = selectedLevel == 'All' || lesson.level == selectedLevel;
      return categoryMatch && levelMatch;
    }).toList();
  }

  double _getLessonProgress(String lessonId) {
    if (!userProgress.containsKey(lessonId)) return 0.0;
    
    List<ProgressModel> progress = userProgress[lessonId]!;
    if (progress.isEmpty) return 0.0;
    
    double totalProgress = progress.fold(0.0, (sum, p) => sum + p.completionPercentage);
    return (totalProgress / progress.length).clamp(0.0, 100.0);
  }

  bool _isLessonCompleted(String lessonId) {
    return _getLessonProgress(lessonId) >= 100.0;
  }

  Future<void> _openLesson(LessonModel lesson) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    // Check if lesson is unlocked
    bool isUnlocked = await LessonService.isLessonUnlocked(lesson.id, lesson.order);
    if (!isUnlocked) {
      _showLessonLockedDialog(lesson);
      return;
    }

    // Load lesson sections
    List<SectionModel> sections = await LessonService.getLessonSections(lesson.id);
    
    if (sections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This lesson is not yet available')),
      );
      return;
    }

    // Navigate to lesson viewer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonViewer(
          lesson: lesson,
          sections: sections,
          onSectionComplete: (sectionId, progress, score) {
            _onSectionComplete(lesson.id, sectionId, progress, score);
          },
        ),
      ),
    );
  }

  void _onSectionComplete(String lessonId, String sectionId, double progress, int score) async {
    await LessonService.saveSectionProgress(
      lessonId: lessonId,
      sectionId: sectionId,
      completionPercentage: progress,
      score: score,
    );
    
    // Reload progress
    _loadUserProgress();
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please log in to access lessons and track your progress.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/auth');
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _showLessonLockedDialog(LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🔒 Lesson Locked'),
          content: Text(
            'Complete the previous lesson to unlock "${lesson.title}". Lessons must be completed in order.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header with filters
          Container(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 32 : 24,
              MediaQuery.of(context).padding.top + 16,
              isTablet ? 32 : 24,
              isTablet ? 24 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [theme.colorScheme.surface, theme.colorScheme.surface]
                    : [AppTheme.primaryOrange, AppTheme.primaryOrange.withValues(alpha: 0.8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? theme.colorScheme.onSurface : Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Kinyarwanda Lessons',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? theme.colorScheme.onSurface : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 20 : 16),
                Text(
                  'Choose a lesson to start your learning journey',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: isDark 
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: isTablet ? 24 : 16),
                
                // Filter options
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category filter
                      Container(
                        margin: EdgeInsets.only(right: isTablet ? 16 : 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.toLowerCase() == 'all' 
                                    ? 'All Categories' 
                                    : category.split('_').map((word) => 
                                        word[0].toUpperCase() + word.substring(1)
                                      ).join(' '),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                            dropdownColor: theme.cardColor,
                            style: TextStyle(
                              color: isDark ? theme.colorScheme.onSurface : Colors.white,
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: isDark ? theme.colorScheme.onSurface : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      // Level filter
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLevel,
                          items: levels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(
                                level == 'All' ? 'All Levels' : level,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value!;
                            });
                          },
                          dropdownColor: theme.cardColor,
                          style: TextStyle(
                            color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: isDark ? theme.colorScheme.onSurface : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lessons list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLessons.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: isTablet ? 80 : 64,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            Text(
                              'No lessons found',
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _loadLessons();
                          await _loadUserProgress();
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.all(isTablet ? 24 : 16),
                          itemCount: filteredLessons.length,
                          itemBuilder: (context, index) {
                            return _buildLessonCard(filteredLessons[index], isTablet, theme);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(LessonModel lesson, bool isTablet, ThemeData theme) {
    double progress = _getLessonProgress(lesson.id);
    bool isCompleted = _isLessonCompleted(lesson.id);
    bool isLocked = lesson.order > 1; // Will be properly checked in _openLesson

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              color: isCompleted 
                ? Colors.green.withValues(alpha: 0.5)
                : theme.dividerColor,
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => _openLesson(lesson),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Lesson number and status
                      Container(
                        width: isTablet ? 50 : 40,
                        height: isTablet ? 50 : 40,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green
                              : isLocked
                                  ? Colors.grey
                                  : AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: isTablet ? 24 : 20,
                                )
                              : isLocked
                                  ? Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: isTablet ? 20 : 16,
                                    )
                                  : Text(
                                      '${lesson.order}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                        ),
                      ),
                      
                      SizedBox(width: isTablet ? 16 : 12),
                      
                      // Lesson info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                            ),
                            SizedBox(height: isTablet ? 6 : 4),
                            Text(
                              lesson.description,
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Level badge and duration
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 12 : 8,
                              vertical: isTablet ? 6 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(lesson.level).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                            ),
                            child: Text(
                              lesson.level,
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w600,
                                color: _getLevelColor(lesson.level),
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 8 : 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: isTablet ? 16 : 14,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              SizedBox(width: isTablet ? 4 : 2),
                              Text(
                                '${lesson.estimatedDuration}min',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  if (progress > 0) ...[
                    SizedBox(height: isTablet ? 16 : 12),
                    
                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            Text(
                              '${progress.round()}%',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: isCompleted ? Colors.green : AppTheme.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 8 : 6),
                        LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: theme.dividerColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : AppTheme.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (lesson.objectives.isNotEmpty) ...[
                    SizedBox(height: isTablet ? 16 : 12),
                    Text(
                      'Learning objectives:',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 6),
                    ...lesson.objectives.take(2).map((objective) => Padding(
                      padding: EdgeInsets.only(bottom: isTablet ? 4 : 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              objective,
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    if (lesson.objectives.length > 2)
                      Text(
                        '+ ${lesson.objectives.length - 2} more...',
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
