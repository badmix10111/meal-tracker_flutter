import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Home screen shown after successful login. Provides a logout button.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Safely signs the user out and navigates to sign-in screen
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    // Only navigate if this widget is still in the widget tree
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar with logout button
      appBar: AppBar(
        title: const Text('Meal Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),

      // Centered message indicating user is logged in
      body: const Center(
        child: Text("You're logged in!"),
      ),
    );
  }
}
