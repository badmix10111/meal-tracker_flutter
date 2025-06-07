// // // // lib/screens/auth/sign_in_page.dart
// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';

// // // class SignInPage extends StatefulWidget {
// // //   const SignInPage({Key? key}) : super(key: key);

// // //   @override
// // //   _SignInPageState createState() => _SignInPageState();
// // // }

// // // class _SignInPageState extends State<SignInPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passwordController = TextEditingController();
// // //   bool _isLoading = false;
// // //   String? _errorMessage;

// // //   Future<void> _signIn() async {
// // //     if (!_formKey.currentState!.validate()) return;
// // //     setState(() {
// // //       _isLoading = true;
// // //       _errorMessage = null;
// // //     });
// // //     try {
// // //       await FirebaseAuth.instance.signInWithEmailAndPassword(
// // //         email: _emailController.text.trim(),
// // //         password: _passwordController.text,
// // //       );
// // //       if (mounted) {
// // //         Navigator.pushReplacementNamed(context, '/home');
// // //       }
// // //     } on FirebaseAuthException catch (e) {
// // //       setState(() {
// // //         _errorMessage = e.message;
// // //       });
// // //     } finally {
// // //       if (mounted)
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //     }
// // //   }

// // //   Future<void> _resetPassword() async {
// // //     final email = _emailController.text.trim();
// // //     if (email.isEmpty) {
// // //       setState(() {
// // //         _errorMessage = 'Please enter your email.';
// // //       });
// // //       return;
// // //     }
// // //     try {
// // //       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Password reset email sent.')));
// // //     } on FirebaseAuthException catch (e) {
// // //       setState(() {
// // //         _errorMessage = e.message;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Sign In')),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               TextFormField(
// // //                 controller: _emailController,
// // //                 decoration: const InputDecoration(labelText: 'Email'),
// // //                 keyboardType: TextInputType.emailAddress,
// // //                 validator: (value) {
// // //                   if (value == null || value.isEmpty) return 'Enter an email.';
// // //                   if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(value)) {
// // //                     return 'Enter a valid email.';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _passwordController,
// // //                 decoration: const InputDecoration(labelText: 'Password'),
// // //                 obscureText: true,
// // //                 validator: (value) {
// // //                   if (value == null || value.length < 6) {
// // //                     return 'Password must be at least 6 characters.';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
// // //               const SizedBox(height: 20),
// // //               if (_errorMessage != null) ...[
// // //                 Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
// // //                 const SizedBox(height: 12),
// // //               ],
// // //               ElevatedButton(
// // //                 onPressed: _isLoading ? null : _signIn,
// // //                 child: _isLoading
// // //                     ? const CircularProgressIndicator()
// // //                     : const Text('Sign In'),
// // //               ),
// // //               TextButton(
// // //                 onPressed: _isLoading ? null : _resetPassword,
// // //                 child: const Text('Forgot Password?'),
// // //               ),
// // //               TextButton(
// // //                 onPressed: _isLoading
// // //                     ? null
// // //                     : () => Navigator.pushReplacementNamed(context, '/sign-up'),
// // //                 child: const Text('Don\'t have an account? Sign Up'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_analytics/firebase_analytics.dart';
// // import 'package:flutter/services.dart'; // ← new

// // class SignInPage extends StatefulWidget {
// //   const SignInPage({Key? key}) : super(key: key);
// //   @override
// //   _SignInPageState createState() => _SignInPageState();
// // }

// // class _SignInPageState extends State<SignInPage> {
// //   final _emailCtrl = TextEditingController();
// //   final _passCtrl = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isLoading = false;

// //   Future<void> _signIn() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     setState(() => _isLoading = true);

// //     try {
// //       await FirebaseAuth.instance.signInWithEmailAndPassword(
// //         email: _emailCtrl.text.trim(),
// //         password: _passCtrl.text,
// //       );
// //       // Analytics
// //       await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
// //       Navigator.pushReplacementNamed(context, '/meals');
// //     } catch (error) {
// //       String message = 'Login failed. Please try again.';

