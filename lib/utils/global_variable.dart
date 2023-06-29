import 'package:flutter/material.dart';
import '../screen/feed_screen.dart';
import '../screen/add_post_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('Search'),
  AddPostScreen(),
  Text('Notify'),
  Text('Profile'),
];
