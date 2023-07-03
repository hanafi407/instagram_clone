import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = 'signup-screen';
  String? uid;

  SignupScreen({super.key, this.uid});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  Map _userData = {};

  isProfile() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

    _userData = userData.data()!;
  }

  selectImage() async {
    print('select Image');
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  editProfile() {}

  signUpUser() async {
    ByteData byte = await rootBundle.load('assets/images/default_images.jpg');
    Uint8List imageNull = byte.buffer.asUint8List();
    _image ??= imageNull;
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res != 'success') {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, res);
    } else {
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      showSnackbar(context, 'Sign up successed');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  FittedBox(),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFYeg6gVBB9s29sFcyBvh2qwM2KL0ZgXuYuYph8XB0oA&s',
                              ),
                            ),
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _usernameController,
                    hint: 'Enter your username',
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.uid == null
                      ? Column(children: [
                          TextFieldInput(
                            textEditingController: _emailController,
                            hint: 'Enter your email',
                            textInputType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ])
                      : SizedBox.shrink(),
                  widget.uid == null
                      ? Column(
                          children: [
                            TextFieldInput(
                              textEditingController: _passwordController,
                              hint: 'Enter your password',
                              textInputType: TextInputType.text,
                              isPass: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : Container(),

                  TextFieldInput(
                    textEditingController: _bioController,
                    hint: 'Enter your bio',
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: widget.uid == null ? signUpUser : editProfile,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)))),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Text(widget.uid == null ? 'Sign up' : 'edit'),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print('ok');
                  //     },
                  //     child: Text('Sign up')),
                  SizedBox(
                    height: 20,
                  ),
                  widget.uid == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text("Have an account? "),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                              },
                              child: Container(
                                child: const Text('Sign in',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
