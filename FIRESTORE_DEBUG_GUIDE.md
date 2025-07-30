# 🔧 Firestore CRUD Debugging Guide

## 🧪 Testing Steps

### 1. **Run Firestore Debug Tests**
1. Navigate to Home page
2. Click "🧪 Debug Firestore" button
3. Click "Run Firestore Tests"
4. Check the console output for errors

### 2. **Common Issues & Solutions**

#### ❌ **Issue: "Permission denied" errors**
**Solution:** Update Firestore Security Rules
```bash
# Deploy these rules to Firebase Console
# Go to: Firebase Console > Firestore Database > Rules
# Copy content from firestore.rules file
```

#### ❌ **Issue: "Index not found" errors**
**Solution:** Create Firestore Indexes
```bash
# Common indexes needed:
# Collection: student_notes
# Fields: userId (Ascending), updatedAt (Descending)

# Collection: vocabulary  
# Fields: userId (Ascending), createdAt (Descending)

# Collection: bookmarks
# Fields: userId (Ascending), createdAt (Descending)
```

#### ❌ **Issue: Notes create but don't show up**
**Possible causes:**
1. **Firestore Rules** blocking reads
2. **Missing indexes** for compound queries
3. **Authentication state** not properly set
4. **Client-side caching** issues

### 3. **Manual Firestore Rules Setup**

Copy this to Firebase Console > Firestore > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Student Notes - Full CRUD for own data
    match /student_notes/{noteId} {
      allow read, write: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
                     request.auth.uid == request.resource.data.userId;
    }
    
    // Learning Goals - Full CRUD for own data
    match /learning_goals/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Vocabulary - Full CRUD for own data
    match /vocabulary/{vocabId} {
      allow read, write: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
                     request.auth.uid == request.resource.data.userId;
    }
    
    // Test collection for debugging
    match /test_collection/{testId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. **Browser Console Debugging**

Open browser Developer Tools (F12) and check for:

1. **Authentication errors:**
   ```
   Firebase Auth: User not signed in
   ```

2. **Firestore permission errors:**
   ```
   Missing or insufficient permissions
   ```

3. **Network errors:**
   ```
   Failed to fetch
   CORS policy error
   ```

### 5. **Step-by-Step Debugging**

#### Test 1: Authentication
```dart
final user = FirebaseAuth.instance.currentUser;
print('Current user: ${user?.email}');
print('User ID: ${user?.uid}');
```

#### Test 2: Basic Write
```dart
await FirebaseFirestore.instance
    .collection('test_collection')
    .add({'test': 'data', 'userId': user.uid});
```

#### Test 3: Basic Read
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('test_collection')
    .where('userId', isEqualTo: user.uid)
    .get();
print('Found ${snapshot.docs.length} documents');
```

#### Test 4: Student Notes
```dart
final noteId = await StudentDataService.createNote(
  lessonId: 'test',
  title: 'Test Note',
  content: 'Test Content',
);
print('Created note: $noteId');

final notes = await StudentDataService.getUserNotesSimple();
print('Total notes: ${notes.length}');
```

### 6. **Firebase Console Checks**

1. **Go to Firebase Console**
2. **Check Firestore Database:**
   - Verify collections exist: `student_notes`, `vocabulary`, `learning_goals`
   - Check document structure matches expected format
   - Verify `userId` fields are correct

3. **Check Authentication:**
   - Verify users are properly authenticated
   - Check user UIDs match document `userId` fields

### 7. **Quick Fixes**

#### If notes aren't loading:
1. Use `getUserNotesSimple()` instead of `getUserNotes()`
2. Check browser console for Firestore errors
3. Verify user is authenticated
4. Update Firestore rules

#### If creation works but reading fails:
1. Check Firestore indexes
2. Verify security rules allow reads
3. Check for compound query issues

#### If everything fails:
1. Run the Firestore test page
2. Check Firebase project configuration
3. Verify internet connectivity
4. Check browser security settings

### 8. **Production Deployment**

Before going live:
1. ✅ Update Firestore rules (remove test collections)
2. ✅ Create all necessary indexes
3. ✅ Test on multiple devices/browsers
4. ✅ Enable Firestore persistence for offline support
5. ✅ Set up proper monitoring and analytics

---

## 🚀 Expected Results

After fixing the issues, you should see:

1. **Notes Page:** Displays created notes immediately
2. **Dashboard:** Shows accurate statistics
3. **Vocabulary:** Full CRUD operations working
4. **Learning Goals:** Save and retrieve properly
5. **Test Page:** All tests pass ✅

The debugging page will help identify exactly where the issue is occurring!
