import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestores_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';

import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['idPost'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Add comment as ${user.username}'),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().postComment(
                  _commentController.text,
                  widget.snap['idPost'],
                  user.uid,
                  user.photoUrl,
                  user.username,
                );

                setState(() {
                  _commentController.text = '';
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
