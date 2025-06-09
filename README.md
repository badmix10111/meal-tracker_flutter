# Meal Tracker Flutter

This is a Flutter app I built to help me log and keep track of meals. It follows Material 3 design and uses Firebase for the backend.

---

## Main Features

* **User Accounts**

  * Sign up and log in with email/password (Firebase Auth)
  * Reset password via email

* **Adding Meals**

  * Choose meal type: Breakfast, Lunch, or Dinner
  * Give it a title and short description
  * Specify portion size, and optionally calories & macros (protein/carbs/fats)
  * Pick the time you ate (timestamp picker)
  * Snap a photo or choose one from your gallery

* **Viewing & Searching**

  * Scroll through all your past meals
  * Filter by meal type and search by title keyword

* **Sharing**

  * Share meal details via any app (WhatsApp, email, etc.)

* **Analytics & Dashboard**

  * Track events: login, signup, meal added/updated, plus screen views
  * A simple in-app report showing total meals, counts per type, and avg calories

* **Storage & Database**

  * Stores meal data in Cloud Firestore
  * Photos in Firebase Storage (securely with auth)

---

## Setup

1. Clone this repo:

   ```bash
   git clone https://github.com/your-username/meal-tracker-flutter.git
   cd meal-tracker-flutter
   ```

2. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

3. Firebase configuration:

   * Create a Firebase project named "meal-tracker-flutter"
   * **Android**:

     * Register app with package name `com.example.meal_tracker_flutter`
     * Download `google-services.json` and drop it into `android/app/`
   * **iOS**:

     * Register app with bundle ID `com.example.mealTrackerFlutter`
     * Download `GoogleService-Info.plist` and drop it into `ios/Runner/`
   * In the Firebase console:

     * Enable Email/Password auth
     * Create a Firestore database (start in test mode)
     * Enable Storage with rules:

       ```js
       rules_version = '2';
       service firebase.storage {
         match /b/{bucket}/o {
           match /{allPaths=**} {
             allow read, write: if request.auth != null;
           }
         }
       }
       ```

4. (Optional) To use `firebase_options.dart`:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   Then in `lib/main.dart`:

   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

---

## Running

**Android**
Start an emulator with Google Play services and run:

```bash
adb shell setprop debug.firebase.analytics.app com.example.meal_tracker_flutter
adb shell setprop log.tag.FA VERBOSE
adb shell setprop log.tag.FA-SVC VERBOSE
flutter run
```

**iOS**

```bash
flutter run
```

---

## Debug Analytics

Open Firebase console → Analytics → DebugView. Then use the app and observe event tracking in real-time.

---

## Code Layout

```
lib/
├── controllers/
│   ├── add_edit_meal_controller.dart
│   ├── forgot_password_controller.dart
│   ├── meal_list_controller.dart
│   ├── permission_controller.dart
│   ├── report_controller.dart
│   ├── sign_in_controller.dart
│   └── sign_up_controller.dart
│
├── helpers/
│   ├── firestore_service.dart
│   └── restart_widget.dart
│
├── models/
│   ├── meals_models.dart
│   ├── metric_models.dart
│   └── report_data_models.dart
│
├── views/
│   ├── add_edit_meal_page.dart
│   ├── error_page.dart
│   ├── forgot_password_page.dart
│   ├── home_page.dart
│   ├── meal_list_page.dart
│   ├── report_page.dart
│   ├── sign_in_page.dart
│   └── sign_up_page.dart
│
└── main.dart
```

---

## What’s Next

* Add tests
* Improve themes and UI tweaks
* Add chart-based analytics in reports
* Enable offline support
