import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/card_form/card_form.dart';
import 'package:snap_poll/widget/drawer_widget.dart';
import 'package:snap_poll/widget/single_choice.dart';
import 'package:snap_poll/screens/form_layout_option.dart' as fll;
import '../global/colors.dart';
import '../global/size_config.dart';
import '../widget/yes_no.dart';

class ChooseAccess extends StatefulWidget {
  const ChooseAccess({Key? key}) : super(key: key);

  @override
  _ChooseAccessState createState() => _ChooseAccessState();
}

class _ChooseAccessState extends State<ChooseAccess> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController maintainerCtl = TextEditingController();
  TextEditingController viewerCtl = TextEditingController();
  String _groupValue = 'Any';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => checkForAlreadySurvey(GlobalVariables.Fetched_Document));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      // floatingActionButton: Container(
      //   padding: EdgeInsets.only(bottom: 16.0, right: 8, left: 8),
      //   child: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         FloatingActionButton.extended(
      //           backgroundColor: ColorsX.appBarColor,
      //           heroTag: 'section',
      //           onPressed: () =>
      //               createSectionDialog(context, body(context)),
      //           icon: Icon(Icons.save),
      //           label: globalWidgets.myTextRaleway(
      //               context,
      //               'Submit'.tr,
      //               ColorsX.white,
      //               0,
      //               0,
      //               0,
      //               0,
      //               FontWeight.w500,
      //               14),
      //         ),
      //         // FloatingActionButton.extended(
      //         //   backgroundColor: ColorsX.appBarColor,
      //         //   heroTag: 'bottom_sheet',
      //         //   onPressed: _modalSheet,
      //         //   icon: Icon(Icons.question_answer_outlined),
      //         //   label: globalWidgets.myTextRaleway(
      //         //       context,
      //         //       'Add Questions'.tr,
      //         //       ColorsX.white,
      //         //       0,
      //         //       0,
      //         //       0,
      //         //       0,
      //         //       FontWeight.w500,
      //         //       14),
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.centerFloat,
      // drawer: DrawerWidget(context),
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: ColorsX.appBarColor,
          centerTitle: true,
          title: globalWidgets.myText(context, ''
              'Assign Roles'.tr, ColorsX.white, 0, 0, 0, 0, FontWeight.w500, 18),
          actions: [
            Visibility(
              visible: true,
              child: Align(
                alignment: Alignment.center,
                child: submitForm(context),
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () {
              // cancelDialog();
              Get.back();
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
    );
  }

  void ClearAllRecreatedSurvey() {
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
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[

          globalWidgets.myText(context, 'Who can have the access to this survey?'.tr,
              ColorsX.black, 10, 10, 10, 0, FontWeight.w400, 16),
          Container(
            // height: SizeConfig.screenHeight * .25,
            child: Card(
                shadowColor: ColorsX.blackWithOpacity,
                clipBehavior: Clip.hardEdge,
                elevation: 1,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 10,
                        top: SizeConfig.screenHeight * .01,
                        right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        globalWidgets.myText(context, 'Choose Maintainer'.tr,
                            ColorsX.myblack, 10, 10, 10, 0, FontWeight.w700, 18),
                        globalWidgets.myText(context, 'A maintainer can view and edit your survey before it is being published.'.tr,
                            ColorsX.subBlack, 5, 10, 10, 10, FontWeight.w400, 16),
                        globalWidgets.myTextField(TextInputType.emailAddress, maintainerCtl, false, 'Email address'),
                        addMaintainerButton(context),
                        SizedBox(height: 10,),
                        Visibility(
                          visible: GlobalVariables.MAINTAINER_LIST.isEmpty ? false : true,
                          child: Wrap(
                            spacing: 2.0, // gap between adjacent chips
                            // runSpacing: 1.0, // gap between lines
                            children: <Widget>[
                              for (int index = 0 ; index < GlobalVariables.MAINTAINER_LIST.length; index++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      removeMaintainer(index);
                                    },
                                    child: Chip(
                                      avatar: CircleAvatar(backgroundColor: ColorsX.appBarColor,
                                          child: Icon(Icons.clear, color: ColorsX.white,)),
                                      label: globalWidgets.myText(context,
                                          GlobalVariables.MAINTAINER_LIST[index],
                                          ColorsX.subBlack, 0, 0, 0, 0, FontWeight.w400, 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ))),
          ),
          Container(
            // height: SizeConfig.screenHeight * .25,
            child: Card(
                shadowColor: ColorsX.blackWithOpacity,
                clipBehavior: Clip.hardEdge,
                elevation: 1,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 10,
                        top: SizeConfig.screenHeight * .01,
                        right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        globalWidgets.myText(context, 'Choose Viewer'.tr,
                            ColorsX.myblack, 10, 10, 10, 0, FontWeight.w700, 18),
                        globalWidgets.myText(context, 'A viewer can view your survey but cannot edit it before it is being published.'.tr,
                            ColorsX.subBlack, 5, 10, 10, 10, FontWeight.w400, 16),
                        globalWidgets.myTextField(TextInputType.emailAddress, viewerCtl, false, 'Email address'),
                        addViewerButton(context),
                        SizedBox(height: 10,),
                        Visibility(
                          visible: GlobalVariables.VIEWER_LIST.isEmpty ? false : true,
                          child: Wrap(
                            spacing: 2.0, // gap between adjacent chips
                            // runSpacing: 1.0, // gap between lines
                            children: <Widget>[
                              for (int index = 0 ; index < GlobalVariables.VIEWER_LIST.length; index++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      removeViewer(index);
                                    },
                                    child: Chip(
                                      avatar: CircleAvatar(backgroundColor: ColorsX.appBarColor,
                                          child: Icon(Icons.clear, color: ColorsX.white,)),
                                      label: globalWidgets.myText(context,
                                          GlobalVariables.VIEWER_LIST[index],
                                          ColorsX.subBlack, 0, 0, 0, 0, FontWeight.w400, 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ))),
          ),
        ],
      )
    );
  }

  addMaintainerButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(maintainerCtl.text.isEmpty){
          GlobalWidgets.showToast('Empty');
        }
        else{
          GlobalWidgets.hideKeyboard(context);
          if(GlobalVariables.VIEWER_LIST.contains(maintainerCtl.text.trim())){
            GlobalWidgets.showToast('Already added in viewer list'.tr);
          }else{
            if(GlobalVariables.MAINTAINER_LIST.isEmpty){
              setState(() {
                GlobalVariables.MAINTAINER_LIST.add(maintainerCtl.text.trim());
              });
              maintainerCtl.clear();
            }
            else if(GlobalVariables.MAINTAINER_LIST.contains(maintainerCtl.text)){
              GlobalWidgets.showToast('Already added'.tr);
            }
            else if(preferences.get('email') == maintainerCtl.text){
              GlobalWidgets.showToast('You cannot be maintainer or viewer'.tr);
            }
            else{
              setState(() {
                GlobalVariables.MAINTAINER_LIST.add(maintainerCtl.text.trim());
              });
              maintainerCtl.clear();
            }
          }
        }
      },
      child: Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: ColorsX.appBarColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: globalWidgets.myTextRaleway(context, "Add Maintainer".tr,
                ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }
  addViewerButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(viewerCtl.text.isEmpty){
          GlobalWidgets.showToast('Empty');
        }
        else{
          GlobalWidgets.hideKeyboard(context);
          if(GlobalVariables.MAINTAINER_LIST.contains(viewerCtl.text.trim())){
            GlobalWidgets.showToast('Already added in maintainer list'.tr);
          }else{
            if(GlobalVariables.VIEWER_LIST.isEmpty){
              setState(() {
                GlobalVariables.VIEWER_LIST.add(viewerCtl.text.trim());
              });
              viewerCtl.clear();
            }
            else if(GlobalVariables.VIEWER_LIST.contains(viewerCtl.text)){
              GlobalWidgets.showToast('Already added'.tr);
            }
            else if(preferences.get('email') == viewerCtl.text){
              GlobalWidgets.showToast('You cannot be maintainer or viewer'.tr);
            }
            else{
              setState(() {
                GlobalVariables.VIEWER_LIST.add(viewerCtl.text.trim());
              });
              viewerCtl.clear();
            }
          }
        }
      },
      child: Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: ColorsX.appBarColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: globalWidgets.myTextRaleway(context, "Add Viewer".tr,
                ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

  submitForm(BuildContext context) {
    return Visibility(
      visible: GlobalWidgets.pwdWidgets.length != 0,
      child: GestureDetector(
        onTap: () async {
          debugPrint('submit tapped');
          GlobalWidgets.showProgressLoader('');
          var collection = FirebaseFirestore.instance.collection('temp_surveys');
          if (GlobalVariables.idOfSurvey != "") {
            var documentId = GlobalVariables.idOfSurvey;
            documentId=documentId.split('/')[1];
            final DocumentReference _temp;
            _temp = FirebaseFirestore.instance
                .collection('temp_surveys')
                .doc(documentId);
            _temp.delete();
          }
          Map<String, dynamic> map = {
            'title': GlobalVariables.TITLE_OF_SURVEY,
            'short_description': GlobalVariables.descriptionCTLValue,
            'questions': GlobalVariables.LIST_OF_ALL_QUESTIONS,
            'sections': GlobalVariables.SECTIONS_LIST,
            'user_id': GlobalVariables.userId,
            'maintainers': GlobalVariables.MAINTAINER_LIST,
            'viewers': GlobalVariables.VIEWER_LIST,
          };
          var docRef = await collection.add(map);
          var documentId = docRef.id;

          GlobalWidgets.hideProgressLoader();
          if (documentId.toString().isEmpty) {
            GlobalWidgets.showToast('Survey not saved. Try again'.tr);
          } else {
            var resultsCollectionRef = FirebaseFirestore.instance
                .collection('temp_surveys/$documentId/results');
            await resultsCollectionRef
                .doc('questionsID')
                .set({'questions': GlobalVariables.LIST_OF_ALL_QUESTIONS});
            GlobalVariables.idOfSurvey = "temp/"+documentId;
            GlobalVariables.TITLE_OF_SURVEY = "";
            GlobalWidgets.pwdWidgets.clear;
            // shortDescriptionCtl.clear();
            GlobalVariables.SECTIONS_LIST.clear();
            GlobalVariables.LIST_OF_ALL_QUESTIONS.clear();
            Get.toNamed(Routes.QRCODE_SCREEN);
          }
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
            Get.toNamed(Routes.CHOOSE_ACCESS);
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
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


  checkForAlreadySurvey(Map<String, dynamic>? fetchDoc) {
    if (GlobalVariables.Fetched_Document != null) {
      List<dynamic> listOfAllQuestions = [];
      List<dynamic> listOfAllSections = [];
      listOfAllQuestions = fetchDoc?['questions'];
      listOfAllSections = fetchDoc?['sections'];
      if (listOfAllQuestions.length == GlobalWidgets.pwdWidgets.length) {
        GlobalVariables.Fetched_Document = null;
        return;
      }
      if(GlobalVariables.idOfSurvey != '')
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
    else{
      List<String> maintainerAfterRemovingDuplicate = GlobalVariables.MAINTAINER_LIST.toSet().toList();
      GlobalVariables.MAINTAINER_LIST.clear();
      setState(() {
        GlobalVariables.MAINTAINER_LIST.addAll(maintainerAfterRemovingDuplicate);
      });
      List<String> viewerAfterRemovingDuplicate = GlobalVariables.VIEWER_LIST.toSet().toList();
      GlobalVariables.VIEWER_LIST.clear();
      setState(() {
        GlobalVariables.VIEWER_LIST.addAll(viewerAfterRemovingDuplicate);
      });
    }
  }

  removeMaintainer(int index) {
    if(GlobalVariables.MAINTAINER_LIST.isNotEmpty){
      debugPrint("here click");
      setState(() {
        GlobalVariables.MAINTAINER_LIST.remove(GlobalVariables.MAINTAINER_LIST[index]);
      });
    }else{

    }
  }

  removeViewer(int index) {
    if(GlobalVariables.VIEWER_LIST.isNotEmpty){
      setState(() {
        GlobalVariables.VIEWER_LIST.remove(GlobalVariables.VIEWER_LIST[index]);
      });
    }else{

    }
  }
}
