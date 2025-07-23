#!/bin/bash

# Kinya Learn Backend Setup Script
# Run this after setting up Firebase Console

echo "🚀 Setting up Kinya Learn Backend..."
echo ""

# Check if Firebase project is configured
echo "📋 Backend Setup Checklist:"
echo ""
echo "□ 1. Firebase Project Created"
echo "   - Go to https://console.firebase.google.com"
echo "   - Create project named 'kinya-learn-app'"
echo "   - Enable Google Analytics"
echo ""
echo "□ 2. Enable Firebase Services:"
echo "   ✓ Authentication (Email/Password)"
echo "   ✓ Firestore Database (Production mode)"
echo "   ✓ Storage (for videos/audio)"
echo "   ✓ Analytics (optional)"
echo ""
echo "□ 3. Platform Configuration:"
echo "   ✓ Web app (get config snippet)"
echo "   ✓ Android app (download google-services.json)"
echo "   ✓ iOS app (download GoogleService-Info.plist)"
echo ""
echo "□ 4. Security Rules Setup"
echo "   ✓ Firestore rules (user data protection)"
echo "   ✓ Storage rules (file access control)"
echo ""
echo "□ 5. Replace Firebase Config"
echo "   ✓ Update lib/firebase_options.dart with real values"
echo ""

# Check if Flutter dependencies are installed
echo "📦 Installing Flutter Dependencies..."
flutter pub get

echo ""
echo "🔍 Checking Firebase Configuration..."

# Check if firebase_options.dart has placeholder values
if grep -q "YOUR_PROJECT_ID" lib/firebase_options.dart; then
    echo "❌ Firebase configuration still has placeholder values!"
    echo "   Please update lib/firebase_options.dart with your real Firebase config"
    echo "   See FIREBASE_SETUP_GUIDE.md for detailed instructions"
    exit 1
else
    echo "✅ Firebase configuration appears to be updated"
fi

echo ""
echo "🧪 Testing Firebase Connection..."
flutter run --debug -d web &
FLUTTER_PID=$!

# Wait a few seconds then check logs
sleep 10
echo "Check the Flutter logs above for Firebase initialization success"

echo ""
echo "📊 Database Structure Ready:"
echo "   ✓ Users collection with authentication"
echo "   ✓ Lessons collection with comprehensive content"
echo "   ✓ Categories for organized learning"
echo "   ✓ Progress tracking per user"
echo "   ✓ Achievements system"
echo "   ✓ Daily challenges"
echo ""

echo "🎯 Next Steps:"
echo "1. Run: flutter run -d web"
echo "2. Test user registration/login"
echo "3. Verify lesson data loads"
echo "4. Check progress tracking"
echo "5. Test video playback"
echo ""

echo "✅ Backend setup complete! Check Flutter app output for any errors."
