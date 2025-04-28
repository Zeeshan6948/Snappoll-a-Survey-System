import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_widgets.dart';
import '../global/size_config.dart';

class OpenText extends StatefulWidget {
  const OpenText({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OpenTextState();
  }
}

class _OpenTextState extends State<OpenText> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController questionCtl = TextEditingController();
  RxString questionText = 'Do you like this question?'.obs;
  TextEditingController ctl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Column(
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
        const TextField(
          decoration: InputDecoration(
            hintText: "Provide You Answer Here",
            hintStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 40),
          ),
        ),
        MaterialButton(
          onPressed: () {},
          color: Colors.blue,
          child: const Text(
            "Add Next",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
  }

  addOpenTextQuestion() {
    return Container(
        child: Column(
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
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: const Icon(
                  Icons.delete,
                  color: ColorsX.appBarColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const TextField(
          decoration: InputDecoration(
            hintText: "Provide You Answer Here",
            hintStyle: TextStyle(color: Colors.black54),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 40),
          ),
        ),
        MaterialButton(
          onPressed: () {},
          color: Colors.blue,
          child: const Text(
            "Add Next",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
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
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }
}
