// lib/controllers/sign_in_controller.dart

import 'package:firebase_auth/firebase_auth.dart';

/// Thrown when sign-in fails with a user-friendly message.
class SignInException implements Exception {
  final String message;
  SignInException(this.message);
}

/// Encapsulates Firebase sign-in logic and maps errors to readable messages.
class SignInController {
  final FirebaseAuth _auth;

  SignInController(this._auth);

  /// Attempts to sign in with [email] and [password].

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw SignInException('No account found for that email.');
        case 'wrong-password':
          throw SignInException('Incorrect password. Please try again.');
        case 'invalid-email':
          throw SignInException('The email address is invalid.');
        case 'user-disabled':
          throw SignInException('This account has been disabled.');
        default:
          throw SignInException(e.message ?? 'Failed to sign in.');
      }
    } catch (_) {
      throw SignInException('An unexpected error occurred. Please try again.');
    }
  }
}
