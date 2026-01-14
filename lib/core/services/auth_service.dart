import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with Email and Password
  Future<UserCredential?> signUpWithEmail(String email, String password, {String? displayName, String? photoURL}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        if (displayName != null) {
          await credential.user!.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await credential.user!.updatePhotoURL(photoURL);
        }
      }
      
      return credential;
    } catch (e) {
      debugPrint('Sign Up Error: $e');
      rethrow;
    }
  }

  // Update User Profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      if (_auth.currentUser != null) {
        if (displayName != null) await _auth.currentUser!.updateDisplayName(displayName);
        if (photoURL != null) await _auth.currentUser!.updatePhotoURL(photoURL);
      }
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      rethrow;
    }
  }

  // Login with Email and Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    }
  }

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      rethrow;
    }
  }

  // Apple Sign In (Placeholder for logic, requires platform specific setup)
  Future<UserCredential?> signInWithApple() async {
    // Note: requires sign_in_with_apple package and specific setup in Apple Developer portal
    // For now, this is a placeholder for the logic structure
    debugPrint('Apple Sign In triggered');
    return null; 
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
