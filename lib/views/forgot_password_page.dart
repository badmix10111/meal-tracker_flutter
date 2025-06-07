// lib/views/forgot_password_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _sent = false;
  String? _errorText;

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      setState(() {
        _sent = true;
        _errorText = null;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _sent
            ? Center(child: Text('Link sent to $_email'))
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_errorText != null)
                      Text(_errorText!,
                          style: const TextStyle(color: Colors.red)),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Email is required';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(v.trim()))
                          return 'Invalid email';
                        return null;
                      },
                      onSaved: (v) => _email = v!.trim(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendReset,
                      child: const Text('Send Reset Link'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
