import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/forgot_password_controller.dart';

/// Page that allows a user to reset their password via email
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _controller = ForgotPasswordController(FirebaseAuth.instance);

  bool _loading = false; // Tracks if reset email is being sent
  bool _sent = false; // Tracks if email was successfully sent
  String? _errorText; // Stores any error message to display

  @override
  void dispose() {
    _emailCtrl.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  /// Validates the email format using regex
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+', caseSensitive: false);
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  /// Submits the reset request to Firebase and handles UI feedback
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    final email = _emailCtrl.text.trim();

    try {
      await _controller.sendResetEmail(email: email);

      if (!mounted) return;

      // Update state to show success message
      setState(() => _sent = true);
    } on ForgotPasswordException catch (e) {
      setState(() => _errorText = e.message);
    } catch (e) {
      setState(() => _errorText = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect platform for styling
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    // Choose appropriate UI style
    return isIOS ? _buildCupertino() : _buildMaterial();
  }

  /// iOS-style page layout
  Widget _buildCupertino() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Reset Password')),
      child: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  /// Android-style page layout
  Widget _buildMaterial() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(child: _buildBody(padding: 24)),
    );
  }

  /// Main form and UI logic for both platforms
  Widget _buildBody({required double padding}) {
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    // If reset email was sent, show confirmation message instead of form
    if (_sent) {
      final message =
          'A reset link has been sent to ${_emailCtrl.text.trim()}. Please check your inbox.';

      return Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: isIOS
              // iOS-style confirmation
              ? CupertinoAlertDialog(
                  title: const Text('Email Sent'),
                  content: Text(message),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )
              // Android-style confirmation
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                ),
        ),
      );
    }

    // Default: render form
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header icon
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.lock_reset, size: 48, color: Colors.blue),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Forgot Password',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Enter your email and we\'ll send you a link to reset your password.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Show error text if present
          if (_errorText != null) ...[
            Text(
              _errorText!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],

          // Email form
          Form(
            key: _formKey,
            child: Column(children: [
              // Email input field
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: _validateEmail,
                onFieldSubmitted: (_) => _submit(),
              ),

              const SizedBox(height: 24),

              // Submit button or loading spinner
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
                        // iOS button
                        ? CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            onPressed: _submit,
                            child: const Text('Send Reset Link'),
                          )
                        // Material button
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _submit,
                            child: const Text(
                              'Send Reset Link',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
