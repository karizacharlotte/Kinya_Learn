# Firebase Setup Guide for KinyaLearn

## Step 1: Configure Firebase Options

You need to replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration.

### How to get your Firebase configuration:

1. Go to the [Firebase Console](https://console.firebase.google.com)
2. Select your KinyaLearn project
3. Click on the gear icon ⚙️ (Project Settings)
4. Scroll down to "Your apps" section

### For Web Configuration:
1. Click on the Web app icon `</>`
2. If you haven't created a web app yet, click "Add app" and select Web
3. Copy the config object values and replace in `firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',              // Replace with your apiKey
  appId: 'YOUR_WEB_APP_ID',                // Replace with your appId  
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID', // Replace with messagingSenderId
  projectId: 'YOUR_PROJECT_ID',            // Replace with your projectId
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### For Android Configuration:
1. Click on the Android app icon (robot)
2. If you haven't created an Android app yet:
   - Click "Add app" and select Android
   - Package name: `com.example.kinya_learn` (or your chosen package name)
   - App nickname: `KinyaLearn Android`
3. Download the `google-services.json` file
4. Place it in `android/app/google-services.json`
5. Copy the configuration values to `firebase_options.dart`:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',          // From google-services.json
  appId: 'YOUR_ANDROID_APP_ID',            // From google-services.json
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### For iOS Configuration:
1. Click on the iOS app icon (Apple)
2. If you haven't created an iOS app yet:
   - Click "Add app" and select iOS
   - Bundle ID: `com.example.kinyaLearn`
   - App nickname: `KinyaLearn iOS`
3. Download the `GoogleService-Info.plist` file
4. Place it in `ios/Runner/GoogleService-Info.plist`
5. Copy the configuration values to `firebase_options.dart`

## Step 2: Enable Firebase Services

In your Firebase Console, enable these services:

### Authentication:
1. Go to Authentication > Sign-in method
2. Enable "Email/Password" provider
3. Optionally enable Google, Facebook, or other providers

### Firestore Database:
1. Go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" for now (you can secure it later)
4. Select a location close to your users

### Storage:
1. Go to Storage
2. Click "Get started"
3. Choose "Start in test mode"

## Step 3: Android-specific Configuration

### Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### Update `android/app/build.gradle`:
Add at the bottom of the file:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 4: iOS-specific Configuration (if targeting iOS)

### Update `ios/Runner/Info.plist`:
Add these keys inside the `<dict>` tag:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from your `GoogleService-Info.plist`.

## Step 5: Test the Setup

Run these commands to test:

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Step 6: Security Rules (After Testing)

### Firestore Security Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Allow reading/writing subcollections
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Storage Security Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_pictures/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Example Values (DO NOT USE IN PRODUCTION):
Here's what the configuration might look like (with fake values):

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:web:abcdefghijklmnop',
  messagingSenderId: '123456789',
  projectId: 'kinya-learn-12345',
  authDomain: 'kinya-learn-12345.firebaseapp.com',
  storageBucket: 'kinya-learn-12345.appspot.com',
);
```

## What's Already Set Up:
✅ Firebase packages added to pubspec.yaml
✅ Firebase initialization in main.dart
✅ AuthProvider for authentication state management
✅ FirebaseService for database operations
✅ User authentication (sign up, sign in, sign out)
✅ User progress tracking (XP, lessons completed, streaks)
✅ Lesson progress saving
✅ Quiz result tracking

## Next Steps After Configuration:
1. Replace placeholder values in `firebase_options.dart`
2. Run `flutter pub get`
3. Test authentication in your app
4. Start using the AuthProvider in your login/register screens
5. Use FirebaseService to save user progress and lesson completion

Let me know when you've completed the configuration and I can help you integrate the authentication into your existing screens!
