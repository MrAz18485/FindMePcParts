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