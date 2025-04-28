import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';

import '../global/colors.dart';
import '../routes/app_pages.dart';

class Templates extends StatelessWidget {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController controller = TextEditingController();
  // const Templates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: SizeConfig.screenWidth * .02),
      child: ListView(
        children: [
          Wrap(
            spacing: 1,
            children: <Widget>[
              for (int index = 0;
                  index < GlobalVariables.templatesList.length;
                  index++)
                GestureDetector(
                  onTap: () {
                    surveyTitleDialog(context, controller, index);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: SizeConfig.screenHeight * .35,
                      width: SizeConfig.screenWidth * .45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * .10,
                            width: SizeConfig.screenWidth * .20,
                            margin: EdgeInsets.only(top: 10),
                            child: Image.asset('assets/images/uni_logo.png'),
                          ),
                          globalWidgets.myText(
                              context,
                              '${GlobalVariables.templatesList[index]["title"]}',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              15),
                          globalWidgets.myTextCustom(
                              context,
                              '${GlobalVariables.templatesList[index]["short_description"]}',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              13),
                          globalWidgets.myText(
                              context,
                              '${GlobalVariables.templatesList[index]["questions"].length} Questions  |  '
                              '${GlobalVariables.templatesList[index]["sections"].length} Sections',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              12),
                          Expanded(child: Container()),
                          Visibility(
                            visible: true,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: ColorsX.appBarColor),
                              ),
                              child: globalWidgets.myText(
                                  context,
                                  'Preview'.tr,
                                  ColorsX.appBarColor,
                                  3,
                                  10,
                                  10,
                                  3,
                                  FontWeight.w500,
                                  14),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: ColorsX.appBarColor),
                            ),
                            child: globalWidgets.myText(
                                context,
                                'Use Template'.tr,
                                ColorsX.appBarColor,
                                3,
                                10,
                                10,
                                3,
                                FontWeight.w500,
                                14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  surveyTitleDialog(
      BuildContext context, TextEditingController ctl, int index) {
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
            globalWidgets.myTextRaleway(context, "Add Title of Survey".tr,
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "This will help people to find your survey.".tr,
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            globalWidgets.myTextField(
                TextInputType.text, ctl, false, 'Write title here'.tr)
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
            GlobalWidgets.showToast('Please give a title to your survey'.tr);
          } else {
            GlobalVariables.TITLE_OF_SURVEY = ctl.text;
            // GlobalVariables.idOfSurvey = "${GlobalVariables.templatesList[index].reference.id}";
            // debugPrint(GlobalVariables.idOfSurvey);
            debugPrint(GlobalVariables.TITLE_OF_SURVEY);
            DocumentSnapshot docRef = GlobalVariables.templatesList[index];
            GlobalVariables.Fetched_Document =
                docRef.data() as Map<String, dynamic>?;
            GlobalVariables.roleType = 'admin';
            EasyLoading.instance.maskColor = Colors.white.withOpacity(1);
            EasyLoading.instance.maskType = EasyLoadingMaskType.custom;
            GlobalWidgets.showProgressLoader("Loading Survey");
            Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }
}
