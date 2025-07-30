import 'package:flutter/material.dart';
import '../services/student_data_service.dart';
import 'notes_page.dart';
import 'vocabulary_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    try {
      print('📊 Dashboard: Loading stats...');
      
      final notes = await StudentDataService.getUserNotesSimple();
      final vocabulary = await StudentDataService.getVocabulary();
      final goals = await StudentDataService.getLearningGoals();
      final dailyProgress = await StudentDataService.getDailyProgress();
      final bookmarks = await StudentDataService.getBookmarks();
      
      print('📊 Dashboard Stats:');
      print('   Notes: ${notes.length}');
      print('   Vocabulary: ${vocabulary.length}');
      print('   Bookmarks: ${bookmarks.length}');
      
      setState(() {
        _stats = {
          'totalNotes': notes.length,
          'favoriteNotes': notes.where((n) => n['isFavorite'] == true).length,
          'totalVocabulary': vocabulary.length,
          'masteredWords': vocabulary.where((v) => v['mastered'] == true).length,
          'bookmarks': bookmarks.length,
          'dailyGoal': goals?['dailyLessons'] ?? 3,
          'completedToday': dailyProgress['completedToday'] ?? 0,
          'goalAchieved': dailyProgress['goalAchieved'] ?? false,
        };
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Dashboard: Error loading stats: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading stats: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadStats,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _stats['goalAchieved'] == true 
                                  ? Icons.celebration 
                                  : Icons.trending_up,
                                color: _stats['goalAchieved'] == true 
                                  ? Colors.green 
                                  : Colors.orange,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _stats['goalAchieved'] == true
                                        ? '🎉 Daily Goal Achieved!'
                                        : 'Keep Going!',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_stats['completedToday']} / ${_stats['dailyGoal']} lessons today',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: (_stats['completedToday'] / _stats['dailyGoal']).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _stats['goalAchieved'] == true ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Stats
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        'Notes Created',
                        '${_stats['totalNotes']}',
                        Icons.note_alt_outlined,
                        Colors.blue,
                        '${_stats['favoriteNotes']} favorites',
                      ),
                      _buildStatCard(
                        'Vocabulary',
                        '${_stats['totalVocabulary']}',
                        Icons.book_outlined,
                        Colors.green,
                        '${_stats['masteredWords']} mastered',
                      ),
                      _buildStatCard(
                        'Bookmarks',
                        '${_stats['bookmarks']}',
                        Icons.bookmark_outline,
                        Colors.orange,
                        'Saved lessons',
                      ),
                      _buildStatCard(
                        'Daily Goal',
                        '${_stats['dailyGoal']}',
                        Icons.track_changes,
                        Colors.purple,
                        'lessons/day',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Navigate to Notes page and auto-show add dialog
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotesPage(
                                  autoShowAddDialog: true,
                                ),
                              ),
                            );
                            // Refresh stats when returning from notes page
                            _loadStats();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Quick Note'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Navigate to Vocabulary page and auto-show add dialog
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VocabularyPage(
                                  autoShowAddDialog: true,
                                ),
                              ),
                            );
                            // Refresh stats when returning from vocabulary page
                            _loadStats();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Word'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
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
}
