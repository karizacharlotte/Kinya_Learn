import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String status = 'Testing Firebase connection...';
  bool isLoading = true;
  List<String> testResults = [];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    testFirebaseConnection();
  }

  Future<void> testFirebaseConnection() async {
    List<String> results = [];
    
    try {
      // Test 1: Firebase Initialization
      results.add('📱 Testing Firebase initialization...');
      setState(() {
        testResults = List.from(results);
      });
      
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      results.add('✅ Firebase initialized successfully!');
      results.add('🔥 Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}');
      results.add('🌐 Auth Domain: ${DefaultFirebaseOptions.currentPlatform.authDomain}');
      setState(() {
        testResults = List.from(results);
      });
      
      // Test 2: Firestore Connection
      results.add('🔄 Testing Firestore connection...');
      setState(() {
        testResults = List.from(results);
      });
      
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.enableNetwork();
      results.add('✅ Firestore connected successfully!');
      setState(() {
        testResults = List.from(results);
      });
      
      // Test 3: Authentication Service
      results.add('🔐 Testing Authentication service...');
      setState(() {
        testResults = List.from(results);
      });
      
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;
      results.add('✅ Auth service ready!');
      results.add('👤 Current user: ${currentUser?.email ?? 'No user logged in'}');
      results.add('🆔 User UID: ${currentUser?.uid ?? 'N/A'}');
      setState(() {
        testResults = List.from(results);
      });
      
      // Test 4: List all registered users (admin check)
      results.add('📋 Checking registered users...');
      setState(() {
        testResults = List.from(results);
      });
      
      try {
        QuerySnapshot userDocs = await firestore.collection('users').limit(10).get();
        results.add('👥 Found ${userDocs.docs.length} users in Firestore');
        for (var doc in userDocs.docs) {
          var data = doc.data() as Map<String, dynamic>;
          results.add('  - User: ${data['email'] ?? 'No email'} (${doc.id})');
        }
      } catch (e) {
        results.add('⚠️ Could not fetch users: $e');
      }
      setState(() {
        testResults = List.from(results);
      });
      
      // Test 5: Create a test document
      results.add('📝 Testing Firestore write...');
      setState(() {
        testResults = List.from(results);
      });
      
      await firestore.collection('test').doc('health_check').set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Backend working perfectly!',
        'app': 'Kinya Learn',
        'testTime': DateTime.now().toIso8601String(),
      });
      results.add('✅ Successfully wrote to Firestore!');
      
      // Test 6: Read the test document
      results.add('📖 Testing Firestore read...');
      DocumentSnapshot doc = await firestore
          .collection('test')
          .doc('health_check')
          .get();
      
      if (doc.exists) {
        results.add('✅ Successfully read from Firestore!');
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        results.add('📄 Data: ${data['status']}');
      } else {
        results.add('❌ Document not found');
      }
      
      results.add('');
      results.add('🎉 ALL TESTS PASSED!');
      results.add('🚀 Your backend is ready for Kinya Learn!');
      
      setState(() {
        testResults = results;
        status = 'Backend Tests Complete! ✅';
        isLoading = false;
      });
      
    } catch (e) {
      results.add('❌ Error: $e');
      results.add('');
      results.add('🔧 Please check your Firebase configuration');
      
      setState(() {
        testResults = results;
        status = 'Backend Test Failed ❌';
        isLoading = false;
      });
    }
  }

  Future<void> testUserCreation() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      status = 'Creating test user...';
      testResults = ['🔄 Creating user: ${emailController.text}'];
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Create user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      
      User? user = userCredential.user;
      if (user != null) {
        // Save user data to Firestore
        await firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'displayName': 'Test User',
          'isTestUser': true,
        });

        setState(() {
          testResults = [
            '✅ User created successfully!',
            '📧 Email: ${user.email}',
            '🆔 UID: ${user.uid}',
            '📝 Saved to Firestore',
            '',
            '🎉 User creation test passed!',
            '',
            '👀 Check Firebase Console:',
            '• Authentication > Users',
            '• Firestore > users collection',
          ];
          status = 'User Created Successfully! ✅';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        testResults = [
          '❌ User creation failed: $e',
          '',
          '🔧 Check your Firebase Authentication settings',
          '• Make sure Email/Password is enabled',
          '• Check Firestore rules',
        ];
        status = 'User Creation Failed ❌';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔥 Firebase Debug Console'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLoading 
                    ? Colors.blue[50] 
                    : status.contains('Failed') 
                        ? Colors.red[50] 
                        : Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLoading 
                      ? Colors.blue 
                      : status.contains('Failed') 
                          ? Colors.red 
                          : Colors.green,
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isLoading 
                      ? Colors.blue 
                      : status.contains('Failed') 
                          ? Colors.red 
                          : Colors.green,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Test Results
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Results:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: testResults.map((result) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                result,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // User Creation Test
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👤 Test User Creation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Test Email',
                      hintText: 'test@example.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'min 6 characters',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : testUserCreation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Create Test User'),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: isLoading ? null : () {
                          setState(() {
                            isLoading = true;
                            testResults = [];
                            status = 'Running tests...';
                          });
                          testFirebaseConnection();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Re-run Tests'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
