import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screen/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = 'login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  signInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signInUser(_emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayoutScreen(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackbar(context, res);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: widthDevice > webScreenSize
            ? EdgeInsets.symmetric(horizontal: widthDevice * 0.3)
            : EdgeInsets.all(32),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(),
            Column(
              children: [
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(
                  height: 64,
                ),
                TextFieldInput(
                    textEditingController: _emailController,
                    hint: 'Enter your email',
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hint: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: signInUser,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text('Log in'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account? "),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(SignupScreen.routeName);
                      },
                      child: Container(
                        child: const Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )
              ],
            ),
            Column()
          ],
        ),
      ),
    );
  }
}
