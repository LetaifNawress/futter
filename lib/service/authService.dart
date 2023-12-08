import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;

  User({required this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User? _userFromFirebaseUser(firebase_auth.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future<User?> signInAnon() async {
    try {
      firebase_auth.UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      firebase_auth.UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(result.user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      firebase_auth.UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user?.uid ?? '')
          .updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  Future<void> updateUserData(String field1, String field2, int field3) async {
    // Implement your logic to update user data in the database
  }
}
