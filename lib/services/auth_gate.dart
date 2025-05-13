import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmepcparts/models/user.dart';

class AuthService {
  final FirebaseAuth _auth= FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid):null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in Anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in email pass
  Future signInEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return null;
    }
    on FirebaseAuthException catch (e) { 
      return "Email or password is invalid";
    }

  }

  // Register with email pass
  Future registerEmailPass(String email, String password, String username, String? name, String? surname) async {
    try {

      // 1) check if username exists
      QuerySnapshot qs = await FirebaseFirestore.instance.collection("users").get();
      qs.docs.forEach((row) { // inefficient sequential search
        if (row["username"] == username)
        {
          throw "Username already exists!";
        }
      });

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;   

      await DatabaseService(uid: user!.uid).updateUserData(username, name ?? "", surname ?? "", email);
      return null; // successful execution
    }
    
    on FirebaseAuthException catch (e) { 
      return e.message;
    }

  }

  // sign out
Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
}

}