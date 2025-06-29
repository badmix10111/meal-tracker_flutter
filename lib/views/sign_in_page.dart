// Required packages
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/sign_in_controller.dart';

/// Sign-in screen for user authentication
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Form key and input controllers
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordFocus = FocusNode();

  // Custom sign-in controller using FirebaseAuth
  final _controller = SignInController(FirebaseAuth.instance);

  // UI state variables
  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorText;

  // Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Email validation
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+', caseSensitive: false);
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  // Password validation
  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  // Handle form submission (sign in logic)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      // Try to sign in using the entered credentials
      await _controller.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      // Navigate to meals page on successful sign-in
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/meals');
    } on SignInException catch (e) {
      // Custom auth error handling
      setState(() => _errorText = e.message);
    } catch (e) {
      // Handle any unexpected errors
      setState(() => _errorText = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Navigate to Forgot Password screen
  void _goToForgotPassword() {
    if (!_loading) Navigator.pushNamed(context, '/forgot-password');
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sign In'),
      ),
      child: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  // Build Material-style UI
  Widget _buildMaterial() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  // Reusable body UI across platforms
  Widget _buildBody({required double padding}) {
    final card = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Display error if login fails
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

            // Password input field with visibility toggle
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

            const SizedBox(height: 12),

            // "Forgot password?" link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goToForgotPassword,
                child: const Text('Forgot password?'),
              ),
            ),

            const SizedBox(height: 24),

            // Sign-in button or loading indicator
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
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ]),
        ),
      ),
    );

    // Full screen layout with logo, header and form card
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // App icon/avatar
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.fastfood, size: 48, color: Colors.blue),
          ),

          const SizedBox(height: 24),

          // Page heading
          Text(
            'Welcome Back',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Page subtext
          Text(
            'Sign in to continue tracking your meals.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Sign-in form card
          card,

          const SizedBox(height: 16),

          // Navigation to sign-up screen
          TextButton(
            onPressed: _loading
                ? null
                : () => Navigator.pushReplacementNamed(context, '/sign-up'),
            child: const Text("Don't have an account? Sign Up"),
          ),
        ],
      ),
    );
  }
}
