import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class FollowButton extends StatelessWidget {
  String content;
  int flex;
  bool isBlueColor;
  VoidCallback myCallback;
  FollowButton(
      {super.key,
      required this.content,
      required this.flex,
      required this.isBlueColor,
      required this.myCallback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: isBlueColor ? Colors.blue : Color.fromARGB(255, 32, 32, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text(content),
            onPressed: () {
              myCallback();
            },
          ),
        ));
  }
}
