import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description, Uint8List file, String username, String uid, String profImage) async {
    String res = 'some error occur';
    try {
      var postId = Uuid().v1();

      var photoUrl = await StorageMethods().uploadImageToStorage('posts', file, postId);

      Post post = Post(
        description: description,
        username: username,
        uid: uid,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        idPost: postId,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> doubleTapLike(String idPost, String uid) async {
    await _firestore.collection('posts').doc(idPost).update({
      'likes': FieldValue.arrayUnion([uid])
    });
  }

  Future<void> likePost(String uid, String idPost, List like) async {
    try {
      if (like.contains(uid)) {
        await _firestore.collection('posts').doc(idPost).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(idPost).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  likeComment(String uid, String commentId, String idPost, List like) async {
    if (like.contains(uid)) {
      await _firestore
          .collection('posts')
          .doc(idPost)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore
          .collection('posts')
          .doc(idPost)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<void> postComment(
    String text,
    String idPost,
    String uid,
    String profilePic,
    String name,
  ) async {
    try {
      if (text.isNotEmpty) {
        var commentId = Uuid().v1();
        await _firestore.collection('posts').doc(idPost).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'postId': idPost,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
        });
      } else {
        print('text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

 Future<void> followUser(String currentUserUid, String userUid) async {
    try {
      //doc current user uid
      var refCurrentUserUid = _firestore.collection('users').doc(currentUserUid);

      DocumentSnapshot snapCurrentUser = await refCurrentUserUid.get();

      List followingCurrentUser = (snapCurrentUser.data()! as Map<String, dynamic>)['following'];

      //doc user uid
      var refUserUid = _firestore.collection('users').doc(userUid);

      DocumentSnapshot snapUser = await refUserUid.get();

      if (followingCurrentUser.contains(userUid)) {
        await refCurrentUserUid.update({
          'following': FieldValue.arrayRemove([userUid])
        });

        await refUserUid.update({
          'followers': FieldValue.arrayRemove([currentUserUid])
        });
      } else {
        await refCurrentUserUid.update({
          'following': FieldValue.arrayUnion([userUid])
        });

        await refUserUid.update({
          'followers': FieldValue.arrayUnion([currentUserUid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  
}
