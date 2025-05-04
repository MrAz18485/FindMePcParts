import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService ({required this.uid});

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('userData');

  Future updateUserData (String name, String surname) async {
    return await userDataCollection.doc(uid).set({
      'name': name,
      'surname': surname
    });

  }
}