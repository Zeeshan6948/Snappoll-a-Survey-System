import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/card_form/card_form.dart';
import 'package:snap_poll/widget/drawer_widget.dart';
import 'package:snap_poll/widget/single_choice.dart';
import 'package:snap_poll/screens/form_layout_option.dart' as fll;

import '../../global/colors.dart';
import '../../global/size_config.dart';

class CreateSurveyQuestionAdd extends StatefulWidget {
  const CreateSurveyQuestionAdd({Key? key}) : super(key: key);

  @override
  _CreateSurveyQuestionAddState createState() =>
      _CreateSurveyQuestionAddState();
}

class _CreateSurveyQuestionAddState extends State<CreateSurveyQuestionAdd> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController sectionAddCtl = TextEditingController();
  TextEditingController shortDescriptionCtl = TextEditingController();
  TextEditingController dynamicScaleValueCtl = TextEditingController();
  String _groupValue = 'Any';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Get.toNamed(Routes.MAIN_PAGE);
          reseting_All_questions();
          Get.back();
          return false;
        },
        child: Scaffold(
          body: body(context),
          floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 16.0, right: 8, left: 8),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FloatingActionButton.extended(
                  //   backgroundColor: ColorsX.appBarColor,
                  //   heroTag: 'section',
                  //   onPressed: () =>
                  //       createSectionDialog(context, sectionAddCtl),
                  //   icon: Icon(Icons.safety_divider),
                  //   label: globalWidgets.myTextRaleway(
                  //       context,
                  //       'Add Section'.tr,
                  //       ColorsX.white,
                  //       0,
                  //       0,
                  //       0,
                  //       0,
                  //       FontWeight.w500,
                  //       14),
                  // ),
                  // FloatingActionButton.extended(
                  //   backgroundColor: ColorsX.appBarColor,
                  //   heroTag: 'bottom_sheet',
                  //   onPressed: _modalSheet,
                  //   icon: Icon(Icons.question_answer_outlined),
                  //   label: globalWidgets.myTextRaleway(
                  //       context,
                  //       'Add Questions'.tr,
                  //       ColorsX.white,
                  //       0,
                  //       0,
                  //       0,
                  //       0,
                  //       FontWeight.w500,
                  //       14),
                  // ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          // drawer: DrawerWidget(context),
          key: _scaffoldKey,
          appBar: AppBar(
              backgroundColor: ColorsX.appBarColor,
              centerTitle: true,
              title: Text(GlobalVariables.TITLE_OF_SURVEY),
              // actions: [
              //   Align(
              //     alignment: Alignment.center,
              //     child: submitform(context),
              //   )
              // ],
              leading: GestureDetector(
                onTap: () {
                  // Get.toNamed(Routes.MAIN_PAGE);
                  Get.back();
                  reseting_All_questions();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorsX.white,
                  size: 18,
                ),
              )
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.menu_rounded,
              //     color: ColorsX.white,
              //   ),
              //   onPressed: () => _scaffoldKey.currentState
              //       ?.openDrawer(), //Scaffold.of(context).openDrawer(),
              // ),
              ),
        ));
  }

  body(BuildContext context) {
    // return Container(
    //   width: SizeConfig.screenWidth,
    //   height: SizeConfig.screenHeight,
    //   decoration: const BoxDecoration(color: ColorsX.white),
    //   child: GlobalWidgets.pwdWidgets.isEmpty
    //       ? Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //               const Icon(
    //                 Icons.assignment_add,
    //                 size: 50,
    //                 color: ColorsX.appBarColor,
    //               ),
    //               const SizedBox(
    //                 height: 40,
    //               ),
    //               globalWidgets.myTextRaleway(
    //                   context,
    //                   "Add Questions below!".tr,
    //                   ColorsX.appBarColor,
    //                   5,
    //                   10,
    //                   10,
    //                   5,
    //                   FontWeight.w500,
    //                   18),
    //             ])
    //       : ListView.builder(
    //           itemCount: GlobalWidgets.pwdWidgetsTemp.length,
    //           scrollDirection: Axis.vertical,
    //           shrinkWrap: true,
    //           itemBuilder: (context, index) =>
    //               (GlobalWidgets.pwdWidgetsTemp[index]),
    //         ),
    // );
    return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: ReorderableListView(
          children: <Widget>[
            for (int index = 0;
                index < GlobalWidgets.pwdWidgetsTemp.length;
                index++)
              ListTile(
                key: Key('$index'),
                tileColor:
                    index.isOdd ? Colors.lightBlue : Colors.lightBlue.shade100,
                // leading: Text('${index + 1})'),
                title: ReorderableDragStartListener(
                  index: index,
                  child: GlobalWidgets.pwdWidgetsTemp[index],
                ),
                minLeadingWidth: 1,
                minVerticalPadding: 1,
              )
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex--;
              }
              Widget item = GlobalWidgets.pwdWidgetsTemp.removeAt(oldIndex);
              var val = GlobalVariables.Swaping_Array2.removeAt(oldIndex);
              GlobalWidgets.pwdWidgetsTemp.insert(newIndex, item);
              GlobalVariables.Swaping_Array2.insert(newIndex, val);
            });
          },
        ));
  }

  submitform(BuildContext context) {
    return Visibility(
      visible: GlobalWidgets.pwdWidgets.length != 0,
      child: GestureDetector(
        onTap: () async {
          debugPrint('submit tapped');
          shortDescriptionDialog(context, shortDescriptionCtl);
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(left: 20, right: 20, top: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: ColorsX.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
              child: globalWidgets.myTextRaleway(context, "Submit".tr,
                  ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 17),
            ),
          ),
        ),
      ),
    );
  }

  reseting_All_questions() {
    if (GlobalWidgets.pwdWidgetsTemp.length < 2) return;
    for (int i = 0; i < GlobalVariables.Swaping_Array.length; i++) {
      GlobalWidgets.pwdWidgets[GlobalVariables.Swaping_Array[i]] =
          GlobalWidgets.pwdWidgetsTemp[i];
      var questiontemp = GlobalVariables
          .LIST_OF_ALL_QUESTIONS[GlobalVariables.Swaping_Array[i]];
      if (GlobalVariables.Swaping_Array2[i] != -1) {
        GlobalVariables
                .LIST_OF_ALL_QUESTIONS[GlobalVariables.Swaping_Array[i]] =
            GlobalVariables
                .LIST_OF_ALL_QUESTIONS[GlobalVariables.Swaping_Array2[i]];
        GlobalVariables
                .LIST_OF_ALL_QUESTIONS[GlobalVariables.Swaping_Array2[i]] =
            questiontemp;
        int ind = GlobalVariables.Swaping_Array2.indexWhere((Swaping_Array2) =>
            Swaping_Array2 == GlobalVariables.Swaping_Array[i]);
        GlobalVariables.Swaping_Array2[ind] = -1;
      }
    }
  }

  shortDescriptionDialog(
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
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Add Short Description".tr,
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(context, "", ColorsX.subBlack, 10, 0, 0,
                20, FontWeight.w400, 12),
            globalWidgets.myTextField(
                TextInputType.text, ctl, false, 'Write description here'.tr),
          ],
        ),
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done'.tr,
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () async {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          if (ctl.text.isEmpty) {
            GlobalWidgets.showToast('Please give a short description'.tr);
          } else {
            GlobalVariables.descriptionCTLValue = ctl.text.toString();
            Get.toNamed(Routes.CHOOSE_ACCESS);
            // GlobalWidgets.showProgressLoader('');
            // var collection = FirebaseFirestore.instance.collection('surveys');
            // Map<String, dynamic> map = {
            //   'title': GlobalVariables.TITLE_OF_SURVEY,
            //   'short_description': shortDescriptionCtl.text,
            //   'questions': GlobalVariables.LIST_OF_ALL_QUESTIONS,
            //   'sections': GlobalVariables.SECTIONS_LIST,
            //   'user_id': GlobalVariables.userId
            // };
            // var docRef = await collection.add(map);
            // var documentId = docRef.id;
            //
            // GlobalWidgets.hideProgressLoader();
            // if (documentId.toString().isEmpty) {
            //   GlobalWidgets.showToast('Survey not saved. Try again'.tr);
            // } else {
            //   var resultsCollectionRef = FirebaseFirestore.instance
            //       .collection('surveys/$documentId/results');
            //   await resultsCollectionRef
            //       .doc('questionsID')
            //       .set({'questions': GlobalVariables.LIST_OF_ALL_QUESTIONS});
            //   GlobalVariables.idOfSurvey = documentId;
            //   GlobalVariables.TITLE_OF_SURVEY = "";
            //   GlobalWidgets.pwdWidgets.clear;
            //   shortDescriptionCtl.clear();
            //   GlobalVariables.SECTIONS_LIST.clear();
            //   GlobalVariables.LIST_OF_ALL_QUESTIONS.clear();
            //   Get.toNamed(Routes.QRCODE_SCREEN);
            // }
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  _modalSheet() {
    GlobalVariables.SECTIONS_LIST.length == 1
        ? GlobalWidgets.showToast('Please add a section first')
        : showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: new Icon(Icons.download_done),
                    title: globalWidgets.myTextRaleway(context, 'Yes / No'.tr,
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Yes No";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.radio),
                    title: globalWidgets.myTextRaleway(context, 'Single Choice',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Single Choice";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                      // GlobalWidgets.pwdWidgets.add(SingleChoice());
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.check_box),
                    title: globalWidgets.myTextRaleway(
                        context,
                        'Multiple Choice',
                        ColorsX.black,
                        0,
                        0,
                        0,
                        0,
                        FontWeight.w400,
                        14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Multiple Choice";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.article),
                    title: globalWidgets.myTextRaleway(context, 'Open Text',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Open Text";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.trip_origin),
                    title: globalWidgets.myTextRaleway(context, 'Range',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Range";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.linear_scale),
                    title: globalWidgets.myTextRaleway(context, 'Linear Scale',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      // Get.back();
                      GlobalVariables.QUESTION_TYPE = "Linear Scale";
                      dynamicScaleDialog(context, dynamicScaleValueCtl);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.star),
                    title: globalWidgets.myTextRaleway(context, 'Rating',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Rating";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                ],
              );
            });
  }

  createSectionDialog(
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
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Add Section".tr,
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "Create section to categorise the question".tr,
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            globalWidgets.myTextField(
                TextInputType.text, ctl, false, 'Write section name here'.tr),
          ],
        ),
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done'.tr,
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          _addSectionToList(context);
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  dynamicScaleDialog(
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
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Add Value".tr, ColorsX.black,
                10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "Add maximum value for scale rating".tr,
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            globalWidgets.myTextField(
                TextInputType.number, ctl, false, 'In numbers'.tr),
          ],
        ),
        btnCancelOnPress: () {
          // Get.back();
        },
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done'.tr,
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          if (ctl.text.isEmpty)
            GlobalWidgets.showToast('Please type maximum value'.tr);
          else {
            GlobalVariables.dynamicScaleValue = int.parse(ctl.text);
            Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  _addSectionToList(BuildContext context) {
    if (GlobalVariables.SECTIONS_LIST.isEmpty) {
      GlobalVariables.SECTIONS_LIST.add(sectionAddCtl.text);
      // GlobalWidgets.successDialog(
      //     'Done', 'Section Created Successfully', context);
    } else if (GlobalVariables.SECTIONS_LIST.contains(sectionAddCtl.text)) {
      GlobalWidgets.showToast('This section already exists'.tr);
    } else {
      GlobalVariables.SECTIONS_LIST.add(sectionAddCtl.text);
      // GlobalWidgets.successDialog(
      //     'Done', 'Section Created Successfully', context);
    }
  }
}
