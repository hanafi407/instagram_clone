import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/screen/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAPBoxMCfuwCHh_KLNV3LPUGJs02W-_RfE",
          authDomain: "instagram-clone-a5947.firebaseapp.com",
          projectId: "instagram-clone-a5947",
          storageBucket: "instagram-clone-a5947.appspot.com",
          messagingSenderId: "491224207894",
          appId: "1:491224207894:web:02879f43b8cfbeee711b37",
          measurementId: "G-2Q9LHD8PEB"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          SignupScreen.routeName: (context) => SignupScreen(),
        },
        // home: Animasi(),
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return Scaffold(
                  body: ResponsiveLayoutScreen(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return LoginScreen();
          },
        ),
      ),
    );
  }
}
