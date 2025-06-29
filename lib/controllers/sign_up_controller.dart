// lib/controllers/sign_up_controller.dart

import 'package:firebase_auth/firebase_auth.dart';

/// A simple exception with a user-friendly message.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

/// Encapsulates sign-up logic and maps Firebase errors to readable messages.
class SignUpController {
  final FirebaseAuth _auth;

  SignUpController(this._auth);

  /// Creates a new user account with [email] and [password].
  /// Throws [AuthException] on failure.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('That email is already registered.');
        case 'invalid-email':
          throw AuthException('The email address is not valid.');
        case 'weak-password':
          throw AuthException(
              'Please choose a stronger password (min 6 chars).');
        default:
          throw AuthException(e.message ?? 'Failed to sign up.');
      }
    } catch (_) {
      throw AuthException('An unexpected error occurred. Please try again.');
    }
  }
}
