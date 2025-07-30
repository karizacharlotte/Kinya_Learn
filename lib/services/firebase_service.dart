import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  // Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Getters for instances
  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;

  // Authentication Methods
  
  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  /// Sign up with email and password
  static Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      await createUserDocument(userCredential.user!, name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      rethrow;
    }
  }

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.message}');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.message}');
      rethrow;
    }
  }

  /// Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Check if this is a new user and create document if needed
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await createUserDocument(
          userCredential.user!, 
          userCredential.user?.displayName ?? 'User'
        );
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Google sign in error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  // Firestore Methods

  /// Create user document
  static Future<void> createUserDocument(User user, String name) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'progress': {
          'lessonsCompleted': 0,
          'totalXP': 0,
          'currentStreak': 0,
          'maxStreak': 0,
        },
        'settings': {
          'notifications': true,
          'soundEnabled': true,
          'dailyGoal': 30, // minutes
        },
      });
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  /// Get user document
  static Future<DocumentSnapshot> getUserDocument(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error getting user document: $e');
      rethrow;
    }
  }

  /// Update user progress
  static Future<void> updateUserProgress({
    required String uid,
    int? lessonsCompleted,
    int? xpGained,
    int? currentStreak,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      if (lessonsCompleted != null) {
        updates['progress.lessonsCompleted'] = FieldValue.increment(lessonsCompleted);
      }
      
      if (xpGained != null) {
        updates['progress.totalXP'] = FieldValue.increment(xpGained);
      }
      
      if (currentStreak != null) {
        updates['progress.currentStreak'] = currentStreak;
        // Update max streak if current is higher
        DocumentSnapshot userDoc = await getUserDocument(uid);
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        int maxStreak = userData?['progress']?['maxStreak'] ?? 0;
        if (currentStreak > maxStreak) {
          updates['progress.maxStreak'] = currentStreak;
        }
      }

      updates['lastLoginAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      print('Error updating user progress: $e');
      rethrow;
    }
  }

  /// Save lesson progress
  static Future<void> saveLessonProgress({
    required String uid,
    required String lessonId,
    required String lessonTitle,
    required double completionPercentage,
    required int xpEarned,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('lessonProgress')
          .doc(lessonId)
          .set({
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'completionPercentage': completionPercentage,
        'xpEarned': xpEarned,
        'completedAt': FieldValue.serverTimestamp(),
        'lastAccessedAt': FieldValue.serverTimestamp(),
        ...?additionalData,
      }, SetOptions(merge: true));

      // Update overall user progress
      if (completionPercentage >= 100) {
        await updateUserProgress(
          uid: uid,
          lessonsCompleted: 1,
          xpGained: xpEarned,
        );
      }
    } catch (e) {
      print('Error saving lesson progress: $e');
      rethrow;
    }
  }

  /// Get lesson progress
  static Future<QuerySnapshot> getLessonProgress(String uid) async {
    try {
      return await _firestore
          .collection('users')
          .doc(uid)
          .collection('lessonProgress')
          .orderBy('lastAccessedAt', descending: true)
          .get();
    } catch (e) {
      print('Error getting lesson progress: $e');
      rethrow;
    }
  }

  /// Save quiz results
  static Future<void> saveQuizResult({
    required String uid,
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required int timeSpent, // in seconds
    Map<String, dynamic>? answers,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('quizResults')
          .add({
        'quizId': quizId,
        'quizTitle': quizTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': (score / totalQuestions * 100).round(),
        'timeSpent': timeSpent,
        'answers': answers,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Calculate XP based on score (example: 10 XP per correct answer)
      int xpEarned = score * 10;
      await updateUserProgress(uid: uid, xpGained: xpEarned);
    } catch (e) {
      print('Error saving quiz result: $e');
      rethrow;
    }
  }

  // Storage Methods

  /// Upload profile picture
  static Future<String> uploadProfilePicture(String uid, String filePath) async {
    try {
      Reference ref = _storage.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Update user document with profile picture URL
      await _firestore.collection('users').doc(uid).update({
        'profilePictureUrl': downloadUrl,
      });
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  /// Stream user data for real-time updates
  static Stream<DocumentSnapshot> streamUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Stream lesson progress for real-time updates
  static Stream<QuerySnapshot> streamLessonProgress(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('lessonProgress')
        .orderBy('lastAccessedAt', descending: true)
        .snapshots();
  }
}
