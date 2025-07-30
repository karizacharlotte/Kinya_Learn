import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/learning_note.dart';
import '../providers/learning_notes_provider.dart';
import '../theme/app_theme.dart';

class NoteDialogs {
  static void showCreateNoteDialog(BuildContext context, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _NoteFormDialog(provider: provider),
    );
  }

  static void showEditNoteDialog(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _NoteFormDialog(provider: provider, note: note),
    );
  }

  static void showNoteDetailDialog(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _NoteDetailDialog(note: note, provider: provider),
    );
  }

  static void confirmDeleteNote(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteNote(note.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Note deleted successfully' : 'Failed to delete note'),
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

class _NoteFormDialog extends StatefulWidget {
  final LearningNotesProvider provider;
  final LearningNote? note;

  const _NoteFormDialog({required this.provider, this.note});

  @override
  State<_NoteFormDialog> createState() => _NoteFormDialogState();
}

class _NoteFormDialogState extends State<_NoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  DateTime? _selectedDeadline;
  Priority _selectedPriority = Priority.medium;
  NoteCategory _selectedCategory = NoteCategory.general;
  bool _isLoading = false;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedDeadline = widget.note!.deadline;
      _selectedPriority = widget.note!.priority;
      _selectedCategory = widget.note!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Note' : 'Create Note'),
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
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Priority>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: Priority.values.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(_priorityToString(priority)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPriority = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<NoteCategory>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: NoteCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(_categoryToString(category)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDeadline,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Deadline (Optional)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDeadline != null
                          ? DateFormat('MMM d, y').format(_selectedDeadline!)
                          : 'Select deadline',
                      style: TextStyle(
                        color: _selectedDeadline != null 
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                if (_selectedDeadline != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Deadline'),
                        onPressed: () => setState(() => _selectedDeadline = null),
                      ),
                    ],
                  ),
                ],
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
          onPressed: _isLoading ? null : _saveNote,
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

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() => _selectedDeadline = date);
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      String? result;
      if (isEditing) {
        final success = await widget.provider.updateNote(
          noteId: widget.note!.id,
          title: title,
          content: content,
          deadline: _selectedDeadline,
          priority: _selectedPriority,
          category: _selectedCategory,
        );
        result = success ? 'Note updated successfully' : 'Failed to update note';
      } else {
        final noteId = await widget.provider.createNote(
          title: title,
          content: content,
          deadline: _selectedDeadline,
          priority: _selectedPriority,
          category: _selectedCategory,
        );
        result = noteId != null ? 'Note created successfully' : 'Failed to create note';
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

  String _priorityToString(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }

  String _categoryToString(NoteCategory category) {
    switch (category) {
      case NoteCategory.general:
        return 'General';
      case NoteCategory.vocabulary:
        return 'Vocabulary';
      case NoteCategory.grammar:
        return 'Grammar';
      case NoteCategory.pronunciation:
        return 'Pronunciation';
      case NoteCategory.culture:
        return 'Culture';
      case NoteCategory.goals:
        return 'Goals';
      case NoteCategory.review:
        return 'Review';
    }
  }
}

class _NoteDetailDialog extends StatelessWidget {
  final LearningNote note;
  final LearningNotesProvider provider;

  const _NoteDetailDialog({required this.note, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              note.title,
              style: TextStyle(
                decoration: note.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              note.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: note.isCompleted ? Colors.green : Colors.grey[400],
            ),
            onPressed: () => provider.toggleNoteCompletion(note.id),
          ),
        ],
      ),
      content: SizedBox(
        width: isTablet ? 500 : double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (note.content.isNotEmpty) ...[
                Text(
                  'Content:',
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
                  child: Text(
                    note.content,
                    style: TextStyle(
                      decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Priority',
                      _priorityToString(note.priority),
                      Icons.flag,
                      _getPriorityColor(note.priority),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      'Category',
                      _categoryToString(note.category),
                      Icons.category,
                      AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (note.deadline != null) ...[
                _buildInfoCard(
                  'Deadline',
                  DateFormat('EEEE, MMM d, y').format(note.deadline!),
                  Icons.schedule,
                  note.isOverdue 
                      ? Colors.red
                      : note.isDueSoon 
                          ? Colors.orange
                          : Colors.blue,
                ),
                if (note.deadline != null && !note.isCompleted) ...[
                  const SizedBox(height: 8),
                  _buildDeadlineStatus(),
                ],
                const SizedBox(height: 16),
              ],
              _buildInfoCard(
                'Created',
                DateFormat('MMM d, y \'at\' h:mm a').format(note.createdAt),
                Icons.create,
                Colors.grey[600]!,
              ),
              if (note.updatedAt != note.createdAt) ...[
                const SizedBox(height: 8),
                _buildInfoCard(
                  'Last Updated',
                  DateFormat('MMM d, y \'at\' h:mm a').format(note.updatedAt),
                  Icons.update,
                  Colors.grey[600]!,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          onPressed: () {
            Navigator.pop(context);
            NoteDialogs.showEditNoteDialog(context, note, provider);
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            NoteDialogs.confirmDeleteNote(context, note, provider);
          },
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
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

    if (note.isOverdue) {
      final daysOverdue = DateTime.now().difference(note.deadline!).inDays;
      statusText = 'Overdue by $daysOverdue day${daysOverdue == 1 ? '' : 's'}';
      statusColor = Colors.red;
      statusIcon = Icons.warning;
    } else if (note.isDueSoon) {
      statusText = 'Due tomorrow';
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
    } else {
      final daysUntil = note.daysUntilDeadline;
      statusText = '$daysUntil day${daysUntil == 1 ? '' : 's'} remaining';
      statusColor = Colors.blue;
      statusIcon = Icons.calendar_today;
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

  String _priorityToString(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }

  String _categoryToString(NoteCategory category) {
    switch (category) {
      case NoteCategory.general:
        return 'General';
      case NoteCategory.vocabulary:
        return 'Vocabulary';
      case NoteCategory.grammar:
        return 'Grammar';
      case NoteCategory.pronunciation:
        return 'Pronunciation';
      case NoteCategory.culture:
        return 'Culture';
      case NoteCategory.goals:
        return 'Goals';
      case NoteCategory.review:
        return 'Review';
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.blue;
      case Priority.low:
        return Colors.green;
    }
  }
}
