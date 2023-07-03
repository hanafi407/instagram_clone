import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';
import '../model/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: pageChanged,
          children: homeScreenItems,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 70,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                _page == 0 ? Icons.home : Icons.home_outlined,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                _page == 2 ? Icons.add_circle : Icons.add_circle_outline,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                _page == 3 ? Icons.favorite : Icons.favorite_outline,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                _page == 04 ? Icons.person : Icons.person_outline,
                color: _page == 04 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTap,
      ),
    );
  }
}
