import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestores_methods.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/screen/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> userData = {};
  int postLength = 0;
  int following = 0;
  int followers = 0;
  bool isFollowing = false;
  TextEditingController tes = TextEditingController();

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      var userLength = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      Map<String, dynamic> snapDataUser = userSnap.data()!;

      userData = snapDataUser;

      isFollowing = (snapDataUser['followers'] as List).contains(currentUserUid);

      postLength = userLength.docs.length;
      followers = (snapDataUser['followers'] as List).length;
      following = (snapDataUser['following'] as List).length;

      setState(() {});
    } catch (err) {
      showSnackbar(context, err.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void dispose() {
    super.dispose();
    currentUserUid;
  }

  @override
  Widget build(BuildContext context) {
    return userData['username'] != null
        ? Scaffold(
            appBar: MediaQuery.of(context).size.width > webScreenSize
                ? null
                : AppBar(
                    title: Text(userData['username']),
                    backgroundColor: mobileBackgroundColor,
                  ),
            body: Container(
              margin: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3)
                  : null,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 30,
                        ),
                        myCollumn(postLength, 'post'),
                        myCollumn(followers, 'Followers'),
                        myCollumn(following, 'Following'),
                      ],
                    ),
                  ),
                  Container(
                    // alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      userData['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      userData['bio'],
                    ),
                  ),
                  currentUserUid == widget.uid
                      ? Row(
                          children: [
                            FollowButton(
                              content: 'Edit profile',
                              flex: 1,
                              isBlueColor: false,
                              myCallback: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen(
                                            uid: currentUserUid,
                                          )),
                                );
                              },
                            ),
                            FollowButton(
                                content: 'Log out',
                                flex: 1,
                                isBlueColor: false,
                                myCallback: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                                  showSnackbar(context, 'Sign out success');
                                }),
                          ],
                        )
                      : isFollowing
                          ? Row(
                              children: [
                                FollowButton(
                                  content: 'Following',
                                  flex: 1,
                                  isBlueColor: false,
                                  myCallback: () async {
                                    await FirestoreMethods().followUser(currentUserUid, widget.uid);
                                    setState(() {
                                      isFollowing = false;
                                      following--;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                FollowButton(
                                  content: 'Follow',
                                  flex: 1,
                                  isBlueColor: false,
                                  myCallback: () async {
                                    await FirestoreMethods().followUser(currentUserUid, widget.uid);
                                    setState(() {
                                      isFollowing = true;
                                      following++;
                                    });
                                  },
                                ),
                              ],
                            ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where(
                          'uid',
                          isEqualTo: widget.uid,
                        )
                        .get(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];
                          return Container(
                            child: Image.network(
                              snap['postUrl'],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget myCollumn(int number, String label) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        )
      ],
    );
  }
}
