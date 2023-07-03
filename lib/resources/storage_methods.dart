import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName,Uint8List file,[String? postId]) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    

    if (postId!=null) {
      ref = ref.child(postId);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  delete(String childName,){
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

  }
}
