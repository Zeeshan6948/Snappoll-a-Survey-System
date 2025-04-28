import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/card_form/card_form.dart';
import 'package:snap_poll/screens/edit_question_screen.dart';
import 'package:snap_poll/widget/drawer_widget.dart';
import 'package:snap_poll/widget/single_choice.dart';
import 'package:snap_poll/screens/form_layout_option.dart' as fll;
import '../global/colors.dart';
import '../global/size_config.dart';
import '../widget/yes_no.dart';

class CreateSurveyQuestion extends StatefulWidget {
  const CreateSurveyQuestion({Key? key}) : super(key: key);

  @override
  _CreateSurveyQuestionState createState() => _CreateSurveyQuestionState();
}

class _CreateSurveyQuestionState extends State<CreateSurveyQuestion> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController sectionAddCtl = TextEditingController();
  TextEditingController shortDescriptionCtl = TextEditingController();
  TextEditingController dynamicScaleValueCtl = TextEditingController();
  String _groupValue = 'Any';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => checkForAlreadySurvey(GlobalVariables.Fetched_Document));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Get.toNamed(Routes.MAIN_PAGE);
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: GlobalWidgets().myTextRaleway(
                      context,
                      "Unsaved Survey?".tr,
                      ColorsX.appBarColor,
                      0,
                      0,
                      0,
                      0,
                      FontWeight.w700,
                      24),
                  content: GlobalWidgets().myTextRaleway(
                      context,
                      "Are you sure you want to leave the survey?".tr,
                      ColorsX.appBarColor,
                      0,
                      0,
                      0,
                      0,
                      FontWeight.w500,
                      18),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: <Widget>[
                    TextButton(
                      child: GlobalWidgets().myTextRaleway(context, "Stay".tr,
                          ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); // Stay on the current screen
                      },
                    ),
                    TextButton(
                      child: GlobalWidgets().myTextRaleway(context, "Quit".tr,
                          ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                      onPressed: () {
                        GlobalVariables.currentIndex = 0;
                        ClearAllRecreatedSurvey();
                        Get.toNamed(Routes.MAIN_PAGE);
                      },
                    )
                  ],
                );
              });
        },
        child: Scaffold(
          body: body(context),
          floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 16.0, right: 8, left: 8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: ColorsX.appBarColor,
                    heroTag: 'section',
                    onPressed: () =>
                        createSectionDialog(context, sectionAddCtl),
                    icon: Icon(Icons.safety_divider),
                    label: globalWidgets.myTextRaleway(
                        context,
                        'Add Section'.tr,
                        ColorsX.white,
                        0,
                        0,
                        0,
                        0,
                        FontWeight.w500,
                        14),
                  ),
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
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: submitform(context),
                )
              ],
              leading: GestureDetector(
                onTap: () {
                  cancelDialog();
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

  void ClearAllRecreatedSurvey() {
    GlobalVariables.Fetched_Document = null;
    GlobalVariables.idOfSurvey = "";
    GlobalVariables.TITLE_OF_SURVEY = "";
    GlobalWidgets.pwdWidgets.clear();
    // GlobalVariables.sectionValue = "Select Section";
    GlobalVariables.SECTIONS_LIST.clear();
    GlobalVariables.LIST_OF_ALL_QUESTIONS.clear();
  }

  void cancelDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: GlobalWidgets().myTextRaleway(context, "Leave Survey?".tr,
                ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w700, 24),
            content: GlobalWidgets().myTextRaleway(
                context,
                "Are you sure you want to quit the survey?".tr,
                ColorsX.appBarColor,
                0,
                0,
                0,
                0,
                FontWeight.w500,
                18),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              TextButton(
                child: GlobalWidgets().myTextRaleway(context, "Stay".tr,
                    ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Stay on the current screen
                },
              ),
              TextButton(
                child: GlobalWidgets().myTextRaleway(context, "Quit".tr,
                    ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                onPressed: () {
                  GlobalVariables.currentIndex = 0;
                  ClearAllRecreatedSurvey();
                  Get.toNamed(Routes.MAIN_PAGE);
                },
              )
            ],
          );
        });
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(color: ColorsX.white),
      child: GlobalVariables.SECTIONS_LIST.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  const Icon(
                    Icons.assignment_add,
                    size: 50,
                    color: ColorsX.appBarColor,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  globalWidgets.myTextRaleway(
                      context,
                      // "Add Sections and Questions below!".tr,
                      "Add Sections below!".tr,
                      ColorsX.appBarColor,
                      5,
                      10,
                      10,
                      5,
                      FontWeight.w500,
                      18),
                ])
          : ListView.builder(
              itemCount: GlobalVariables.SECTIONS_LIST.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  GlobalVariables.sectionValue =
                      GlobalVariables.SECTIONS_LIST[index];
                  GlobalWidgets.pwdWidgetsTemp = [];
                  GlobalVariables.Swaping_Array = [];
                  GlobalVariables.Swaping_Array2 = [];
                  if (GlobalVariables.LIST_OF_ALL_QUESTIONS.isNotEmpty) {
                    for (int i = 0;
                        i < GlobalVariables.LIST_OF_ALL_QUESTIONS.length;
                        i++) {
                      if (GlobalVariables.LIST_OF_ALL_QUESTIONS[i]
                          .toString()
                          .contains(GlobalVariables.sectionValue)) {
                        GlobalWidgets.pwdWidgetsTemp
                            .add(GlobalWidgets.pwdWidgets[i]);
                        GlobalVariables.Swaping_Array.add(i);
                        GlobalVariables.Swaping_Array2.add(i);
                        Get.toNamed(Routes.CREATE_SURVEY_QUESTION_ADD);
                      }
                    }
                  } else {
                    GlobalWidgets.showToast('No Questions in Survey'.tr);
                  }
                },
                child: SizedBox(
                  height: SizeConfig.screenHeight * .08,
                  child: Card(
                      shadowColor: ColorsX.blackWithOpacity,
                      clipBehavior: Clip.hardEdge,
                      elevation: 1,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10,
                              top: SizeConfig.screenHeight * .01,
                              right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              globalWidgets.myTextCustomOneLine(
                                  context,
                                  (index + 1).toString(),
                                  ColorsX.appBarColor,
                                  0,
                                  0,
                                  0,
                                  0,
                                  FontWeight.w600,
                                  17),
                              Expanded(child: Container()),
                              globalWidgets.myTextCustomOneLine(
                                  context,
                                  GlobalVariables.SECTIONS_LIST[index].tr,
                                  ColorsX.appBarColor,
                                  0,
                                  0,
                                  0,
                                  0,
                                  FontWeight.w600,
                                  17),
                              Expanded(child: Container()),
                              GestureDetector(
                                  onTap: () {
                                    GlobalVariables.sectionValue =
                                        GlobalVariables.SECTIONS_LIST[index].tr;
                                    _modalSheet();
                                  },
                                  child: Icon(
                                    Icons.question_answer_outlined,
                                    color: ColorsX.appBarColor,
                                  )),
                            ],
                          ))),
                ),
              ),
            ),
      // child: GlobalWidgets.pwdWidgets.isEmpty
      //     ? Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //             const Icon(
      //               Icons.assignment_add,
      //               size: 50,
      //               color: ColorsX.appBarColor,
      //             ),
      //             const SizedBox(
      //               height: 40,
      //             ),
      //             globalWidgets.myTextRaleway(
      //                 context,
      //                 "Add Sections and Questions below!".tr,
      //                 ColorsX.appBarColor,
      //                 5,
      //                 10,
      //                 10,
      //                 5,
      //                 FontWeight.w500,
      //                 18),
      //           ])
      //     : ListView.builder(
      //         itemCount: GlobalWidgets.pwdWidgets.length,
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //         itemBuilder: (context, index) =>
      //             (GlobalWidgets.pwdWidgets[index]),
      //       ),
    );
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
            // if (GlobalVariables.idOfSurvey != "") {
            //   var documentId = GlobalVariables.idOfSurvey;
            //   final DocumentReference _temp;
            //   _temp = FirebaseFirestore.instance
            //       .collection('surveys')
            //       .doc(documentId);
            //   _temp.delete();
            // }
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
    GlobalVariables.SECTIONS_LIST.isEmpty
        ? GlobalWidgets.showToast('Please add a section first')
        : showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // ListTile(
                  //   leading: new Icon(Icons.download_done),
                  //   title: globalWidgets.myTextRaleway(context, 'Yes / No'.tr,
                  //       ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                  //   onTap: () {
                  //     Get.back();
                  //     GlobalVariables.QUESTION_TYPE = "Yes No";
                  //     Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                  //   },
                  // ),
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
                  // ListTile(
                  //   leading: new Icon(Icons.linear_scale),
                  //   title: globalWidgets.myTextRaleway(context, 'Linear Scale',
                  //       ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                  //   onTap: () {
                  //     // Get.back();
                  //     GlobalVariables.QUESTION_TYPE = "Linear Scale";
                  //     dynamicScaleDialog(context, dynamicScaleValueCtl);
                  //   },
                  // ),
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
                  ListTile(
                    leading: new Icon(Icons.linear_scale),
                    title: globalWidgets.myTextRaleway(
                        context,
                        'Multiple Rating',
                        ColorsX.black,
                        0,
                        0,
                        0,
                        0,
                        FontWeight.w400,
                        14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Multiple Rating";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.location_on),
                    title: globalWidgets.myTextRaleway(context, 'Map',
                        ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
                    onTap: () {
                      Get.back();
                      GlobalVariables.QUESTION_TYPE = "Map";
                      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
                    },
                  )
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
          if (sectionAddCtl.text == "") {
            GlobalWidgets.showToast('Please fill all the information');
          } else {
            debugPrint('OnClcik');
            GlobalWidgets.hideKeyboard(context);
            _addSectionToList(context);
          }
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

  checkForAlreadySurvey(Map<String, dynamic>? fetchDoc) {
    if (GlobalVariables.Fetched_Document != null) {
      List<dynamic> listOfAllQuestions = [];
      List<dynamic> listOfAllSections = [];
      List<dynamic> listOfAllViewers = [];
      List<dynamic> listOfAllMaintainers = [];
      listOfAllQuestions = fetchDoc?['questions'];
      listOfAllSections = fetchDoc?['sections'];
      listOfAllViewers = fetchDoc?['viewers'];
      listOfAllMaintainers = fetchDoc?['maintainers'];
      if (listOfAllQuestions.length == GlobalWidgets.pwdWidgets.length) {
        GlobalVariables.Fetched_Document = null;
        EasyLoading.instance.maskType = EasyLoadingMaskType.none;
        GlobalWidgets.hideProgressLoader();
        return;
      }
      if (listOfAllViewers.isNotEmpty) {
        for (int i = 0; i < listOfAllViewers.length; i++) {
          setState(() {
            GlobalVariables.VIEWER_LIST.add(listOfAllViewers[i]);
          });
        }
      }
      if (listOfAllMaintainers.isNotEmpty) {
        for (int i = 0; i < listOfAllMaintainers.length; i++) {
          setState(() {
            GlobalVariables.MAINTAINER_LIST.add(listOfAllMaintainers[i]);
          });
        }
      }
      if (GlobalVariables.idOfSurvey != '')
        GlobalVariables.TITLE_OF_SURVEY = fetchDoc?['title'];
      String QuestionType;
      // listOfAllSections.removeAt(0);
      if (GlobalWidgets.pwdWidgets.length == 0) {
        for (int i = 0; i < listOfAllSections.length; i++) {
          GlobalVariables.SECTIONS_LIST.add(listOfAllSections[i].toString());
        }
      }
      QuestionType =
          listOfAllQuestions[GlobalWidgets.pwdWidgets.length]['question_type'];
      GlobalVariables.QUESTION_TYPE = QuestionType;
      GlobalVariables.sectionValue =
          listOfAllQuestions[GlobalWidgets.pwdWidgets.length]['section'];
      Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
    }
  }
}
