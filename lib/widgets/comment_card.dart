import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestores_methods.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilePic']),
            )
          ],
        ),
        Expanded(
          child: Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.snap['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.snap['text'],
                    maxLines: 5,
                  ),
                ),
                Text(
                  DateFormat('d/M/y').format(widget.snap['datePublished'].toDate()),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0),
          // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: IconButton(
            icon: (widget.snap['likes'] as List).contains(widget.snap['uid'])
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_border,
                  ),
            onPressed: () {
              FirestoreMethods().likeComment(
                widget.snap['uid'],
                widget.snap['commentId'],
                widget.snap['postId'],
                widget.snap['likes'],
              );
            },
          ),
        )
      ]),
    );
  }
}
