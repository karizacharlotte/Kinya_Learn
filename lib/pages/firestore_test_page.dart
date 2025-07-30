import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/student_data_service.dart';

class FirestoreTestPage extends StatefulWidget {
  const FirestoreTestPage({super.key});

  @override
  State<FirestoreTestPage> createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  final List<String> _testResults = [];
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Test'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _runTests,
              child: Text(_isRunning ? 'Running Tests...' : 'Run Firestore Tests'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults.join('\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runTests() async {
    setState(() {
      _isRunning = true;
      _testResults.clear();
    });

    await _addResult('🧪 Starting Firestore Tests...\n');

    // Test 1: Check Authentication
    await _testAuthentication();

    // Test 2: Test Basic Firestore Write
    await _testBasicWrite();

    // Test 3: Test Basic Firestore Read
    await _testBasicRead();

    // Test 4: Test Student Notes CRUD
    await _testStudentNotesCRUD();

    // Test 5: Test Vocabulary CRUD
    await _testVocabularyCRUD();

    await _addResult('\n✅ All tests completed!');

    setState(() => _isRunning = false);
  }

  Future<void> _addResult(String message) async {
    setState(() {
      _testResults.add('${DateTime.now().toString().substring(11, 19)} $message');
    });
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _testAuthentication() async {
    await _addResult('\n1️⃣ Testing Authentication...');
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _addResult('   ✅ User authenticated: ${user.email}');
      await _addResult('   ✅ User ID: ${user.uid}');
    } else {
      await _addResult('   ❌ No user authenticated');
    }
  }

  Future<void> _testBasicWrite() async {
    await _addResult('\n2️⃣ Testing Basic Firestore Write...');
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await _addResult('   ❌ Cannot test write: No user authenticated');
        return;
      }

      final testData = {
        'userId': user.uid,
        'testMessage': 'Hello from Firestore test!',
        'timestamp': FieldValue.serverTimestamp(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('test_collection')
          .add(testData);

      await _addResult('   ✅ Basic write successful');
      await _addResult('   ✅ Document ID: ${docRef.id}');
    } catch (e) {
      await _addResult('   ❌ Basic write failed: $e');
    }
  }

  Future<void> _testBasicRead() async {
    await _addResult('\n3️⃣ Testing Basic Firestore Read...');
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await _addResult('   ❌ Cannot test read: No user authenticated');
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('test_collection')
          .where('userId', isEqualTo: user.uid)
          .get();

      await _addResult('   ✅ Basic read successful');
      await _addResult('   ✅ Found ${snapshot.docs.length} test documents');
    } catch (e) {
      await _addResult('   ❌ Basic read failed: $e');
    }
  }

  Future<void> _testStudentNotesCRUD() async {
    await _addResult('\n4️⃣ Testing Student Notes CRUD...');
    
    try {
      // Create
      await _addResult('   📝 Testing note creation...');
      final noteId = await StudentDataService.createNote(
        lessonId: 'test_lesson',
        title: 'Test Note ${DateTime.now().millisecondsSinceEpoch}',
        content: 'This is a test note for CRUD testing.',
      );

      if (noteId != null) {
        await _addResult('   ✅ Note created: $noteId');
      } else {
        await _addResult('   ❌ Note creation returned null');
        return;
      }

      // Read
      await _addResult('   📖 Testing note reading...');
      final notes = await StudentDataService.getUserNotesSimple();
      await _addResult('   ✅ Found ${notes.length} notes');

      // Update
      await _addResult('   ✏️ Testing note update...');
      final updateSuccess = await StudentDataService.updateNote(
        noteId,
        title: 'Updated Test Note',
        isFavorite: true,
      );
      
      if (updateSuccess) {
        await _addResult('   ✅ Note updated successfully');
      } else {
        await _addResult('   ❌ Note update failed');
      }

      // Delete
      await _addResult('   🗑️ Testing note deletion...');
      final deleteSuccess = await StudentDataService.deleteNote(noteId);
      
      if (deleteSuccess) {
        await _addResult('   ✅ Note deleted successfully');
      } else {
        await _addResult('   ❌ Note deletion failed');
      }

    } catch (e) {
      await _addResult('   ❌ Notes CRUD test failed: $e');
    }
  }

  Future<void> _testVocabularyCRUD() async {
    await _addResult('\n5️⃣ Testing Vocabulary CRUD...');
    
    try {
      // Create
      await _addResult('   📚 Testing vocabulary creation...');
      final vocabSuccess = await StudentDataService.addVocabulary(
        word: 'Test Word',
        translation: 'Test Translation',
        pronunciation: 'test-pronunciation',
        definition: 'Test definition for CRUD testing',
      );

      if (vocabSuccess) {
        await _addResult('   ✅ Vocabulary added successfully');
      } else {
        await _addResult('   ❌ Vocabulary creation failed');
      }

      // Read
      await _addResult('   📖 Testing vocabulary reading...');
      final vocabulary = await StudentDataService.getVocabulary();
      await _addResult('   ✅ Found ${vocabulary.length} vocabulary items');

    } catch (e) {
      await _addResult('   ❌ Vocabulary CRUD test failed: $e');
    }
  }
}
