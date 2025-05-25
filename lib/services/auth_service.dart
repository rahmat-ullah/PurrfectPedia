import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // For web check

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Updated return type to include isNewUser information
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      GoogleSignInAccount? googleUser;
      if (kIsWeb) {
        // For web, use signInSilently initially or signIn directly
        // Firebase web SDK handles the popup automatically via signInWithPopup or signInWithRedirect
        // For Flutter web, GoogleSignIn().signIn() should trigger the appropriate flow.
        googleUser = await _googleSignIn.signIn();
      } else {
        // For mobile, ensure any previous session is signed out to allow account choosing
        // await _googleSignIn.signOut(); // Uncomment if you want to force account selection every time
        googleUser = await _googleSignIn.signIn();
      }

      // Obtain the auth details from the request
      if (googleUser == null) {
        // User cancelled the sign-in
        print('Google Sign-In: User cancelled.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      print('Google Sign-In: Success, user: ${userCredential.user?.displayName}, isNewUser: $isNewUser');
      return {'userCredential': userCredential, 'isNewUser': isNewUser};

    } on FirebaseAuthException catch (e) {
      print('Google Sign-In: Firebase Auth Exception - ${e.message}');
      return null;
    } catch (e) {
      print('Google Sign-In: An unexpected error occurred - $e');
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
        print('Master Credentials Sign-In: Success, user: ${userCredential.user?.email}');
        return userCredential;
      } on FirebaseAuthException catch (e) {
        print('Master Credentials Sign-In: Firebase Auth Exception - Code: ${e.code}, Message: ${e.message}');
        // Common error codes:
        // - user-not-found: If the user maruf@gmail.com is not pre-registered.
        // - wrong-password: If the password for maruf@gmail.com is incorrect in Firebase.
        // - invalid-email: If the email format is wrong (shouldn't happen with our check).
        // - network-request-failed: For network issues.
        return null;
      } catch (e) {
        print('Master Credentials Sign-In: An unexpected error occurred - $e');
        return null;
      }
    } else {
      print('Master Credentials Sign-In: Invalid master credentials provided by the user.');
      return null;
    }
  }

  // Future<void> signOut() async {
  //   await _googleSignIn.signOut();
  //   await _firebaseAuth.signOut();
  //   print('User signed out');
  // }
}
