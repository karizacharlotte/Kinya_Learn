import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/learning_notes_provider.dart';
import '../models/learning_note.dart';
import '../theme/app_theme.dart';
import '../components/note_dialogs.dart';
import '../components/goal_dialogs.dart';

class LearningNotesScreen extends StatefulWidget {
  const LearningNotesScreen({super.key});

  @override
  State<LearningNotesScreen> createState() => _LearningNotesScreenState();
}

class _LearningNotesScreenState extends State<LearningNotesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningNotesProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Notes & Goals'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.note), text: 'Notes'),
            Tab(icon: Icon(Icons.flag), text: 'Goals'),
            Tab(icon: Icon(Icons.analytics), text: 'Stats'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
          ),
        ],
      ),
      body: Consumer<LearningNotesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notes.isEmpty && provider.goals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _buildErrorWidget(provider.error!, provider);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildNotesTab(context, provider, isTablet),
              _buildGoalsTab(context, provider, isTablet),
              _buildStatsTab(context, provider, isTablet),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildErrorWidget(String error, LearningNotesProvider provider) {
    // Check if this is an authentication error
    bool isAuthError = error.toLowerCase().contains('log in') || 
                      error.toLowerCase().contains('authenticated') ||
                      error.toLowerCase().contains('user not');
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAuthError ? Icons.login : Icons.error_outline, 
            size: 64, 
            color: isAuthError ? AppTheme.primaryOrange : Colors.red[300]
          ),
          const SizedBox(height: 16),
          Text(
            isAuthError ? 'Authentication Required' : 'Oops! Something went wrong',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          if (isAuthError) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Register'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryOrange,
                    side: const BorderSide(color: AppTheme.primaryOrange),
                  ),
                ),
              ],
            ),
          ] else
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: () {
                provider.clearError();
                provider.initialize();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    final notes = provider.filteredNotes;

    if (notes.isEmpty) {
      return _buildEmptyNotesWidget(context);
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadNotes(),
      child: ListView.builder(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return _buildNoteCard(context, note, provider, isTablet);
        },
      ),
    );
  }

  Widget _buildGoalsTab(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    final goals = provider.filteredGoals;

    if (goals.isEmpty) {
      return _buildEmptyGoalsWidget(context);
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadGoals(),
      child: ListView.builder(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return _buildGoalCard(context, goal, provider, isTablet);
        },
      ),
    );
  }

  Widget _buildStatsTab(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotesStatsSection(context, provider, isTablet),
          const SizedBox(height: 24),
          _buildGoalsStatsSection(context, provider, isTablet),
          const SizedBox(height: 24),
          _buildQuickActionsSection(context, provider, isTablet),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, LearningNote note, LearningNotesProvider provider, bool isTablet) {
    final theme = Theme.of(context);
    final isOverdue = note.isOverdue;
    final isDueSoon = note.isDueSoon;

    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _showNoteDetailDialog(context, note, provider),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOverdue 
                ? Colors.red.withOpacity(0.5)
                : isDueSoon 
                  ? Colors.orange.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                        color: note.isCompleted ? Colors.grey[600] : null,
                      ),
                    ),
                  ),
                  _buildPriorityChip(note.priority, isTablet),
                  const SizedBox(width: 8),
                  _buildCategoryChip(note.category, isTablet),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: isTablet ? 12 : 8),
              Row(
                children: [
                  if (note.deadline != null) ...[
                    Icon(
                      Icons.schedule,
                      size: isTablet ? 16 : 14,
                      color: isOverdue 
                        ? Colors.red
                        : isDueSoon 
                          ? Colors.orange
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, y').format(note.deadline!),
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 11,
                        color: isOverdue 
                          ? Colors.red
                          : isDueSoon 
                            ? Colors.orange
                            : Colors.grey[600],
                        fontWeight: isOverdue || isDueSoon ? FontWeight.bold : null,
                      ),
                    ),
                    const Spacer(),
                  ],
                  if (note.deadline == null) const Spacer(),
                  IconButton(
                    icon: Icon(
                      note.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: note.isCompleted ? Colors.green : Colors.grey[400],
                    ),
                    onPressed: () => provider.toggleNoteCompletion(note.id),
                    iconSize: isTablet ? 24 : 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditNoteDialog(context, note, provider),
                    iconSize: isTablet ? 24 : 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDeleteNote(context, note, provider),
                    iconSize: isTablet ? 24 : 20,
                    color: Colors.red[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, LearningGoal goal, LearningNotesProvider provider, bool isTablet) {
    final theme = Theme.of(context);
    final progress = goal.progressPercentage;
    final isOverdue = goal.isOverdue && !goal.isCompleted;

    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _showGoalDetailDialog(context, goal, provider),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOverdue ? Colors.red.withOpacity(0.5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                        color: goal.isCompleted ? Colors.grey[600] : null,
                      ),
                    ),
                  ),
                  _buildGoalTypeChip(goal.type, isTablet),
                ],
              ),
              if (goal.description.isNotEmpty) ...[
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  goal.description,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: isTablet ? 12 : 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progress: ${goal.currentProgress}/${goal.targetValue}',
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${progress.toInt()}%',
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 11,
                                fontWeight: FontWeight.bold,
                                color: goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            goal.isCompleted ? Colors.green : AppTheme.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 8 : 6),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: isTablet ? 16 : 14,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Target: ${DateFormat('MMM d, y').format(goal.targetDate)}',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 11,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.bold : null,
                    ),
                  ),
                  const Spacer(),
                  if (!goal.isCompleted) ...[
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showUpdateProgressDialog(context, goal, provider),
                      iconSize: isTablet ? 24 : 20,
                      tooltip: 'Update Progress',
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditGoalDialog(context, goal, provider),
                    iconSize: isTablet ? 24 : 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDeleteGoal(context, goal, provider),
                    iconSize: isTablet ? 24 : 20,
                    color: Colors.red[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(Priority priority, bool isTablet) {
    Color color;
    switch (priority) {
      case Priority.urgent:
        color = Colors.red;
        break;
      case Priority.high:
        color = Colors.orange;
        break;
      case Priority.medium:
        color = Colors.blue;
        break;
      case Priority.low:
        color = Colors.green;
        break;
    }

    return Chip(
      label: Text(
        priority.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          fontSize: isTablet ? 10 : 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildCategoryChip(NoteCategory category, bool isTablet) {
    return Chip(
      label: Text(
        category.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          fontSize: isTablet ? 10 : 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.primaryGreen,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildGoalTypeChip(GoalType type, bool isTablet) {
    return Chip(
      label: Text(
        type.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          fontSize: isTablet ? 10 : 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.primaryOrange,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEmptyNotesWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first learning note to get started!',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create Note'),
            onPressed: () => _showCreateNoteDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGoalsWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Goals Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your first learning goal to track progress!',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create Goal'),
            onPressed: () => _showCreateGoalDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesStatsSection(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    final stats = provider.notesStats;
    if (stats.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes Statistics',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              childAspectRatio: isTablet ? 1.5 : 1.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildStatCard('Total', stats['totalNotes']?.toString() ?? '0', Icons.note, Colors.blue),
                _buildStatCard('Completed', stats['completedNotes']?.toString() ?? '0', Icons.check_circle, Colors.green),
                _buildStatCard('Overdue', stats['overdueNotes']?.toString() ?? '0', Icons.warning, Colors.red),
                _buildStatCard('Due Soon', stats['dueSoonNotes']?.toString() ?? '0', Icons.schedule, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsStatsSection(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    final stats = provider.goalsStats;
    if (stats.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals Statistics',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              childAspectRatio: isTablet ? 1.5 : 1.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildStatCard('Total', stats['totalGoals']?.toString() ?? '0', Icons.flag, Colors.blue),
                _buildStatCard('Completed', stats['completedGoals']?.toString() ?? '0', Icons.emoji_events, Colors.green),
                _buildStatCard('Avg Progress', '${(stats['averageProgress'] ?? 0.0).toInt()}%', Icons.trending_up, Colors.orange),
                _buildStatCard('Overdue', stats['overdueGoals']?.toString() ?? '0', Icons.warning, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, LearningNotesProvider provider, bool isTablet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickActionChip(
                  'Overdue Notes',
                  provider.overdueNotes.length,
                  Icons.warning,
                  Colors.red,
                  () => provider.setShowCompletedNotes(false),
                ),
                _buildQuickActionChip(
                  'Due Soon',
                  provider.dueSoonNotes.length,
                  Icons.schedule,
                  Colors.orange,
                  () => provider.setShowCompletedNotes(false),
                ),
                _buildQuickActionChip(
                  'Overdue Goals',
                  provider.overdueGoals.length,
                  Icons.flag,
                  Colors.red,
                  () => provider.setShowCompletedGoals(false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String title, int count, IconData icon, Color color, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text('$title ($count)'),
      onPressed: count > 0 ? onTap : null,
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Consumer<LearningNotesProvider>(
      builder: (context, provider, child) {
        if (!provider.isAuthenticated) {
          return FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            backgroundColor: AppTheme.primaryOrange,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.login),
            label: const Text('Login to Add'),
          );
        }
        
        return FloatingActionButton.extended(
          onPressed: () {
            final tabIndex = _tabController.index;
            if (tabIndex == 0) {
              _showCreateNoteDialog(context);
            } else if (tabIndex == 1) {
              _showCreateGoalDialog(context);
            }
          },
          backgroundColor: AppTheme.primaryOrange,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(_tabController.index == 0 ? 'Add Note' : 'Add Goal'),
        );
      },
    );
  }

  // Dialog methods implementation

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Consumer<LearningNotesProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Show Completed Notes'),
                  trailing: Switch(
                    value: provider.showCompletedNotes ?? true,
                    onChanged: (value) => provider.setShowCompletedNotes(value),
                  ),
                ),
                ListTile(
                  title: const Text('Show Completed Goals'),
                  trailing: Switch(
                    value: provider.showCompletedGoals ?? true,
                    onChanged: (value) => provider.setShowCompletedGoals(value),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<LearningNotesProvider>().clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showCreateNoteDialog(BuildContext context) {
    NoteDialogs.showCreateNoteDialog(context, context.read<LearningNotesProvider>());
  }

  void _showCreateGoalDialog(BuildContext context) {
    GoalDialogs.showCreateGoalDialog(context, context.read<LearningNotesProvider>());
  }

  void _showNoteDetailDialog(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    NoteDialogs.showNoteDetailDialog(context, note, provider);
  }

  void _showGoalDetailDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    GoalDialogs.showGoalDetailDialog(context, goal, provider);
  }

  void _showEditNoteDialog(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    NoteDialogs.showEditNoteDialog(context, note, provider);
  }

  void _showEditGoalDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    GoalDialogs.showEditGoalDialog(context, goal, provider);
  }

  void _showUpdateProgressDialog(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    GoalDialogs.showUpdateProgressDialog(context, goal, provider);
  }

  void _confirmDeleteNote(BuildContext context, LearningNote note, LearningNotesProvider provider) {
    NoteDialogs.confirmDeleteNote(context, note, provider);
  }

  void _confirmDeleteGoal(BuildContext context, LearningGoal goal, LearningNotesProvider provider) {
    GoalDialogs.confirmDeleteGoal(context, goal, provider);
  }
}
