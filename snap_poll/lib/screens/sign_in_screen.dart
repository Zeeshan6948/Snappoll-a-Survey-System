import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:flutter/services.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/initial_qr_or_signin.dart';
import 'package:snap_poll/screens/main_page.dart';
import 'package:snap_poll/screens/reset_password.dart';
import 'package:snap_poll/screens/signup_screen.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' hide AssetManifest;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser;
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        final User? user2 = FirebaseAuth.instance.currentUser;
        final uid = user2?.uid;
        GlobalVariables.my_ID = uid!.toString();
        print('User is signed in!');
        GlobalVariables.userId = uid;
        print(uid);

        print(GlobalVariables.userId);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        return;
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.INITIAL_SCREEN);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsX.appBarColor,
          centerTitle: true,
          title: Text(
            "Sign In".tr,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.menu_rounded, color: ColorsX.white,),
          //   onPressed: () => _scaffoldKey.currentState?.openDrawer(), //Scaffold.of(context).openDrawer(),
          // ),
          actions: [
            TextButton(
              onPressed: () {
                if (GlobalVariables.isEng == true) {
                  Get.updateLocale(const Locale('de', 'GER'));
                  GlobalVariables.isEng = false;
                } else {
                  Get.updateLocale(const Locale('en', 'US'));
                  GlobalVariables.isEng = true;
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: globalWidgets.myTextRaleway(context, 'changeLang'.tr,
                  ColorsX.white, 0, 0, 0, 0, FontWeight.w700, 16),
            ),
          ],
        ),
        body: body(context),
      ),
    );
  }

  static const colorizeColors = [
    ColorsX.appBarColor,
    ColorsX.blueGradientPureDark,
    ColorsX.buttonBackground,
    ColorsX.whatsappGreen,
  ];

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(color: ColorsX.white),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.05, 20, 0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/uni_logo.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 55,
              ),
              animatedTextLogo(),
              const SizedBox(
                height: 55,
              ),
              GlobalWidgets().reusableTextField("Enter UserName".tr,
                  Icons.person_outline, false, _emailTextController),
              const SizedBox(
                height: 20,
              ),
              GlobalWidgets().reusableTextField("Enter Password".tr,
                  Icons.lock_outline, true, _passwordTextController),
              const SizedBox(
                height: 5,
              ),
              GlobalWidgets().firebaseUIButton(context, "Sign In".tr, () {
                GlobalVariables.MY_EMAIL_ADDRESS = _emailTextController.text;
                saveInLocal();
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage()));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 3),
                    content: Text('Invalid Username or Password'),
                  ));
                  //print("Error ${error.toString()}");
                });
              }),
              signUpOption(context),
              forgetPassword(context)
            ],
          ),
        ),
      ),
    );
  }

  animatedTextLogo() {
    const colorizeTextStyle = TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'Horizon',
    ); //not used
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'SnapPoll',
              textStyle: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                      color: ColorsX.appBarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 32)),
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: false,
          repeatForever: true,
          onTap: () {
            debugPrint("Tap Event");
          },
        ),
      ),
    );
  }

  saveInLocal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', GlobalVariables.MY_EMAIL_ADDRESS);
  }
}

Row signUpOption(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Don't have account?".tr,
          style: const TextStyle(color: Colors.black87)),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        },
        child: Text(
          " Sign Up".tr,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Widget forgetPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 35,
    alignment: Alignment.bottomCenter,
    child: TextButton(
      child: Text(
        "Forgot Password?".tr,
        style: TextStyle(color: Colors.black87),
        textAlign: TextAlign.right,
      ),
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResetPassword())),
    ),
  );
}
