import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/main_page.dart';
import 'package:snap_poll/screens/sign_in_screen.dart';
import 'package:snap_poll/screens/splash.dart';

import '../global/colors.dart';
import '../global/global_widgets.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InitialState();
  }
}

class _InitialState extends State<Initial> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController ctl = TextEditingController();
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: body(context),
        // drawer: DrawerWidget(context),
        appBar: AppBar(
            backgroundColor: ColorsX.appBarColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: globalWidgets.myTextRaleway(context, "SnapPoll",
                ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 22),
            actions: <Widget>[
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
            ]
            // leading: IconButton(
            //   icon: Icon(Icons.menu_rounded, color: ColorsX.white,),
            //   onPressed: () => _scaffoldKey.currentState?.openDrawer(), //Scaffold.of(context).openDrawer(),
            // ),
            ),
      ),
    );
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(color: ColorsX.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/uni_logo.png',
              height: 140,
              width: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 60),
            createRowOne(context),
            createRowTwo(context),
          ],
        ),
      ),
    );
  }

  createRowOne(BuildContext context) {
    return GestureDetector(
      onTap: () {
        globalWidgets.scanQRCode(context);
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: const BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Icon(
                Icons.qr_code,
                color: ColorsX.appBarColor,
                size: 50,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: globalWidgets.myTextRaleway(
                        context,
                        "Answer Survey".tr,
                        ColorsX.fullblack,
                        10,
                        10,
                        0,
                        0,
                        FontWeight.w600,
                        17)),
                Flexible(
                    child: globalWidgets.myTextRaleway(
                        context,
                        "Scan QR-Code to answer a Survey!".tr,
                        ColorsX.subBlack,
                        10,
                        10,
                        0,
                        0,
                        FontWeight.w700,
                        13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createRowTwo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.CARD_FORM_LAYOUT);
        Get.toNamed(Routes.MAIN_PAGE);
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: const BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Icon(
                Icons.credit_card_sharp,
                color: ColorsX.appBarColor,
                size: 50,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: globalWidgets.myTextRaleway(context, "Sign In".tr,
                        ColorsX.fullblack, 10, 10, 0, 0, FontWeight.w600, 17)),
                Flexible(
                    child: globalWidgets.myTextRaleway(
                        context,
                        "Sign in to manage your surveys!".tr,
                        ColorsX.subBlack,
                        20,
                        10,
                        0,
                        0,
                        FontWeight.w700,
                        13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
