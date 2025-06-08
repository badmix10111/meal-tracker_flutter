// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'helpers/restart_widget.dart';
import 'controllers/permission_controller.dart';
import 'views/error_page.dart';
import 'views/sign_in_page.dart';
import 'views/sign_up_page.dart';
import 'views/forgot_password_page.dart';
import 'views/meal_list_page.dart';
import 'views/add_edit_meal_page.dart';
import 'views/report_page.dart';

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // picks up your json/plist

  // Request runtime permissions on both platforms
  await PermissionController().requestAllPermissions();

  // Any uncaught Flutter error will show our friendly ErrorPage
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorPage();
  };
}

void main() async {
  await _initializeApp();
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Firebase Analytics setup
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    // If not authenticated, start at sign‐in; otherwise show meals
    final initialRoute =
        FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/meals';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Tracker',
      theme: ThemeData(useMaterial3: true),
      initialRoute: initialRoute,
      routes: {
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
