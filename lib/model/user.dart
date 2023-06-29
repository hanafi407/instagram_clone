import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  User({
    required this.username,
    required this.email,
    required this.uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'bio': bio,
      'followers': followers,
      'following': following,
      'photoUrl': photoUrl,
    };
  }

  static User fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return User(
        username: snapshot['username'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        photoUrl: snapshot['photoUrl'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
