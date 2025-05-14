import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService ({required this.uid});

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData (String username, String name, String surname, String email, String registeredAt) async {
    return await userDataCollection.doc(uid).set({
      'username': username,
      'name': name,
      'surname': surname,
      'email': email,
      'registered_at': registeredAt,
    });
  }

  Future fetchUsername(String username) async {
    QuerySnapshot qs = await FirebaseFirestore.instance.collection("users").get();
    qs.docs.forEach((row) {
      if (row["username"] == username)
      {
        throw "Username exists!";
      }
    });
  }
}