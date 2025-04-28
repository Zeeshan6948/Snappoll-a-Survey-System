import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_widgets.dart';

class YesNo extends StatefulWidget {
  const YesNo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _YesNoState();
  }
}

class _YesNoState extends State<YesNo> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  String _groupValue = 'Any';
  RxString questionText = 'Do you like this question?'.obs;
  TextEditingController ctl = TextEditingController();
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
                openEditQuestionDilog(context);
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

  openEditQuestionDilog(BuildContext context) {
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
        title: 'Edit question',
        desc: 'Write a question you want to ask', //
        body: globalWidgets.myTextField(TextInputType.text, ctl, false,
            'Edit your question here'), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Edit',
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel',
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          questionText.value = ctl.text;
          // deleteProfileNow();
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }
}
