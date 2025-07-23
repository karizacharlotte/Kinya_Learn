import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class BackendHealthCheck extends StatefulWidget {
  @override
  _BackendHealthCheckState createState() => _BackendHealthCheckState();
}

class _BackendHealthCheckState extends State<BackendHealthCheck> {
  Map<String, bool> healthStatus = {
    'Firebase Initialized': false,
    'Firestore Connected': false,
    'Auth Service Ready': false,
    'Lessons Collection': false,
    'Categories Collection': false,
    'Data Seeding': false,
  };

  @override
  void initState() {
    super.initState();
    runHealthCheck();
  }

  Future<void> runHealthCheck() async {
    print('🔍 Starting Backend Health Check...');

    // Test 1: Firebase Initialization
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() => healthStatus['Firebase Initialized'] = true);
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      return;
    }

    // Test 2: Firestore Connection
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.enableNetwork();
      setState(() => healthStatus['Firestore Connected'] = true);
      print('✅ Firestore connected successfully');
    } catch (e) {
      print('❌ Firestore connection failed: $e');
    }

    // Test 3: Auth Service
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      print('✅ Auth service ready - Current user: ${auth.currentUser?.email ?? 'None'}');
      setState(() => healthStatus['Auth Service Ready'] = true);
    } catch (e) {
      print('❌ Auth service failed: $e');
    }

    // Test 4: Check Lessons Collection
    try {
      QuerySnapshot lessonsSnapshot = await FirebaseFirestore.instance
          .collection('lessons')
          .limit(1)
          .get();
      setState(() => healthStatus['Lessons Collection'] = true);
      print('✅ Lessons collection accessible - Found ${lessonsSnapshot.docs.length} documents');
    } catch (e) {
      print('❌ Lessons collection check failed: $e');
    }

    // Test 5: Check Categories Collection
    try {
      QuerySnapshot categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .limit(1)
          .get();
      setState(() => healthStatus['Categories Collection'] = true);
      print('✅ Categories collection accessible - Found ${categoriesSnapshot.docs.length} documents');
    } catch (e) {
      print('❌ Categories collection check failed: $e');
    }

    // Test 6: Data Seeding Status
    try {
      DocumentSnapshot configDoc = await FirebaseFirestore.instance
          .collection('app_content')
          .doc('config')
          .get();
      
      if (configDoc.exists) {
        setState(() => healthStatus['Data Seeding'] = true);
        print('✅ App content seeded successfully');
      } else {
        print('⚠️ App content not yet seeded - will auto-seed on app start');
      }
    } catch (e) {
      print('❌ Data seeding check failed: $e');
    }

    print('🏁 Backend Health Check Complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backend Health Check'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Backend Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...healthStatus.entries.map((entry) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    entry.value ? Icons.check_circle : Icons.error,
                    color: entry.value ? Colors.green : Colors.red,
                  ),
                  title: Text(entry.key),
                  subtitle: Text(entry.value ? 'Working' : 'Failed'),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  healthStatus.updateAll((key, value) => false);
                });
                runHealthCheck();
              },
              child: Text('Run Health Check Again'),
            ),
          ],
        ),
      ),
    );
  }
}
