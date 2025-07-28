import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';

class BackendHealthCheck extends StatefulWidget {
  const BackendHealthCheck({super.key});

  @override
  State<BackendHealthCheck> createState() => _BackendHealthCheckState();
}

class _BackendHealthCheckState extends State<BackendHealthCheck> {
  Map<String, dynamic> _testResults = {};
  bool _isRunningTests = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Health Check'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firebase Backend Health Check',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isRunningTests ? null : _runAllTests,
              child: Text(_isRunningTests ? 'Running Tests...' : 'Run All Tests'),
            ),
            const SizedBox(height: 24),
            ..._buildTestResults(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTestResults() {
    return _testResults.entries.map((entry) {
      final testName = entry.key;
      final result = entry.value;
      final isSuccess = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'No message';
      final details = result['details'] as String? ?? '';

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      testName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunningTests = true;
      _testResults.clear();
    });

    try {
      await _testFirebaseConnection();
      await _testAuthentication();
      await _testFirestoreAccess();
      await _testUserDataOperations();
      await _testAuthProvider();
    } catch (e) {
      _addTestResult('Error', false, 'Test execution failed', e.toString());
    }

    setState(() {
      _isRunningTests = false;
    });
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Test basic Firebase connection
      final auth = FirebaseService.auth;
      final firestore = FirebaseService.firestore;
      
      // Test Firestore read
      final testDoc = await firestore.collection('test').doc('connection_test').get();
      
      _addTestResult(
        'Firebase Connection',
        true,
        'Firebase services are accessible',
        'Auth: ${auth != null}, Firestore: ${firestore != null}, Test doc exists: ${testDoc.exists}',
      );
    } catch (e) {
      _addTestResult(
        'Firebase Connection',
        false,
        'Failed to connect to Firebase',
        e.toString(),
      );
    }
  }

  Future<void> _testAuthentication() async {
    try {
      final auth = FirebaseService.auth;
      final currentUser = auth.currentUser;
      
      _addTestResult(
        'Authentication Service',
        true,
        'Authentication service is working',
        'Current user: ${currentUser?.email ?? 'None'}',
      );
    } catch (e) {
      _addTestResult(
        'Authentication Service',
        false,
        'Authentication service failed',
        e.toString(),
      );
    }
  }

  Future<void> _testFirestoreAccess() async {
    try {
      final firestore = FirebaseService.firestore;
      
      // Test write operation
      await firestore.collection('test').doc('health_check').set({
        'timestamp': DateTime.now().toIso8601String(),
        'test': 'health_check',
      });
      
      // Test read operation
      final doc = await firestore.collection('test').doc('health_check').get();
      
      _addTestResult(
        'Firestore Access',
        true,
        'Firestore read/write operations working',
        'Document exists: ${doc.exists}',
      );
    } catch (e) {
      _addTestResult(
        'Firestore Access',
        false,
        'Firestore operations failed',
        e.toString(),
      );
    }
  }

  Future<void> _testUserDataOperations() async {
    try {
      // Test user data initialization
      final testUserId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
      await FirestoreService.initializeUserData(
        testUserId,
        'test@example.com',
        'Test User',
      );
      
      // Test user progress operations
      await FirestoreService.updateUserProgress(
        userId: testUserId,
        totalLessonsCompleted: 1,
        totalPoints: 50,
        currentStreak: 1,
      );
      
      _addTestResult(
        'User Data Operations',
        true,
        'User data operations working',
        'Test user created and updated successfully',
      );
    } catch (e) {
      _addTestResult(
        'User Data Operations',
        false,
        'User data operations failed',
        e.toString(),
      );
    }
  }

  Future<void> _testAuthProvider() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Test auth provider state
      final isLoggedIn = authProvider.isLoggedIn;
      final isLoading = authProvider.isLoading;
      final user = authProvider.user;
      
      _addTestResult(
        'Auth Provider',
        true,
        'Auth provider is working correctly',
        'Logged in: $isLoggedIn, Loading: $isLoading, User: ${user?.email ?? 'None'}',
      );
    } catch (e) {
      _addTestResult(
        'Auth Provider',
        false,
        'Auth provider failed',
        e.toString(),
      );
    }
  }

  void _addTestResult(String testName, bool success, String message, String details) {
    setState(() {
      _testResults[testName] = {
        'success': success,
        'message': message,
        'details': details,
      };
    });
  }
}
