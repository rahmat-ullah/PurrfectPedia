import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Simplified sign-in method without Google Sign-In for now
  // TODO: Implement Google Sign-In when the API is stable
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // For now, return null to indicate Google Sign-In is not available
      debugPrint('Google Sign-In: Not implemented yet');
      return null;
    } catch (e) {
      debugPrint('Google Sign-In: An unexpected error occurred - $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithMasterCredentials(String email, String password) async {
    if (email == 'maruf@gmail.com' && password == 'Maruf') {
      try {
        UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint('Master Credentials Sign-In: Success, user: ${userCredential.user?.email}');
        return userCredential;
      } on FirebaseAuthException catch (e) {
        debugPrint('Master Credentials Sign-In: Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}');
        // Common error codes:
        // - user-not-found: If the user maruf@gmail.com is not pre-registered.
        // - wrong-password: If the password for maruf@gmail.com is incorrect in Firebase.
        // - invalid-email: If the email format is wrong (shouldn't happen with our check).
        // - network-request-failed: For network issues.
        return null;
      } catch (e) {
        debugPrint('Master Credentials Sign-In: An unexpected error occurred - $e');
        return null;
      }
    } else {
      debugPrint('Master Credentials Sign-In: Invalid master credentials provided by the user.');
      return null;
    }
  }

  // Future<void> signOut() async {
  //   await _googleSignIn.signOut();
  //   await _firebaseAuth.signOut();
  //   print('User signed out');
  // }
}
