import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_widgets.dart';

import '../global/colors.dart';

class SingleChoice extends StatefulWidget {
  const SingleChoice({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleChoiceState();
  }
}

class _SingleChoiceState extends State<SingleChoice> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController questionCtl = TextEditingController();
  TextEditingController optionOneCtl = TextEditingController();
  TextEditingController optionTwoCtl = TextEditingController();
  TextEditingController optionThreeCtl = TextEditingController();
  String _groupValue = 'Any';
  RxString questionText = "What do you think about this question?".obs;
  RxString optionOneText = "This is option one".obs;
  RxString optionTwoText = "This is option two".obs;
  RxString optionThreeText = "This is option three".obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() => globalWidgets.myTextRaleway(context, questionText.value,
                Colors.black, 10, 10, 10, 10, FontWeight.w500, 17)),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                openEditQuestionDilog(context, questionCtl, 'Edit question',
                    'Write a question you want to ask');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Icon(
                  Icons.edit,
                  color: ColorsX.appBarColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        RadioListTile<String>(
          value: 'one',
          groupValue: _groupValue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => globalWidgets.myTextRaleway(context, optionOneText.value,
                    Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  openEditQuestionDilog(context, optionOneCtl, 'Edit Option',
                      'Edit your first option');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Icon(
                    Icons.edit,
                    color: ColorsX.appBarColor,
                  ),
                ),
              ),
            ],
          ),
          onChanged: (newValue) => setState(() => _groupValue = newValue!),
          activeColor: Colors.red,
          selected: false,
        ),
        RadioListTile<String>(
          value: 'two',
          groupValue: _groupValue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => globalWidgets.myTextRaleway(context, optionTwoText.value,
                    Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  openEditQuestionDilog(context, optionTwoCtl, 'Edit Option',
                      'Edit your second option');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Icon(
                    Icons.edit,
                    color: ColorsX.appBarColor,
                  ),
                ),
              ),
            ],
          ),
          onChanged: (newValue) => setState(() => _groupValue = newValue!),
          activeColor: Colors.red,
          selected: false,
        ),
        RadioListTile<String>(
          value: 'three',
          groupValue: _groupValue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => globalWidgets.myTextRaleway(
                    context,
                    optionThreeText.value,
                    Colors.black,
                    0,
                    0,
                    0,
                    0,
                    FontWeight.w400,
                    17),
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  openEditQuestionDilog(context, optionThreeCtl, 'Edit Option',
                      'Edit your third option');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Icon(
                    Icons.edit,
                    color: ColorsX.appBarColor,
                  ),
                ),
              ),
            ],
          ),
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
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          questionText.value =
              questionCtl.text.isEmpty ? questionText.value : questionCtl.text;
          optionOneText.value = optionOneCtl.text.isEmpty
              ? optionOneText.value
              : optionOneCtl.text;
          optionTwoText.value = optionTwoCtl.text.isEmpty
              ? optionTwoText.value
              : optionTwoCtl.text;
          optionThreeText.value = optionThreeCtl.text.isEmpty
              ? optionThreeText.value
              : optionThreeCtl.text;
          // deleteProfileNow();

          Map<String, dynamic> singleChoiceQuestionMap = {};
          singleChoiceQuestionMap['question'] = questionText.value;
          singleChoiceQuestionMap['option_one'] = optionOneText.value;
          singleChoiceQuestionMap['option_two'] = optionTwoText.value;
          singleChoiceQuestionMap['option_three'] = optionThreeText.value;
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }
}
