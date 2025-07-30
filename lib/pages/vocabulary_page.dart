import 'package:flutter/material.dart';
import '../services/student_data_service.dart';

class VocabularyPage extends StatefulWidget {
  final bool autoShowAddDialog;
  
  const VocabularyPage({super.key, this.autoShowAddDialog = false});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _translationController = TextEditingController();
  final TextEditingController _pronunciationController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  
  List<Map<String, dynamic>> _vocabulary = [];
  bool _isLoading = false;
  bool _showMasteredOnly = false;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
    
    // Auto-show add dialog if requested
    if (widget.autoShowAddDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addVocabulary();
      });
    }
  }

  Future<void> _loadVocabulary() async {
    setState(() => _isLoading = true);
    
    try {
      final vocab = await StudentDataService.getVocabulary();
      setState(() {
        _vocabulary = vocab;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading vocabulary: $e')),
        );
      }
    }
  }

  Future<void> _addVocabulary() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Word'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Kinyarwanda Word *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _translationController,
                decoration: const InputDecoration(
                  labelText: 'English Translation *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pronunciationController,
                decoration: const InputDecoration(
                  labelText: 'Pronunciation *',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., moo-rah-ho',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _definitionController,
                decoration: const InputDecoration(
                  labelText: 'Definition (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _exampleController,
                decoration: const InputDecoration(
                  labelText: 'Example Sentence (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_wordController.text.isNotEmpty && 
                  _translationController.text.isNotEmpty &&
                  _pronunciationController.text.isNotEmpty) {
                
                final success = await StudentDataService.addVocabulary(
                  word: _wordController.text,
                  translation: _translationController.text,
                  pronunciation: _pronunciationController.text,
                  definition: _definitionController.text.isNotEmpty ? _definitionController.text : null,
                  example: _exampleController.text.isNotEmpty ? _exampleController.text : null,
                );
                
                if (success) {
                  _clearControllers();
                  Navigator.pop(context);
                  _loadVocabulary();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Word added successfully!')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all required fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _editVocabulary(Map<String, dynamic> vocab) async {
    _wordController.text = vocab['word'] ?? '';
    _translationController.text = vocab['translation'] ?? '';
    _pronunciationController.text = vocab['pronunciation'] ?? '';
    _definitionController.text = vocab['definition'] ?? '';
    _exampleController.text = vocab['example'] ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Word'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Kinyarwanda Word *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _translationController,
                decoration: const InputDecoration(
                  labelText: 'English Translation *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pronunciationController,
                decoration: const InputDecoration(
                  labelText: 'Pronunciation *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _definitionController,
                decoration: const InputDecoration(
                  labelText: 'Definition (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _exampleController,
                decoration: const InputDecoration(
                  labelText: 'Example Sentence (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_wordController.text.isNotEmpty && 
                  _translationController.text.isNotEmpty &&
                  _pronunciationController.text.isNotEmpty) {
                
                final success = await StudentDataService.updateVocabulary(vocab['id'], {
                  'word': _wordController.text,
                  'translation': _translationController.text,
                  'pronunciation': _pronunciationController.text,
                  'definition': _definitionController.text.isNotEmpty ? _definitionController.text : null,
                  'example': _exampleController.text.isNotEmpty ? _exampleController.text : null,
                });
                
                if (success) {
                  _clearControllers();
                  Navigator.pop(context);
                  _loadVocabulary();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Word updated successfully!')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVocabulary(String vocabId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Word'),
        content: const Text('Are you sure you want to delete this word?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await StudentDataService.deleteVocabulary(vocabId);
      if (success) {
        _loadVocabulary();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word deleted successfully!')),
        );
      }
    }
  }

  Future<void> _toggleMastered(String vocabId, bool currentStatus) async {
    final success = await StudentDataService.markVocabularyMastered(vocabId, !currentStatus);
    if (success) {
      _loadVocabulary();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentStatus ? 'Marked as not mastered' : 'Marked as mastered!'),
        ),
      );
    }
  }

  void _clearControllers() {
    _wordController.clear();
    _translationController.clear();
    _pronunciationController.clear();
    _definitionController.clear();
    _exampleController.clear();
  }

  List<Map<String, dynamic>> get _filteredVocabulary {
    if (!_showMasteredOnly) return _vocabulary;
    return _vocabulary.where((vocab) => vocab['mastered'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayVocab = _filteredVocabulary;
    final masteredCount = _vocabulary.where((v) => v['mastered'] == true).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'filter',
                child: ListTile(
                  leading: Icon(_showMasteredOnly ? Icons.visibility_off : Icons.visibility),
                  title: Text(_showMasteredOnly ? 'Show All' : 'Show Mastered Only'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'filter') {
                setState(() {
                  _showMasteredOnly = !_showMasteredOnly;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${_vocabulary.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Total Words'),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$masteredCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text('Mastered'),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${_vocabulary.length - masteredCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const Text('Learning'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Vocabulary List
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : displayVocab.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showMasteredOnly ? 'No mastered words yet' : 'No vocabulary added yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _showMasteredOnly 
                            ? 'Start learning words to master them!'
                            : 'Tap + to add your first word',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: displayVocab.length,
                    itemBuilder: (context, index) {
                      final vocab = displayVocab[index];
                      final isMastered = vocab['mastered'] == true;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: isMastered ? Colors.green : Colors.orange,
                            child: Icon(
                              isMastered ? Icons.check : Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            vocab['word'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vocab['translation'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '[${vocab['pronunciation'] ?? ''}]',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'mastered',
                                child: ListTile(
                                  leading: Icon(
                                    isMastered ? Icons.undo : Icons.check_circle,
                                    color: isMastered ? Colors.orange : Colors.green,
                                  ),
                                  title: Text(isMastered ? 'Mark as Learning' : 'Mark as Mastered'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'mastered') {
                                _toggleMastered(vocab['id'], isMastered);
                              } else if (value == 'edit') {
                                _editVocabulary(vocab);
                              } else if (value == 'delete') {
                                _deleteVocabulary(vocab['id']);
                              }
                            },
                          ),
                          children: [
                            if (vocab['definition'] != null || vocab['example'] != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (vocab['definition'] != null) ...[
                                      const Text(
                                        'Definition:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(vocab['definition']),
                                      const SizedBox(height: 8),
                                    ],
                                    if (vocab['example'] != null) ...[
                                      const Text(
                                        'Example:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        vocab['example'],
                                        style: const TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVocabulary,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _pronunciationController.dispose();
    _definitionController.dispose();
    _exampleController.dispose();
    super.dispose();
  }
}
