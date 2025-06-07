// // // lib/screens/auth/sign_up_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class SignUpPage extends StatefulWidget {
// //   const SignUpPage({Key? key}) : super(key: key);

// //   @override
// //   _SignUpPageState createState() => _SignUpPageState();
// // }

// // class _SignUpPageState extends State<SignUpPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _confirmController = TextEditingController();
// //   bool _isLoading = false;
// //   String? _errorMessage;

// //   Future<void> _signUp() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     setState(() {
// //       _isLoading = true;
// //       _errorMessage = null;
// //     });
// //     try {
// //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
// //         email: _emailController.text.trim(),
// //         password: _passwordController.text,
// //       );
// //       if (mounted) {
// //         Navigator.pushReplacementNamed(context, '/home');
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       setState(() {
// //         _errorMessage = e.message;
// //       });
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Sign Up')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               TextFormField(
// //                 controller: _emailController,
// //                 decoration: const InputDecoration(labelText: 'Email'),
// //                 keyboardType: TextInputType.emailAddress,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return 'Enter an email.';
// //                   if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(value)) {
// //                     return 'Enter a valid email.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _passwordController,
// //                 decoration: const InputDecoration(labelText: 'Password'),
// //                 obscureText: true,
// //                 validator: (value) {
// //                   if (value == null || value.length < 6) {
// //                     return 'Password must be at least 6 characters.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _confirmController,
// //                 decoration:
// //                     const InputDecoration(labelText: 'Confirm Password'),
// //                 obscureText: true,
// //                 validator: (value) {
// //                   if (value != _passwordController.text) {
// //                     return 'Passwords do not match.';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               const SizedBox(height: 20),
// //               if (_errorMessage != null) ...[
// //                 Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
// //                 const SizedBox(height: 12),
// //               ],
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : _signUp,
// //                 child: _isLoading
// //                     ? const CircularProgressIndicator()
// //                     : const Text('Sign Up'),
// //               ),
// //               TextButton(
// //                 onPressed: _isLoading
// //                     ? null
// //                     : () => Navigator.pushReplacementNamed(context, '/sign-in'),
// //                 child: const Text('Already have an account? Sign In'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_analytics/firebase_analytics.dart'; // ← new

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailCtrl.text.trim(),
//         password: _passCtrl.text,
//       );
//       // 🔥 Analytics: log sign-up
//       await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'email');

//       Navigator.pushReplacementNamed(context, '/meals');
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Sign-up failed')),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext ctx) => Scaffold(
//         appBar: AppBar(title: const Text('Sign Up')),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _emailCtrl,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   validator: (v) => v != null && v.contains('@')
//                       ? null
//                       : 'Enter a valid email',
//                 ),
//                 TextFormField(
//                   controller: _passCtrl,
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator: (v) =>
//                       (v ?? '').length >= 6 ? null : 'Min 6 chars',
//                 ),
//                 TextFormField(
//                   controller: _confirmCtrl,
//                   decoration:
//                       const InputDecoration(labelText: 'Confirm Password'),
//                   obscureText: true,
//                   validator: (v) =>
//                       v == _passCtrl.text ? null : 'Passwords do not match',
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _signUp,
//                   child: _isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Sign Up'),
//                 ),
//                 TextButton(
//                   onPressed: () =>
//                       Navigator.pushReplacementNamed(ctx, '/sign-in'),
//                   child: const Text('Already have an account? Sign In'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
// }
// lib/views/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _loading = false;
  String? _errorText;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
      _errorText = null;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      Navigator.pushReplacementNamed(context, '/meals');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorText != null)
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v.trim())) return 'Invalid email';
                  return null;
                },
                onSaved: (v) => _email = v!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Min. 6 characters';
                  return null;
                },
                onSaved: (v) => _password = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-in'),
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
