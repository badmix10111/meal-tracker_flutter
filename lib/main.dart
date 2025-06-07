// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_tracker_flutter/views/add_edit_meal_page.dart';
import 'package:meal_tracker_flutter/views/forgot_password_page.dart';
import 'package:meal_tracker_flutter/views/meal_list_page.dart';
import 'package:meal_tracker_flutter/views/report_page.dart';
import 'package:meal_tracker_flutter/views/sign_in_page.dart';
import 'package:meal_tracker_flutter/views/sign_up_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/meals';

    return MaterialApp(
      title: 'Meal Tracker',
      theme: ThemeData(useMaterial3: true),
      initialRoute: initialRoute,
      // ← attach the observer here
      routes: {
        '/sign-in': (_) => const SignInPage(),
        '/sign-up': (_) => const SignUpPage(),
        '/meals': (_) => const MealListPage(),
        '/meals/edit': (_) => const AddEditMealPage(),
        '/reports': (_) => const ReportPage(), // ← added
        // in MaterialApp → routes:
        '/forgot-password': (_) => const ForgotPasswordPage(),
      },
      navigatorObservers: [MyApp.observer],
    );
  }
}

/// Checks auth state and redirects accordingly
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const SignInPage();
          }
          return const MealListPage();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
