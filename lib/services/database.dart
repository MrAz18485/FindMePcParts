import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService ({required this.uid});

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData (String username, String name, String surname, String email) async {
    return await userDataCollection.doc(uid).set({
      'username': username,
      'name': name,
      'surname': surname,
      'email': email,
    });
  }
}