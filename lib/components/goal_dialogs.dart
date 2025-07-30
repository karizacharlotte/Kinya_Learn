import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/learning_note.dart';
import '../providers/learning_notes_provider.dart';
import '../theme/app_theme.dart';

class GoalDialogs {
  static void showCreateGoalDialog(BuildContext context, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _GoalFormDialog(provider: provider),
    );
  }

  static void showEditGoalDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _GoalFormDialog(provider: provider, goal: goal),
    );
  }

  static void showGoalDetailDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _GoalDetailDialog(goal: goal, provider: provider),
    );
  }

  static void showUpdateProgressDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _UpdateProgressDialog(goal: goal, provider: provider),
    );
  }

  static void confirmDeleteGoal(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Are you sure you want to delete "${goal.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteGoal(goal.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Goal deleted successfully' : 'Failed to delete goal'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _GoalFormDialog extends StatefulWidget {
  final LearningNotesProvider provider;
  final LearningGoal? goal;

  const _GoalFormDialog({required this.provider, this.goal});

  @override
  State<_GoalFormDialog> createState() => _GoalFormDialogState();
}

class _GoalFormDialogState extends State<_GoalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetValueController = TextEditingController();
  
  DateTime? _selectedTargetDate;
  GoalType _selectedGoalType = GoalType.lessons;
  bool _isLoading = false;

  bool get isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.goal!.title;
      _descriptionController.text = widget.goal!.description;
      _targetValueController.text = widget.goal!.targetValue.toString();
      _selectedTargetDate = widget.goal!.targetDate;
      _selectedGoalType = widget.goal!.type;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Goal' : 'Create Goal'),
      content: SizedBox(
        width: isTablet ? 500 : double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<GoalType>(
                  value: _selectedGoalType,
                  decoration: const InputDecoration(
                    labelText: 'Goal Type *',
                    border: OutlineInputBorder(),
                  ),
                  items: GoalType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_goalTypeToString(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGoalType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetValueController,
                  decoration: InputDecoration(
                    labelText: 'Target Value *',
                    border: const OutlineInputBorder(),
                    suffixText: _getGoalTypeUnit(_selectedGoalType),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a target value';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectTargetDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Target Date *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedTargetDate != null
                          ? DateFormat('MMM d, y').format(_selectedTargetDate!)
                          : 'Select target date',
                      style: TextStyle(
                        color: _selectedTargetDate != null 
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tip: ${_getGoalTypeTip(_selectedGoalType)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveGoal,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryOrange,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedTargetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() => _selectedTargetDate = date);
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate() || _selectedTargetDate == null) {
      if (_selectedTargetDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a target date'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final targetValue = int.parse(_targetValueController.text);

      String? result;
      if (isEditing) {
        final success = await widget.provider.updateGoal(
          goalId: widget.goal!.id,
          title: title,
          description: description,
          targetDate: _selectedTargetDate!,
          type: _selectedGoalType,
          targetValue: targetValue,
        );
        result = success ? 'Goal updated successfully' : 'Failed to update goal';
      } else {
        final goalId = await widget.provider.createGoal(
          title: title,
          description: description,
          targetDate: _selectedTargetDate!,
          type: _selectedGoalType,
          targetValue: targetValue,
        );
        result = goalId != null ? 'Goal created successfully' : 'Failed to create goal';
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: result.contains('success') ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _goalTypeToString(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'Complete Lessons';
      case GoalType.xp:
        return 'Earn XP Points';
      case GoalType.streak:
        return 'Daily Streak';
      case GoalType.vocabulary:
        return 'Learn Vocabulary';
      case GoalType.accuracy:
        return 'Maintain Accuracy';
      case GoalType.time:
        return 'Study Time (minutes)';
    }
  }

  String _getGoalTypeUnit(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'lessons';
      case GoalType.xp:
        return 'XP';
      case GoalType.streak:
        return 'days';
      case GoalType.vocabulary:
        return 'words';
      case GoalType.accuracy:
        return '%';
      case GoalType.time:
        return 'min';
    }
  }

  String _getGoalTypeTip(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'Set a realistic number of lessons to complete';
      case GoalType.xp:
        return 'XP is earned by completing lessons and scoring well';
      case GoalType.streak:
        return 'Consecutive days of completing at least one lesson';
      case GoalType.vocabulary:
        return 'Number of new vocabulary words to learn';
      case GoalType.accuracy:
        return 'Average accuracy percentage to maintain';
      case GoalType.time:
        return 'Total study time in minutes';
    }
  }
}

class _UpdateProgressDialog extends StatefulWidget {
  final LearningGoal goal;
  final LearningNotesProvider provider;

  const _UpdateProgressDialog({required this.goal, required this.provider});

  @override
  State<_UpdateProgressDialog> createState() => _UpdateProgressDialogState();
}

class _UpdateProgressDialogState extends State<_UpdateProgressDialog> {
  final _progressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _progressController.text = widget.goal.currentProgress.toString();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProgress = widget.goal.currentProgress;
    final targetValue = widget.goal.targetValue;
    final progressPercentage = widget.goal.progressPercentage;
    
    return AlertDialog(
      title: Text('Update Progress - ${widget.goal.title}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Progress: $currentProgress / $targetValue (${progressPercentage.toInt()}%)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _progressController,
            decoration: InputDecoration(
              labelText: 'New Progress Value *',
              border: const OutlineInputBorder(),
              suffixText: _getGoalTypeUnit(widget.goal.type),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the new progress value (must be between $currentProgress and $targetValue)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('+1'),
              onPressed: _isLoading ? null : () => _incrementProgress(1),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('+5'),
              onPressed: _isLoading ? null : () => _incrementProgress(5),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateProgress,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryOrange,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }

  void _incrementProgress(int increment) {
    final currentValue = int.tryParse(_progressController.text) ?? widget.goal.currentProgress;
    final newValue = (currentValue + increment).clamp(0, widget.goal.targetValue);
    _progressController.text = newValue.toString();
  }

  Future<void> _updateProgress() async {
    final newProgressStr = _progressController.text.trim();
    if (newProgressStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a progress value'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newProgress = int.tryParse(newProgressStr);
    if (newProgress == null || newProgress < 0 || newProgress > widget.goal.targetValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress must be between 0 and ${widget.goal.targetValue}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await widget.provider.updateGoalProgress(
        goalId: widget.goal.id,
        newProgress: newProgress,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Progress updated successfully' : 'Failed to update progress'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getGoalTypeUnit(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'lessons';
      case GoalType.xp:
        return 'XP';
      case GoalType.streak:
        return 'days';
      case GoalType.vocabulary:
        return 'words';
      case GoalType.accuracy:
        return '%';
      case GoalType.time:
        return 'min';
    }
  }
}

class _GoalDetailDialog extends StatelessWidget {
  final LearningGoal goal;
  final LearningNotesProvider provider;

  const _GoalDetailDialog({required this.goal, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    return AlertDialog(
      title: Text(
        goal.title,
        style: TextStyle(
          decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      content: SizedBox(
        width: isTablet ? 500 : double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (goal.description.isNotEmpty) ...[
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(goal.description),
                ),
                const SizedBox(height: 16),
              ],
              _buildProgressSection(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Goal Type',
                      _goalTypeToString(goal.type),
                      Icons.flag,
                      AppTheme.primaryOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      'Target',
                      '${goal.targetValue} ${_getGoalTypeUnit(goal.type)}',
                      Icons.track_changes,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                'Target Date',
                DateFormat('EEEE, MMM d, y').format(goal.targetDate),
                Icons.calendar_today,
                goal.isOverdue && !goal.isCompleted ? Colors.red : Colors.green,
              ),
              if (!goal.isCompleted) ...[
                const SizedBox(height: 8),
                _buildDeadlineStatus(),
              ],
              const SizedBox(height: 16),
              _buildInfoCard(
                'Created',
                DateFormat('MMM d, y \'at\' h:mm a').format(goal.createdAt),
                Icons.create,
                Colors.grey[600]!,
              ),
              if (goal.updatedAt != goal.createdAt) ...[
                const SizedBox(height: 8),
                _buildInfoCard(
                  'Last Updated',
                  DateFormat('MMM d, y \'at\' h:mm a').format(goal.updatedAt),
                  Icons.update,
                  Colors.grey[600]!,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (!goal.isCompleted) ...[
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Update Progress'),
            onPressed: () {
              Navigator.pop(context);
              GoalDialogs.showUpdateProgressDialog(context, goal, provider);
            },
          ),
        ],
        TextButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          onPressed: () {
            Navigator.pop(context);
            GoalDialogs.showEditGoalDialog(context, goal, provider);
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            GoalDialogs.confirmDeleteGoal(context, goal, provider);
          },
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final progressPercentage = goal.progressPercentage;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: goal.isCompleted 
              ? [Colors.green.withValues(alpha: 0.1), Colors.green.withValues(alpha: 0.05)]
              : [AppTheme.primaryOrange.withValues(alpha: 0.1), AppTheme.primaryOrange.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: goal.isCompleted 
              ? Colors.green.withValues(alpha: 0.3)
              : AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                goal.isCompleted ? Icons.check_circle : Icons.trending_up,
                color: goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                'Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${progressPercentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
            ),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${goal.currentProgress} / ${goal.targetValue} ${_getGoalTypeUnit(goal.type)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (goal.isCompleted) ...[
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Completed!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ] else ...[
                Text(
                  '${goal.targetValue - goal.currentProgress} remaining',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineStatus() {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (goal.isOverdue) {
      final daysOverdue = DateTime.now().difference(goal.targetDate).inDays;
      statusText = 'Overdue by $daysOverdue day${daysOverdue == 1 ? '' : 's'}';
      statusColor = Colors.red;
      statusIcon = Icons.warning;
    } else {
      final daysRemaining = goal.daysRemaining;
      if (daysRemaining <= 1) {
        statusText = 'Due tomorrow';
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
      } else if (daysRemaining <= 7) {
        statusText = '$daysRemaining days remaining';
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
      } else {
        statusText = '$daysRemaining days remaining';
        statusColor = Colors.blue;
        statusIcon = Icons.calendar_today;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _goalTypeToString(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'Complete Lessons';
      case GoalType.xp:
        return 'Earn XP Points';
      case GoalType.streak:
        return 'Daily Streak';
      case GoalType.vocabulary:
        return 'Learn Vocabulary';
      case GoalType.accuracy:
        return 'Maintain Accuracy';
      case GoalType.time:
        return 'Study Time';
    }
  }

  String _getGoalTypeUnit(GoalType type) {
    switch (type) {
      case GoalType.lessons:
        return 'lessons';
      case GoalType.xp:
        return 'XP';
      case GoalType.streak:
        return 'days';
      case GoalType.vocabulary:
        return 'words';
      case GoalType.accuracy:
        return '%';
      case GoalType.time:
        return 'min';
    }
  }
}
