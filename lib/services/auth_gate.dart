import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmepcparts/models/user.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth= FirebaseAuth.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;


  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _currentUser = user != null ? AppUser(uid: user.uid) : null;
    notifyListeners();
  }

  // Sign in Anonymous
  Future signInAnon() async {
    try {
      await _auth.signInAnonymously();
      return null;
    }
    catch (e) {
      print(e.toString());
    }
  }

  // Sign in email pass
  Future signInEmailPass(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }
    on FirebaseAuthException catch (e) { 
      return e.message;
    }

  }
  // Update username
  Future<String?> updateUsername(String newUsername) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return "No user logged in.";
      }

      // Check if username exists
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: newUsername)
          .get();
      if (qs.docs.isNotEmpty) {
        // Check if the existing username belongs to a different user
        if (qs.docs.first.id != user.uid) {
          return "Username already exists!";
        }
        // If it's the same user's current username, allow (or treat as no change)
      }

      await DatabaseService(uid: user.uid).updateUserSingleField("username", newUsername);
      return null; // Success
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // Update email
  Future<String?> updateUserEmail(String newEmail) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return "No user logged in.";
      }
      await user.updateEmail(newEmail);
      // Also update email in Firestore if you store it there separately
      await DatabaseService(uid: user.uid).updateUserSingleField("email", newEmail);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'requires-recent-login') {
        return 'This operation is sensitive and requires recent authentication. Please log out and log back in before updating your email.';
      } else if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      }
      return e.message ?? "Failed to update email.";
    } catch (e) {
      print(e.toString());
      return "An unexpected error occurred while updating email.";
    }
  }

  // Update password
  Future<String?> updateUserPassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return "No user logged in.";
      }
      if (user.email == null) {
        return "User email is not available. Cannot re-authenticate.";
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'wrong-password') {
        return 'Incorrect current password.';
      } else if (e.code == 'weak-password') {
        return 'The new password is too weak.';
      } else if (e.code == 'requires-recent-login') {
        return 'This operation is sensitive and requires recent authentication. Please log out and log back in before changing your password.';
      }
      return e.message ?? "Failed to update password.";
    } catch (e) {
      print(e.toString());
      return "An unexpected error occurred while updating password.";
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

      DateTime currentDate = DateTime.now();
      String registeredAt = currentDate.toString();

      await DatabaseService(uid: user!.uid).updateUserData(username, name ?? "", surname ?? "", email, registeredAt);
      return null; // successful execution
    }
    
    on FirebaseAuthException catch (e) {
      return e.message;
    }

  }

    // sign out
  Future signOut() async {
      return await _auth.signOut();
  }
}

