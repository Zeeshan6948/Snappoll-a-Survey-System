import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';

import '../../../global/colors.dart';
import '../../../global/size_config.dart';

class EditYNQuestionScreen extends StatefulWidget {
  const EditYNQuestionScreen({Key? key}) : super(key: key);
  @override
  _EditYNQuestionScreenState createState() => _EditYNQuestionScreenState();
}

class _EditYNQuestionScreenState extends State<EditYNQuestionScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController questionCtl = TextEditingController();
  String _groupValue = 'Any';
  RxString questionText = "Do you like this app?".obs;
  String section = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget question(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() => globalWidgets.myTextRaleway(context, questionText.value,
                Colors.black, 10, 10, 10, 10, FontWeight.w500, 17)),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                openEditQuestionDilog(context, questionCtl, 'Edit question',
                    'Write a question you want to ask');
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.edit,
                  //  color: ColorsX.appBarColor,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        RadioListTile<String>(
          value: 'Yes',
          groupValue: _groupValue,
          title: globalWidgets.myTextRaleway(
              context, 'Yes', Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
          onChanged: (newValue) => setState(() => _groupValue = newValue!),
          activeColor: Colors.red,
          selected: false,
        ),
        RadioListTile<String>(
          value: 'No',
          groupValue: _groupValue,
          title: globalWidgets.myTextRaleway(
              context, 'No', Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
          onChanged: (newValue) => setState(() => _groupValue = newValue!),
          activeColor: Colors.red,
          selected: false,
        ),
      ],
    );
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

          questionText.value =
              questionCtl.text.isEmpty ? questionText.value : questionCtl.text;
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  saveQuestionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        yesNoQuestionSave(context);
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

  yesNoQuestionSave(BuildContext context) {
    if (questionText.value == 'Do you like this app?') {
      GlobalWidgets.showToast('Please fill all the information');
    } else {
      Map<String, dynamic> map = {
        'question_type': 'Yes No',
        'question': questionText.value,
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }
}
