import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? username;
  final String? bio;
  final String? email;
  final String? uid;

  DataModel({this.username, this.bio, this.email, this.uid});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

      return DataModel(
          username: dataMap['userusername'],
          bio: dataMap['bio'],
          email: dataMap['email'],
          uid: dataMap['uid']);
    }).toList();
  }
}
