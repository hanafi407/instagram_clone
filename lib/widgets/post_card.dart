import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestores_methods.dart';
import 'package:instagram_clone/screen/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    super.initState();
    getCommentLength();
  }

  getCommentLength() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['idPost'])
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
      setState(() {});
    } catch (err) {
      showSnackbar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shrinkWrap: true,
                            children: ['delete']
                                .map((e) => InkWell(
                                      onTap: () async {
                                        await FirestoreMethods().deletePost(widget.snap['idPost']);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Text(e)),
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().doubleTapLike(
                widget.snap['idPost'],
                user.uid,
              );

              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: LikeAnimation(
                    duration: Duration(milliseconds: 400),
                    isAnimating: isLikeAnimating,
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                // smallLike: true,
                isAnimating: (widget.snap['likes'] as List).contains(user.uid),
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods()
                        .likePost(user.uid, widget.snap['idPost'].toString(), widget.snap['likes']);
                    setState(() {});
                  },
                  icon: (widget.snap['likes'] as List).contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                          snap: widget.snap,
                        ))),
                icon: Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      widget.snap['likes'].length == 0
                          ? ""
                          : widget.snap['likes'].length == 1
                              ? "Disukai oleh ${widget.snap['username']}"
                              : "Disukai ${widget.snap['likes'].length} ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: RichText(
                        text: TextSpan(style: TextStyle(color: primaryColor), children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "  ${widget.snap['description']}"),
                    ])),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLength comments',
                        style: TextStyle(color: secondaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat('d/M/y').format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(color: secondaryColor, fontSize: 13),
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
