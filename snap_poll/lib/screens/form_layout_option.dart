import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/routes/app_pages.dart';

import '../global/colors.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';

class FormLayoutOption extends StatelessWidget {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController ctl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.toNamed(Routes.MAIN_PAGE);
          return false;
        },
        child: Scaffold(
          body: body(context),
          appBar: AppBar(
              backgroundColor: ColorsX.appBarColor,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MAIN_PAGE);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorsX.white,
                  size: 18,
                ),
              )),
        ));
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(color: ColorsX.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            globalWidgets.myTextRaleway(context, "Select form layout",
                ColorsX.fullblack, 20, 0, 0, 0, FontWeight.w700, 22),
            globalWidgets.myTextRaleway(
                context,
                "Choose a layout according to your needs",
                ColorsX.subBlack,
                10,
                0,
                0,
                0,
                FontWeight.w400,
                13),
            createRowOne(context),
            // createRowTwo(context),
          ],
        ),
      ),
    );
  }

  createRowOne(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (GlobalVariables.TITLE_OF_SURVEY.isEmpty) {
          // changed, so onpop of survey creation it will ask again for title
          surveyTitleDialog(context, ctl);
        } else {
          Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
        }
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Icon(
                Icons.document_scanner,
                color: ColorsX.appBarColor,
                size: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                globalWidgets.myTextRaleway(context, "Classic Survey",
                    ColorsX.fullblack, 20, 10, 0, 0, FontWeight.w600, 17),
                globalWidgets.myTextRaleway(
                    context,
                    "Show all questions on one page",
                    ColorsX.subBlack,
                    20,
                    10,
                    0,
                    0,
                    FontWeight.w700,
                    13),
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
        Get.toNamed(Routes.ALL_SURVEYS);
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Icon(
                Icons.credit_card_sharp,
                color: ColorsX.appBarColor,
                size: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                globalWidgets.myTextRaleway(context, "Created Surveys",
                    ColorsX.fullblack, 20, 10, 0, 0, FontWeight.w600, 17),
                globalWidgets.myTextRaleway(
                    context,
                    "Show single question per page",
                    ColorsX.subBlack,
                    20,
                    10,
                    0,
                    0,
                    FontWeight.w700,
                    13),
              ],
            ),
          ],
        ),
      ),
    );
  }

  surveyTitleDialog(
    BuildContext context,
    TextEditingController ctl,
  ) {
    ctl.clear();
    return AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        // title: ,
        // desc: 'This will help people to find your survey.',//
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Add Title of Survey",
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "This will help people to find your survey.",
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            globalWidgets.myTextField(
                TextInputType.text, ctl, false, 'Write title here')
          ],
        ), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done',
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () async {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);

          if (ctl.text.isEmpty) {
            GlobalWidgets.showToast('Please give a title to your survey');
          } else {
            GlobalVariables.TITLE_OF_SURVEY = ctl.text;
            Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }
}
