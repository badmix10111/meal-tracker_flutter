// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meal_tracker_2/views/add_edit_meal_page.dart';
import 'package:meal_tracker_2/views/error_page.dart';
import 'package:meal_tracker_2/views/forgot_password_page.dart';
import 'package:meal_tracker_2/views/meal_list_page.dart';
import 'package:meal_tracker_2/views/report_page.dart';
import 'package:meal_tracker_2/views/sign_in_page.dart';
import 'package:meal_tracker_2/views/sign_up_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'helpers/restart_widget.dart';
// import 'views/error_page.dart';
// import 'views/sign_in_page.dart';
// import 'views/sign_up_page.dart';
// import 'views/forgot_password_page.dart';
// import 'views/meal_list_page.dart';
// import 'views/add_edit_meal_page.dart';
// import 'views/report_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PermissionGate());
}

/// A widget that requests all permissions before showing the real app.
class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    // These calls will trigger the native iOS/Android dialogs
    await [
      Permission.camera,
      Permission.photos, //  photo library
      Permission.mediaLibrary, //  photo library (alternate)
      Permission.locationWhenInUse, //  location
      Permission.storage, //  storage
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    // Immediately show the real app UI.
    return const RestartWidget(child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    // Set our global error screen
    ErrorWidget.builder = (FlutterErrorDetails details) => const ErrorPage();

    final initialRoute =
        FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/meals';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Tracker',
      theme: ThemeData(useMaterial3: true),
      initialRoute: initialRoute,
      routes: {
        // Navigate through all views
        '/sign-in': (_) => const SignInPage(),
        '/sign-up': (_) => const SignUpPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
        '/meals': (_) => const MealListPage(),
        '/meals/edit': (_) => const AddEditMealPage(),
        '/reports': (_) => const ReportPage(),
      },
      navigatorObservers: [observer],
    );
  }
}
