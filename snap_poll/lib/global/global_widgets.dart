import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' hide AssetManifest;

import 'package:ndialog/ndialog.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/global/colors.dart';

class GlobalWidgets {
  static late ProgressDialog progressDialog;

  static String? day = "";
  static String? month = "";
  static String? year = "";
  static String? chosenDateTimeFromSetAppointment = "";
  static List<Widget> pwdWidgets = <Widget>[];
  static List<Widget> pwdWidgetsTemp = <Widget>[];

  static void showProgressDialog(
      BuildContext context, String title, String message) {
    progressDialog =
        ProgressDialog(context, message: Text(message), title: Text(title));
  }

  myText(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.mukta(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  Future<void> scanQRCode(BuildContext context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    print('BarCode Scan Result' + barcodeScanRes);

    if (barcodeScanRes != '-1' && barcodeScanRes.isNotEmpty) {
      print('BarCode Scan Result' + barcodeScanRes);
      GlobalVariables.idOfSurvey = barcodeScanRes.toString();
      // String url = '${AppUrls.baseUrl}/${barcodeScanRes}';
      // print(url);
      // print("Barcode ID: $barcodeScanRes");
      // final a = Uri.parse(url);
      // print(a.path);
      // print('USER ID FROM URL : ${a.pathSegments.last}');

      Get.toNamed(Routes.CARD_FORM_LAYOUT); // This works when foregrounded
      // GV.USER_NFC_UUID = a.pathSegments.last;
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => UserProfileScreen()));
    }
  }

  titleDescriptionDialogForSurveyAnswer(String title, String description, BuildContext context){

    return AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        headerAnimationLoop: true,
        title: title,
        desc: description,
        btnOkOnPress: () {
        },
        btnOkIcon: Icons.done,
        btnOkColor: ColorsX.appBarColor)
      ..show();
  }
  myTextRaleway(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextBlinker(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.blinker(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextSerif(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextCustomRaleway(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextCustom(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: GoogleFonts.mukta(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextCustomOneLine(
      BuildContext context,
      String text,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.raleway(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  detailText(
      BuildContext context,
      String text,
      String detail,
      Color colorsX,
      double top,
      double left,
      double right,
      double bottom,
      FontWeight fontWeight,
      double fontSize) {
    return Container(
      margin:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: Text(
        text,
        style: GoogleFonts.mukta(
            textStyle: TextStyle(
                color: colorsX, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }

  myTextField(TextInputType inputType, TextEditingController ctl,
      bool obscureText, String hint) {
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: ColorsX.blackWithOpacity, width: 1.25)),
      child: TextFormField(
        keyboardType: inputType,
        controller: ctl,
        obscureText: obscureText,
        style: TextStyle(color: ColorsX.black),
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hint,
            hintStyle: TextStyle(color: ColorsX.subBlack)),
      ),
    );
  }

  myTextFieldMultipleLines(TextInputType inputType, TextEditingController ctl,
      bool obscureText, String hint) {
    return Container(
      width: GlobalVariables.ScrWidth,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: ColorsX.blackWithOpacity, width: 1.25)),
      child: TextFormField(
        keyboardType: inputType,
        controller: ctl,
        minLines: 1,
        maxLines: 8,
        obscureText: obscureText,
        style: TextStyle(color: ColorsX.black),
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hint,
            hintStyle: TextStyle(color: ColorsX.subBlack)),
      ),
    );
  }

  static bool validateEmail(String email) {
    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
    return emailValid;
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: ColorsX.white,
        fontSize: 16.0);
  }

  static showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: ColorsX.appBarColor,
        textColor: ColorsX.white,
        fontSize: 16.0);
  }

  static successDialog(String title, String description, BuildContext context) {
    GlobalWidgets.hideProgressLoader();
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
        desc: description, // \n Save or remember ID to Log In' ,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          // Get.toNamed(Routes.ALL_CASTES_MAIN_PAGE);
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  //

  static hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static showProgressLoader(String msg) {
    EasyLoading.show(status: msg);
  }

  static hideProgressLoader() {
    EasyLoading.dismiss();
  }

  progressBarForSurveyQuestions(String totalQuestions, String currentQuestion) {
    return Container(
      width: GlobalVariables.ScrWidth,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: FAProgressBar(
        currentValue: ((double.parse(currentQuestion)) /
            double.parse(totalQuestions) *
            100),
        maxValue: 100,
        displayText: '%',
        progressColor: ColorsX.appBarColor,
        backgroundColor: ColorsX.subBlack,
      ),
    );
  }

  static void initializeLoader() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 60
      ..radius = 20
      ..backgroundColor = Colors.black
      ..indicatorColor = ColorsX.white
      ..textColor = Colors.white
      ..userInteractions = true
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.doubleBounce;
  }

  TextField reusableTextField(String text, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: ColorsX.uBdarkestBlue,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }

  Container firebaseUIButton(
      BuildContext context, String title, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return ColorsX.uBlightestBlue;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
