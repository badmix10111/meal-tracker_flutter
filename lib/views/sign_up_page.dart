// Flutter and platform packages
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Custom controller for handling sign-up logic
import '../controllers/sign_up_controller.dart';

/// Sign-up page widget
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Form and input controllers
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordFocus = FocusNode();
  final _controller = SignUpController(FirebaseAuth.instance);

  // UI state variables
  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorText;

  // Dispose controllers and focus nodes to avoid memory leaks
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Email validation logic
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+', caseSensitive: false);
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  // Password validation logic
  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  // Handles sign-up process when form is submitted
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      // Attempt sign-up with entered credentials
      await _controller.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      // Navigate to meals page on success
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/meals');
    } on AuthException catch (e) {
      // Show error from Firebase
      setState(() => _errorText = e.message);
    } catch (e) {
      // Catch any other unexpected error
      setState(() => _errorText = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect if platform is iOS
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;
    return isIOS ? _buildCupertino() : _buildMaterial();
  }

  // Build iOS-style UI
  Widget _buildCupertino() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: const CupertinoNavigationBar(middle: Text('Sign Up')),
      child: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  // Build Material-style UI (Android, etc.)
  Widget _buildMaterial() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  // Shared UI for both platforms
  Widget _buildBody({required double padding}) {
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    // Card containing the sign-up form
    final formCard = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Display error message if exists
            if (_errorText != null) ...[
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            // Email input field
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocus),
            ),

            const SizedBox(height: 16),

            // Password input field with toggle visibility
            TextFormField(
              controller: _passwordCtrl,
              focusNode: _passwordFocus,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: _validatePassword,
              onFieldSubmitted: (_) => _submit(),
            ),

            const SizedBox(height: 24),

            // Sign-up button or loading indicator
            SizedBox(
              width: double.infinity,
              child: _loading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : isIOS
                      ? CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          onPressed: _submit,
                          child: const Text('Sign Up'),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
            ),
          ]),
        ),
      ),
    );

    // Main sign-up screen layout
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Icon/avatar at the top
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.person_add, size: 48, color: Colors.green),
          ),

          const SizedBox(height: 24),

          // Page title
          Text(
            'Create Account',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Page subtitle
          Text(
            'Sign up to start tracking your meals today.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Form card
          formCard,

          const SizedBox(height: 16),

          // Navigation to sign-in screen
          isIOS
              ? CupertinoButton(
                  onPressed: _loading
                      ? null
                      : () =>
                          Navigator.pushReplacementNamed(context, '/sign-in'),
                  child: const Text('Already have an account? Sign In'),
                )
              : TextButton(
                  onPressed: _loading
                      ? null
                      : () =>
                          Navigator.pushReplacementNamed(context, '/sign-in'),
                  child: const Text('Already have an account? Sign In'),
                ),
        ],
      ),
    );
  }
}
