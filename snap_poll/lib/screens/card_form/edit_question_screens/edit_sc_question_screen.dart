import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';

class EditSCQuestionScreen extends StatefulWidget {
  const EditSCQuestionScreen({Key? key}) : super(key: key);
  @override
  _EditSCQuestionScreenState createState() => _EditSCQuestionScreenState();
}

class _EditSCQuestionScreenState extends State<EditSCQuestionScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController questionCtl = TextEditingController();
  String _groupValue = 'Any';
  RxString questionText = "What do you think about this question?".obs;
  String section = Get.arguments;
  List<RadioListTileModel> radioListTiles = []; // List to hold checkbox models
  int counter = 0; // Counter for unique checkbox IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight * .15,
              decoration: BoxDecoration(color: ColorsX.appBarColor),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConfig.screenHeight * .16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [question(context), saveQuestionButton(context)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            radioListTiles.add(RadioListTileModel(
              // Create a new RadioListTile model and add it to the list
              id: counter.obs,
              title: "Edit option".obs,
            ));
            counter++;
          });
        },
      ),
    );
  }

  Widget question(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            globalWidgets.myTextRaleway(context, questionText.value.toString(),
                Colors.black, 10, 10, 10, 10, FontWeight.w500, 17),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                openEditQuestionDilog(context, questionCtl, 'Edit question',
                    'Write a question you want to ask');
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.edit,
                  color: ColorsX.appBarColor,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: radioListTiles.length,
          itemBuilder: (context, index) {
            return RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.leading,
              value: radioListTiles[index].title.value,
              groupValue: _groupValue,
              activeColor: Colors.red,
              selected: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(radioListTiles[index].title.value),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      openEditOptionDilog(
                          context,
                          radioListTiles[index].textCtl,
                          'Edit Option',
                          'Edit your first option',
                          index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.edit,
                        //   color: ColorsX.appBarColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      openDeleteDilog(context, index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.delete,
                        // color: ColorsX.appBarColor,
                      ),
                    ),
                  ),
                ],
              ),
              onChanged: (newValue) => setState(() => _groupValue = newValue!),
            );
          },
        ),
      ],
    );
  }

  openDeleteDilog(BuildContext context, int index) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        title: "Delete",
        desc: "Delete this option", //
        body: globalWidgets.myTextRaleway(
            context,
            'Delete this option?',
            Colors.black,
            0,
            0,
            0,
            0,
            FontWeight.w400,
            17), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Delete',
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () {
          debugPrint('OnClcik');
          setState(() {
            radioListTiles.removeAt(index);
            counter--;
            for (RadioListTileModel c in radioListTiles) {
              c.id = radioListTiles.indexOf(c).obs;
            }
          });
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  openEditOptionDilog(BuildContext context, TextEditingController ctl,
      String title, String description, int index) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        title: title,
        desc: description, //
        body: globalWidgets.myTextField(TextInputType.text, ctl, false,
            'Edit here'), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Edit',
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          radioListTiles[index].title.value =
              radioListTiles[index].textCtl.text;
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  openEditQuestionDilog(BuildContext context, TextEditingController ctl,
      String title, String description) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        title: title,
        desc: description, //
        body: globalWidgets.myTextField(TextInputType.text, ctl, false,
            'Edit here'), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Edit',
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          questionText.value = questionCtl.text;
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  saveQuestionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        singleChoiceQuestionSave(context);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: ColorsX.buttonBackground,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: globalWidgets.myTextRaleway(context, "SAVE QUESTION",
                ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

  singleChoiceQuestionSave(BuildContext context) {
    Map<String, dynamic> map = {
      'question_type': 'Single Choice',
      'question': questionText.value,
      'count': counter,
    };
    for (RadioListTileModel c in radioListTiles) {
      map["option ${c.id}"] = c.title.value;
      // ids have to be separated for counter sometimes later
    }
    GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
    debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
    setState(() {
      GlobalWidgets.pwdWidgets.add(question(context));
    });
    Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
  }
}

class RadioListTileModel {
  RxInt id;
  RxString title;
  TextEditingController textCtl = TextEditingController();

  RadioListTileModel({required this.id, required this.title});
}
