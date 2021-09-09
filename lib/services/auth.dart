import 'package:brew_crew/models/my_user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // create a NewUser based on UserCredentials
  MyUser? _userFromUserCredential(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  FirebaseAuth _auth = FirebaseAuth
      .instance; // _auth gives access to all the different properties in FirebaseAuth class

  // auth change user stream (returns a user whenever there is a change in authentication)
  Stream<MyUser?> get user2 {
    return _auth.authStateChanges().map((User? user) {
      return _userFromUserCredential(user!);
    });
    // .map(_userFromUserCredential);
  }

  // sign in anonymosly
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? helper = result.user;
      return _userFromUserCredential(helper!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String e, String pword) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: e, password: pword);
      User? user = result.user;
      return _userFromUserCredential(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future signUpWithEmailAndPassword(String e, String pword) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: e, password: pword);
      User? user = result.user;

      await DatabaseService(uid: user!.uid)
          .updateUserData('0', 'new brewer', 100);

      return _userFromUserCredential(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
