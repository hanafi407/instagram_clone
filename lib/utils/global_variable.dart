import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen/feed_screen.dart';
import '../screen/add_post_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/search_screen.dart';

const webScreenSize = 600;


var homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Notify'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
