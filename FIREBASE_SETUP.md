# Firebase Setup Guide for PurrfectPedia

This document provides comprehensive instructions for setting up Firebase Authentication, specifically Google Sign-In, for the PurrfectPedia Flutter app.

## 📋 Table of Contents

1. [Project Configuration](#project-configuration)
2. [SHA-1 Fingerprint Setup](#sha-1-fingerprint-setup)
3. [Firebase Console Configuration](#firebase-console-configuration)
4. [Common Issues & Troubleshooting](#common-issues--troubleshooting)
5. [Authentication Flow](#authentication-flow)
6. [Development Notes](#development-notes)

## 🔧 Project Configuration

### Current Package Configuration
- **Package Name:** `com.mixfution.purrfectpedia`
- **Firebase Project ID:** `purrfectpedia-c77f4`
- **Build Configuration:** `android/app/build.gradle.kts`

### Required Files
- `android/app/google-services.json` - Firebase configuration file
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase configuration

## 🔑 SHA-1 Fingerprint Setup

### Getting Your SHA-1 Fingerprint

```bash
# Navigate to android directory
cd android

# Generate signing report (Windows)
.\gradlew signingReport

# Generate signing report (macOS/Linux)  
./gradlew signingReport
```

### Current Debug SHA-1 Fingerprint
```
SHA1: 32:9F:43:65:0C:9C:77:EE:E5:9E:06:5D:80:C4:22:0F:84:20:43:3D
```

**⚠️ Important:** This fingerprint is specific to the current development environment. Each developer will have a different debug keystore SHA-1 fingerprint.

### For New Developers
1. Run the signing report command above
2. Copy the SHA1 value from the debug variant
3. Add it to Firebase Console (see next section)

## 🚀 Firebase Console Configuration

### Step 1: Access Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `purrfectpedia-c77f4`

### Step 2: Configure Android App
1. Click the gear icon (⚙️) → "Project settings"
2. Scroll to "Your apps" section
3. Find Android app: `com.mixfution.purrfectpedia`

### Step 3: Add SHA-1 Fingerprint
1. Click on your Android app
2. Scroll to "SHA certificate fingerprints"
3. Click "Add fingerprint"
4. Paste your SHA-1 fingerprint
5. Click "Save"

### Step 4: Enable Google Sign-In
1. Go to "Authentication" → "Sign-in method"
2. Find "Google" provider
3. Toggle "Enable" to ON
4. Add project support email
5. Click "Save"

### Step 5: Download Updated Configuration
1. After adding SHA-1, download new `google-services.json`
2. Replace `android/app/google-services.json`
3. For iOS: Download `GoogleService-Info.plist` and replace in `ios/Runner/`

## 🐛 Common Issues & Troubleshooting

### Error: `PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10)`

**Cause:** Google Sign-In DEVELOPER_ERROR (Error code 10)

**Solutions:**
1. **Missing SHA-1 Fingerprint:**
   - Ensure your debug keystore SHA-1 is added to Firebase Console
   - Each developer needs their own SHA-1 fingerprint added

2. **Package Name Mismatch:**
   - Verify `applicationId` in `build.gradle.kts` matches Firebase
   - Should be: `com.mixfution.purrfectpedia`

3. **Outdated google-services.json:**
   - Download fresh `google-services.json` after adding SHA-1
   - Replace the old file

4. **Google Sign-In Not Enabled:**
   - Check Firebase Console → Authentication → Sign-in method
   - Ensure Google provider is enabled

### Error: `No matching client found for package name`

**Cause:** Package name mismatch between app and Firebase configuration

**Solution:**
1. Check `android/app/build.gradle.kts`:
   ```kotlin
   android {
       namespace = "com.mixfution.purrfectpedia"
       defaultConfig {
           applicationId = "com.mixfution.purrfectpedia"
       }
   }
   ```

2. Verify `google-services.json` contains matching package name:
   ```json
   {
     "client": [{
       "client_info": {
         "android_client_info": {
           "package_name": "com.mixfution.purrfectpedia"
         }
       }
     }]
   }
   ```

### Build Errors After Configuration Changes

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 🔄 Authentication Flow

### Current Implementation

1. **Main App (`lib/main.dart`):**
   - `StreamBuilder<User?>` listens to `FirebaseAuth.instance.authStateChanges()`
   - Automatically navigates based on authentication state
   - Checks onboarding completion for authenticated users

2. **Auth Screen (`lib/screens/auth_screen.dart`):**
   - Handles Google Sign-In and email/password login
   - **Does NOT manually navigate** - lets main.dart handle navigation
   - Auth state changes trigger automatic navigation

3. **Navigation Logic:**
   ```
   User not authenticated → AuthScreen
   User authenticated + onboarding incomplete → OnboardingScreen1
   User authenticated + onboarding complete → HomeScreen
   ```

### Code Structure

```dart
// Main authentication listener
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // User logged in - check onboarding
      return FutureBuilder<bool>(
        future: OnboardingService().isOnboardingComplete(),
        builder: (context, onboardingSnapshot) {
          if (onboardingSnapshot.data == true) {
            return const HomeScreen();
          } else {
            return const OnboardingScreen1();
          }
        },
      );
    } else {
      // User not logged in
      return const AuthScreen();
    }
  },
)
```

## 🛠 Development Notes

### Testing Authentication

1. **Test Google Sign-In:**
   - Use real device or emulator with Google Play Services
   - Ensure internet connectivity
   - Check Firebase Console for successful sign-ins

2. **Test Master Credentials:**
   - Email: `maruf@gmail.com`
   - Password: `Maruf`
   - This bypasses Google Sign-In for testing

### Development vs Production

**Development:**
- Uses debug keystore (automatic)
- SHA-1 fingerprint: `32:9F:43:65:0C:9C:77:EE:E5:9E:06:5D:80:C4:22:0F:84:20:43:3D`

**Production:**
- Requires release keystore configuration
- Must generate and add release SHA-1 to Firebase
- Update signing configuration in `build.gradle.kts`

### Adding New Developers

1. New developer clones repository
2. Developer generates their SHA-1 fingerprint
3. Add their SHA-1 to Firebase Console
4. Developer downloads updated `google-services.json`
5. Test Google Sign-In functionality

### Security Notes

- **Never commit keystore files** to version control
- Debug keystores are automatically generated per environment
- Production keystores should be securely stored
- SHA-1 fingerprints are safe to share (they're public keys)

## 📱 Platform-Specific Setup

### Android
- Configuration: `android/app/google-services.json`
- Package: `com.mixfution.purrfectpedia`
- Minimum SDK: 26 (required for TensorFlow Lite)

### iOS (Future)
- Configuration: `ios/Runner/GoogleService-Info.plist`
- Bundle ID should match package name convention
- Additional iOS-specific setup required

## 🔗 Useful Commands

```bash
# Get SHA-1 fingerprint
cd android && .\gradlew signingReport

# Clean and rebuild
flutter clean && flutter pub get

# Run app
flutter run

# Hot reload (when app is running)
r

# Hot restart (when app is running)
R

# Check Flutter doctor
flutter doctor
```

## 📞 Support & Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Firebase Auth Flutter Plugin](https://pub.dev/packages/firebase_auth)
- [Flutter Firebase Setup Guide](https://firebase.flutter.dev/docs/overview)

---

**Last Updated:** Created during authentication setup and troubleshooting
**Author:** Development Team  
**Project:** PurrfectPedia v1.0 