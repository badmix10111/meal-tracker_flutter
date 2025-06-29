# Meal Tracker Flutter

A Flutter app to log and track meals with Firebase backend.
Follows Material 3 design, supports user authentication, meal CRUD, search, sharing, and basic analytics.

---

## Table of Contents

1. Features
2. Prerequisites
3. Getting Started
   - Clone & Install
   - Firebase Setup
   - Generate firebase_options.dart (optional)
4. Running the App
   - Android
   - iOS
5. Development Workflow
6. Project Structure
7. Next Steps & Roadmap

---

## Features

- **Authentication**
  - Email/password sign up, sign in, password reset (Firebase Auth)
- **Meal Management**
  - Create, edit, delete meals with type, title, description, portion, timestamp, optional macros, and photo
- **List & Search**
  - Real-time list, filter by type, search by title
- **Sharing**
  - Share meal details via WhatsApp, email, etc.
- **Analytics**
  - Track custom events (login, signup, meal actions) with in-app report
- **Storage**
  - Firestore for data, Firebase Storage for photos (secured by auth rules)

---

## Prerequisites

- Flutter ≥ 3.x installed and on your PATH
- Xcode (for iOS) & Android Studio (for Android)
- A Firebase project with Firestore & Storage enabled
- (Optional) flutterfire_cli if you want auto-generated firebase_options.dart

---

## Getting Started

### Clone & Install

```bash
git clone https://github.com/your-username/meal-tracker-flutter.git
cd meal-tracker-flutter
flutter pub get
```

### Firebase Setup

1. Create a Firebase project named `meal-tracker-flutter`.

2. Android:
   - In Firebase console, add Android app with package `com.example.meal_tracker_flutter`
   - Download `google-services.json` and place it in `android/app/`

3. iOS:
   - In Firebase console, add iOS app with bundle ID `com.example.mealTrackerFlutter`
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`

4. Enable Email/Password auth in Firebase Authentication.
5. Enable Firestore (start in test mode).
6. Enable Storage with rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Generate firebase_options.dart (optional)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Then in `lib/main.dart`:

```dart
import 'firebase_options.dart';
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Running the App

### Android

1. Start or connect an emulator/device.
2. (Optional) Enable Analytics debug logs:

```bash
adb shell setprop debug.firebase.analytics.app com.example.meal_tracker_flutter
adb shell setprop log.tag.FA VERBOSE
adb shell setprop log.tag.FA-SVC VERBOSE
```

3. Run:

```bash
flutter run
```

### iOS

1. Open Xcode → Runner → Signing & Capabilities → select your Team.
2. Run:

```bash
flutter run
```

> Tip: If you hit provisioning issues, open `ios/Runner.xcworkspace` in Xcode and resolve signing.

---

## Development Workflow

- **Hot reload**: save changes to see UI updates instantly.
- **Analyze & format**:

```bash
flutter analyze
flutter format .
```

- **Testing** (after adding tests):

```bash
flutter test
```

- **CI/CD**: integrate lint and test steps in your pipeline (e.g. GitHub Actions).

---

## Project Structure

```
lib/
├── controllers/        # Business logic for meals, auth, reports, etc.
├── helpers/            # FirestoreService, utilities
├── models/             # Meal, metrics, report data classes
├── views/              # Screens: add/edit, list, auth, reports, etc.
└── main.dart           # App entrypoint

assets/
└── AppIcon.png         # Launcher icon
```

---

## Next Steps & Roadmap

- Add unit and widget tests
- Enhance theming, dark mode, custom fonts
- Integrate charting library for detailed analytics
- Enable offline support and sync conflict handling
- Set up CI/CD for automated builds and tests

---

Happy coding! 🎉
Feel free to open issues or send PRs—let’s make Meal Tracker even better.
