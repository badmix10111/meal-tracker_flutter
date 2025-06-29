import 'package:firebase_auth/firebase_auth.dart';

/// Thrown when password reset fails with a user-friendly message.
class ForgotPasswordException implements Exception {
  final String message;
  ForgotPasswordException(this.message);
}

/// Encapsulates password-reset logic.
class ForgotPasswordController {
  final FirebaseAuth _auth;

  ForgotPasswordController(this._auth);

  /// Sends a password-reset email to [email].
  /// Throws [ForgotPasswordException] on failure.
  Future<void> sendResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw ForgotPasswordException('That email address is invalid.');
        case 'user-not-found':
          throw ForgotPasswordException('No account found for that email.');
        default:
          throw ForgotPasswordException(
              e.message ?? 'Failed to send reset link.');
      }
    } catch (_) {
      throw ForgotPasswordException(
          'An unexpected error occurred. Please try again.');
    }
  }
}
