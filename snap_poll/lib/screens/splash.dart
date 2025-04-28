import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/colors.dart';

import '../../../routes/app_pages.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging? messaging;
  GlobalWidgets globalWidgets = GlobalWidgets();
  // This widget is the root of your application.

  static const colorizeColors = [
    ColorsX.appBarColor,
    ColorsX.blueGradientPureDark,
    ColorsX.buttonBackground,
    ColorsX.whatsappGreen,
  ];

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging?.getToken().then((value) {
      debugPrint(value);
      saveTokenInLocal(value);
    });
    checkWhereToGo();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Opacity(
          //     opacity: 0.85,
          //     child: Image.asset(
          //       "assets/images/main.png",
          //       fit: BoxFit.contain,
          //     )
          // ),
          animatedTextLogo(),
          animatedTextDetail(),
        ],
      ),
    );
  }

  animatedTextLogo() {
    const colorizeTextStyle = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      fontFamily: 'Horizon',
    );
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 250.0,
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'SnapPoll',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: true,
          onTap: () {
            debugPrint("Tap Event");
          },
        ),
      ),
    );
  }

  animatedTextDetail() {
    const colorizeTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Horizon',
    );
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 250.0,
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Surveys for everyone',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: true,
          onTap: () {
            debugPrint("Tap Event");
          },
        ),
      ),
    );
  }

  myText(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.mukta(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  checkWhereToGo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getString('id') == null ||
        (prefs.getString('caste') == null) ||
        (prefs.getString('id') == '') ||
        (prefs.getString('caste') == ''))) {
      Timer(
          const Duration(seconds: 4), () => Get.toNamed(Routes.INITIAL_SCREEN));
    }
    // else{
    //   GlobalVariables.my_ID = "${prefs.getString('id')}";
    //   Timer(
    //       Duration(seconds: 3),
    //           () => Get.toNamed(Routes.ALL_CASTES_MAIN_PAGE));
    // }
  }

  void saveTokenInLocal(String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "$value");
    debugPrint('TOKEN STORED ' "$value");
  }
}
