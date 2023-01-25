import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WGoogleSignIn {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn? _googleSignIn;
  static FirebaseApp? _firebaseApp;

  get googleSignIn => _googleSignIn;
  get firebaseApp => _firebaseApp;

  static Future<FirebaseApp> initFireBase() {
    if (_firebaseApp != null) {
      return Future.value(_firebaseApp);
    }

    return Firebase.initializeApp().then((value) {
      _firebaseApp = value;

      return value;
    });
  }

  static Future<dynamic> signOut() async {
    if (_googleSignIn == null) return;

    try {
      if (await _googleSignIn!.isSignedIn()) {
        await _googleSignIn!.signOut();
      }
    } finally {
      _googleSignIn = null;
    }
  }

  static Future<GoogleSignIn> signIn() async {
    if (_googleSignIn == null) {
      throw ErrorDescription('Failed to sign in');
    }

    if (await _googleSignIn!.isSignedIn()) {
      return _googleSignIn!;
    }

    try {
      _googleSignIn = GoogleSignIn(scopes: ['email']);
      final googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        return Future.error(ErrorDescription('Cancel!'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);
      return Future.value(_googleSignIn);
    } catch (e) {
      return Future.error(e);
    }
  }
}
