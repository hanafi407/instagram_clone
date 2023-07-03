import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  ResponsiveLayoutScreen(
      {super.key, required this.mobileScreenLayout, required this.webScreenLayout});

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // FirebaseAuth.instance.signOut();

    UserProvider _userProvider = Provider.of(context, listen: false);
    _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}
