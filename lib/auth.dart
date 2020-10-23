import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import "package:google_sign_in/google_sign_in.dart";

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future<User> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user;
  }

  Future<User> signInAnonymously() async {
    UserCredential result = await _firebaseAuth.signInAnonymously();
    User user = result.user;
    return user;
  }

  Future<User> signInWithGoogle() async {
    User user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = _firebaseAuth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // get the credentials to (access / id token)
        // to sign in via Firebase Authentication
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        user = (await _firebaseAuth.signInWithCredential(credential)).user;
      }
    }
    return user;
  }

  Future<User> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user;
  }

  Future<User> getCurrentUser() async {
    print("getCurrentUser");
    User user = _firebaseAuth.currentUser;

    if (user != null) {
      print(user.uid);
    }
    return user;
  }

  Future<void> signOutGoogle() async {
    _googleSignIn.signOut(); // TODO relevant ?
    return _firebaseAuth.signOut();
  }

  Future<void> signOut() async {
    _googleSignIn.signOut(); // TODO relevant ?
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
