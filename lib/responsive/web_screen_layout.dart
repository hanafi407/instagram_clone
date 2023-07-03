import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/global_variable.dart';

// ignore: must_be_immutable
class WebScreenLayout extends StatefulWidget {
  WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;

  late PageController pageController;

  void navigationTap(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 34,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTap(0),
            icon: Icon(
              _page == 0 ? Icons.home : Icons.home_outlined,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            color: primaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(1),
            icon: Icon(
              Icons.search_outlined,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            color: primaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(2),
            icon: Icon(
              _page == 2 ? Icons.add_circle : Icons.add_circle_outline,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            color: primaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(3),
            icon: Icon(
              _page == 3 ? Icons.favorite : Icons.favorite_outline,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            color: primaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(4),
            icon: Icon(
              _page == 04 ? Icons.person : Icons.person_outline,
              color: _page == 04 ? primaryColor : secondaryColor,
            ),
            color: primaryColor,
          ),
        ],
      ),
      body: Center(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: pageChanged,
          children: homeScreenItems,
        ),
      ),
    );
  }
}