// //       if (error is FirebaseAuthException) {
// //         switch (error.code) {
// //           case 'invalid-email':
// //             message = 'That email address is malformed.';
// //             break;
// //           case 'user-disabled':
// //             message = 'This user account has been disabled.';
// //             break;
// //           case 'user-not-found':
// //             message = 'No account found for that email.';
// //             break;
// //           case 'wrong-password':
// //             message = 'Incorrect password. Please try again.';
// //             break;
// //           default:
// //             message = error.message ?? message;
// //         }
// //       } else if (error is PlatformException) {
// //         switch (error.code) {
// //           case 'ERROR_INVALID_CREDENTIAL':
// //           case 'invalid-credential':
// //             message = 'Invalid email or password.';
// //             break;
// //           case 'ERROR_USER_NOT_FOUND':
// //           case 'user-not-found':
// //             message = 'No account found for that email.';
// //             break;
// //           default:
// //             message = error.message ?? message;
// //         }
// //       }

// //       ScaffoldMessenger.of(context)
// //           .showSnackBar(SnackBar(content: Text(message)));
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   // Future<void> _signIn() async {
// //   //   if (!_formKey.currentState!.validate()) return;
// //   //   setState(() => _isLoading = true);

// //   //   try {
// //   //     await FirebaseAuth.instance.signInWithEmailAndPassword(
// //   //       email: _emailCtrl.text.trim(),
// //   //       password: _passCtrl.text,
// //   //     );
// //   //     // Analytics event
// //   //     await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
// //   //     Navigator.pushReplacementNamed(context, '/meals');
// //   //   } on FirebaseAuthException catch (e) {
// //   //     String message;
// //   //     switch (e.code) {
// //   //       case 'invalid-email':
// //   //         message = 'That email address is malformed.';
// //   //         break;
// //   //       case 'user-disabled':
// //   //         message = 'This user account has been disabled.';
// //   //         break;
// //   //       case 'user-not-found':
// //   //         message = 'No account found for that email.';
// //   //         break;
// //   //       case 'wrong-password':
// //   //         message = 'Incorrect password. Please try again.';
// //   //         break;
// //   //       default:
// //   //         message = 'Login failed: ${e.message}';
// //   //     }

// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text(message)),
// //   //     );
// //   //   } catch (e) {
// //   //     // catch any other errors
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('An unexpected error occurred: $e')),
// //   //     );
// //   //   } finally {
// //   //     if (mounted) setState(() => _isLoading = false);
// //   //   }
// //   // }

// //   @override
// //   Widget build(BuildContext ctx) => Scaffold(
// //         appBar: AppBar(title: const Text('Sign In')),
// //         body: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               children: [
// //                 TextFormField(
// //                   controller: _emailCtrl,
// //                   decoration: const InputDecoration(labelText: 'Email'),
// //                   validator: (v) => v != null && v.contains('@')
// //                       ? null
// //                       : 'Enter a valid email',
// //                 ),
// //                 TextFormField(
// //                   controller: _passCtrl,
// //                   decoration: const InputDecoration(labelText: 'Password'),
// //                   obscureText: true,
// //                   validator: (v) =>
// //                       (v ?? '').length >= 6 ? null : 'Min 6 chars',
// //                 ),
// //                 const SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: _isLoading ? null : _signIn,
// //                   child: _isLoading
// //                       ? const CircularProgressIndicator()
// //                       : const Text('Sign In'),
// //                 ),
// //                 TextButton(
// //                   onPressed: () =>
// //                       Navigator.pushReplacementNamed(ctx, '/sign-up'),
// //                   child: const Text("Don't have an account? Sign Up"),
// //                 ),
// //                 TextButton(
// //                   onPressed: () => _showPasswordResetDialog(ctx),
// //                   child: const Text('Forgot Password?'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );

