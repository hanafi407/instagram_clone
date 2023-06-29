import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String uid;
  final datePublished;
  final String postUrl;
  final String idPost;
  final String profImage;
  final likes;

  Post(
      {required this.description,
      required this.username,
      required this.uid,
      required this.datePublished,
      required this.postUrl,
      required this.idPost,
      required this.likes,
      required this.profImage});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'description': description,
      'uid': uid,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'idPost': idPost,
      'profImage': profImage,
      'likes': likes,
    };
  }

  static Post fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      description: snapshot['description'],
      uid: snapshot['uid'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      idPost: snapshot['idPost'],
      likes: snapshot['likes'],
      profImage: snapshot['profImage'],
    );
  }
}
