import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<User?> signInWithGoogle()
  async {

    try {

      final GoogleSignInAccount?
      googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication
      googleAuth =
          await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken:
            googleAuth.accessToken,
        idToken:
            googleAuth.idToken,
      );

      final userCredential =
          await _auth
              .signInWithCredential(
        credential,
      );

      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.setBool(
        'isLogin',
        true,
      );

      return userCredential.user;

    } catch (e) {

      rethrow;
    }
  }

  Future<void> logout() async {

    await GoogleSignIn().signOut();

    await _auth.signOut();

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.clear();
  }
}