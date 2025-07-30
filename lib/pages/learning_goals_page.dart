import 'package:flutter/material.dart';
import '../services/student_data_service.dart';

class LearningGoalsPage extends StatefulWidget {
  const LearningGoalsPage({super.key});

  @override
  State<LearningGoalsPage> createState() => _LearningGoalsPageState();
}

class _LearningGoalsPageState extends State<LearningGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  
  int _dailyLessons = 3;
  int _weeklyGoal = 21;
  int _monthlyGoal = 90;
  String _targetLevel = 'Intermediate';
  List<String> _focusAreas = ['vocabulary', 'pronunciation'];
  DateTime? _targetDate;
  
  bool _isLoading = false;
  Map<String, dynamic> _todayProgress = {};

  final List<String> _availableAreas = [
    'vocabulary',
    'pronunciation', 
    'grammar',
    'culture',
    'conversation',
    'listening',
    'reading',
    'writing'
  ];

  final List<String> _levels = [
    'Beginner',
    'Elementary', 
    'Intermediate',
    'Advanced',
    'Native'
  ];

  @override
  void initState() {
    super.initState();
    _loadGoals();
    _loadTodayProgress();
  }

  Future<void> _loadGoals() async {
    setState(() => _isLoading = true);
    
    try {
      final goals = await StudentDataService.getLearningGoals();
      if (goals != null && mounted) {
        setState(() {
          _dailyLessons = goals['dailyLessons'] ?? 3;
          _weeklyGoal = goals['weeklyGoal'] ?? 21;
          _monthlyGoal = goals['monthlyGoal'] ?? 90;
          _targetLevel = goals['targetLevel'] ?? 'Intermediate';
          _focusAreas = List<String>.from(goals['focusAreas'] ?? ['vocabulary', 'pronunciation']);
          if (goals['targetDate'] != null) {
            _targetDate = goals['targetDate'].toDate();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading goals: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadTodayProgress() async {
    try {
      final progress = await StudentDataService.getDailyProgress();
      if (mounted) {
        setState(() => _todayProgress = progress);
      }
    } catch (e) {
      print('Error loading today progress: $e');
    }
  }

  Future<void> _saveGoals() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final success = await StudentDataService.setLearningGoals(
        dailyLessons: _dailyLessons,
        weeklyGoal: _weeklyGoal,
        monthlyGoal: _monthlyGoal,
        targetLevel: _targetLevel,
        focusAreas: _focusAreas,
        targetDate: _targetDate,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Learning goals updated successfully!')),
        );
        _loadGoals();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update goals')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Goals'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveGoals,
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Progress Card
                  if (_todayProgress.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_todayProgress['completedToday']} / ${_todayProgress['dailyGoal']} lessons',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: (_todayProgress['progress'] as double).clamp(0.0, 1.0),
                                        backgroundColor: Colors.grey[300],
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _todayProgress['goalAchieved'] == true
                                            ? Colors.green
                                            : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_todayProgress['goalAchieved'] == true)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 32),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Daily Goals Section
                  const Text(
                    'Daily Goals',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.today, color: Colors.orange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Daily Lessons: $_dailyLessons',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _dailyLessons.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: '$_dailyLessons lessons',
                            onChanged: (value) {
                              setState(() => _dailyLessons = value.round());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Weekly & Monthly Goals
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_view_week, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Weekly Goal: $_weeklyGoal lessons',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _weeklyGoal.toDouble(),
                            min: 7,
                            max: 70,
                            divisions: 9,
                            label: '$_weeklyGoal lessons',
                            onChanged: (value) {
                              setState(() => _weeklyGoal = value.round());
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: Colors.green),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Monthly Goal: $_monthlyGoal lessons',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _monthlyGoal.toDouble(),
                            min: 30,
                            max: 300,
                            divisions: 27,
                            label: '$_monthlyGoal lessons',
                            onChanged: (value) {
                              setState(() => _monthlyGoal = value.round());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Target Level
                  const Text(
                    'Target Level',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: _targetLevel,
                        decoration: const InputDecoration(
                          labelText: 'Target Proficiency Level',
                          prefixIcon: Icon(Icons.trending_up),
                          border: OutlineInputBorder(),
                        ),
                        items: _levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _targetLevel = value);
                          }
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Focus Areas
                  const Text(
                    'Focus Areas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select areas you want to focus on:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _availableAreas.map((area) {
                              final isSelected = _focusAreas.contains(area);
                              return FilterChip(
                                label: Text(area.toUpperCase()),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _focusAreas.add(area);
                                    } else {
                                      _focusAreas.remove(area);
                                    }
                                  });
                                },
                                backgroundColor: Colors.grey[200],
                                selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                                checkmarkColor: Theme.of(context).primaryColor,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Target Date
                  const Text(
                    'Target Date (Optional)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.event),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _targetDate != null
                                ? 'Target: ${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}'
                                : 'No target date set',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 90)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                              );
                              if (date != null) {
                                setState(() => _targetDate = date);
                              }
                            },
                            child: Text(_targetDate != null ? 'Change' : 'Set Date'),
                          ),
                          if (_targetDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() => _targetDate = null);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }
}