// //   void _showPasswordResetDialog(BuildContext ctx) {
// //     final emailCtrl = TextEditingController();
// //     showDialog(
// //       context: ctx,
// //       builder: (_) => AlertDialog(
// //         title: const Text('Reset Password'),
// //         content: TextField(
// //           controller: emailCtrl,
// //           decoration: const InputDecoration(hintText: 'Email'),
// //         ),
// //         actions: [
// //           TextButton(
// //               onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
// //           TextButton(
// //               onPressed: () async {
// //                 await FirebaseAuth.instance
// //                     .sendPasswordResetEmail(email: emailCtrl.text.trim());
// //                 Navigator.pop(ctx);
// //                 ScaffoldMessenger.of(ctx).showSnackBar(
// //                     const SnackBar(content: Text('Check your email')));
// //               },
// //               child: const Text('Send')),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // lib/views/sign_in_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // ← for PlatformException
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

// class SignInPage extends StatefulWidget {
//   const SignInPage({Key? key}) : super(key: key);

//   @override
//   _SignInPageState createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       // ⚠️ Only call signIn... inside this try block
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailCtrl.text.trim(),
//         password: _passCtrl.text,
//       );

//       // Analytics
//       await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');

//       // Navigate on success
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/meals');
//     } catch (error) {
//       String message = 'Login failed. Please try again.';

//       if (error is FirebaseAuthException) {
//         switch (error.code) {
//           case 'invalid-email':
//             message = 'That email address is malformed.';
//             break;
//           case 'user-disabled':
//             message = 'This user account has been disabled.';
//             break;
//           case 'user-not-found':
//             message = 'No account found for that email.';
//             break;
//           case 'wrong-password':
//             message = 'Incorrect password. Please try again.';
//             break;
//           default:
//             message = error.message ?? message;
//         }
//       } else if (error is PlatformException) {
//         switch (error.code) {
//           case 'ERROR_INVALID_CREDENTIAL':
//           case 'invalid-credential':
//             message = 'Invalid email or password.';
//             break;
//           case 'ERROR_USER_NOT_FOUND':
//           case 'user-not-found':
//             message = 'No account found for that email.';
//             break;
//           default:
//             message = error.message ?? message;
//         }
//       }

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(message)));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Email
//               TextFormField(
//                 controller: _emailCtrl,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (v) =>
//                     v != null && v.contains('@') ? null : 'Enter a valid email',
//               ),

//               // Password
//               TextFormField(
//                 controller: _passCtrl,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (v) =>
//                     (v ?? '').length >= 6 ? null : 'Min 6 chars required',
//               ),

//               const SizedBox(height: 20),

//               // Sign In button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _signIn,
//                   child: _isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Sign In'),
//                 ),
//               ),

//               // Navigation links
//               TextButton(
//                 onPressed: () =>
//                     Navigator.pushReplacementNamed(context, '/sign-up'),
//                 child: const Text("Don't have an account? Sign Up"),
//               ),
//               TextButton(
//                 onPressed: () => _showPasswordResetDialog(context),
//                 child: const Text('Forgot Password?'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showPasswordResetDialog(BuildContext ctx) {
//     final emailCtrl = TextEditingController();
//     showDialog(
//       context: ctx,
//       builder: (_) => AlertDialog(
//         title: const Text('Reset Password'),
//         content: TextField(
//           controller: emailCtrl,
//           decoration: const InputDecoration(hintText: 'Email'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final email = emailCtrl.text.trim();
//               try {
//                 await FirebaseAuth.instance
//                     .sendPasswordResetEmail(email: email);
//                 Navigator.pop(ctx);
//                 ScaffoldMessenger.of(ctx).showSnackBar(
//                   const SnackBar(content: Text('Check your email')),
//                 );
//               } catch (e) {
//                 Navigator.pop(ctx);
//                 ScaffoldMessenger.of(ctx).showSnackBar(
//                   SnackBar(content: Text('Error: ${e.toString()}')),
//                 );
//               }
//             },
//             child: const Text('Send'),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/views/sign_in_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          .signInWithEmailAndPassword(email: _email, password: _password);
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

  void _goToForgot() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToForgot,
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Sign In'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-up'),
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
