import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getUser() async {
    var currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
      return model.User.fromSnapshot(snap);
    } else {
      return print('current user is null');
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    print('klik');
    String res = 'Some error occur';

    try {
      print('try');
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential _cred =
            await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print('uid= ${_cred.user!.uid}');

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file);

        model.User user = model.User(
            username: username,
            email: email,
            uid: _cred.user!.uid,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: []);

        await _firestore.collection('users').doc(_cred.user!.uid).set(user.toJson());

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> signInUser(String email, String password) async {
    String res = 'some error occur';
    try {
      print('try');
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        print('please enter email and password!');
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async{
   await _auth.signOut();
  }
}
