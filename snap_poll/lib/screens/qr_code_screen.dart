import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:get/get.dart';
import 'package:snap_poll/routes/app_pages.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key}) : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey previewContainer = new GlobalKey();
  List<String> imagePaths = [];
  int _counter = 0;
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        clearStack();
        return false;
      },
      child: Scaffold(
        body: body(context),
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 16.0, right: 8, left: 8),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              backgroundColor: ColorsX.appBarColor,
              heroTag: 'share',
              onPressed: () => captureImage(),
              icon: Icon(Icons.share),
              label: globalWidgets.myTextRaleway(context, 'Share QR',
                  ColorsX.white, 0, 0, 0, 0, FontWeight.w500, 14),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorsX.appBarColor,
          centerTitle: true,
          title: globalWidgets.myTextRaleway(context, "Share QR", ColorsX.white,
              0, 0, 0, 0, FontWeight.w400, 16),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorsX.white,
            ),
            onPressed: () => clearStack(), //Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(color: ColorsX.white),
      child: Column(
        children: [
          Container(
            child: globalWidgets.myTextRaleway(
                context,
                GlobalVariables.TITLE_OF_SURVEY,
                ColorsX.black,
                20,
                20,
                20,
                0,
                FontWeight.w600,
                16),
          ),
          SizedBox(
            height: 50,
          ),
          RepaintBoundary(
            key: previewContainer,
            child: Container(
              height: SizeConfig.screenHeight * .30,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(color: ColorsX.black),
              child: BarcodeWidget(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                backgroundColor: ColorsX.black,
                color: ColorsX.white,
                barcode: Barcode.qrCode(
                  errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                ),
                data: GlobalVariables.idOfSurvey,
                errorBuilder: (context, error) => Center(
                    child: globalWidgets.myTextRaleway(context, error,
                        ColorsX.black, 10, 10, 10, 0, FontWeight.w400, 14)),
                width: SizeConfig.screenWidth * .60,
                height: SizeConfig.screenHeight * .40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  shareQr(BuildContext context, List<String> imagePaths) {
    return Share.shareFiles(imagePaths, text: GlobalVariables.TITLE_OF_SURVEY);
  }

  Future<void> saveScreenShot() async {
    screenshotController
        .capture()
        .then((Uint8List image) {
          //Capture Done
          setState(() {
            _imageFile = image;
          });
        } as FutureOr Function(Uint8List? value))
        .catchError((onError) {
      print(onError);
    });
  }

  Future<void> captureImage() {
    if (imagePaths.isNotEmpty) imagePaths.clear();
    final RenderBox box = context.findRenderObject() as RenderBox;
    return new Future.delayed(const Duration(milliseconds: 40), () async {
      RenderRepaintBoundary? boundary = previewContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(
        pixelRatio: 6.0,
      );
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        // await shareQr(context, imagePaths);
        await Share.shareFiles(imagePaths,
            subject: 'Share',
            text: GlobalVariables.TITLE_OF_SURVEY,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  clearStack() {
    GlobalVariables.TITLE_OF_SURVEY = '';
    GlobalVariables.idOfSurvey = '';
    GlobalVariables.currentIndex = 0;
    GlobalVariables.LIST_OF_ALL_ANSWERS = [];
    GlobalVariables.SECTIONS_LIST.clear();
    // GlobalVariables.SECTIONS_LIST.add('Select Section');
    debugPrint(GlobalVariables.SECTIONS_LIST.toString());
    GlobalVariables.QUESTION_TYPE = '';
    GlobalVariables.sectionValue = 'Select Section';
    GlobalVariables.LIST_OF_ALL_QUESTIONS = [];
    GlobalVariables.LIST_OF_ALL_SECTIONS = [];
    GlobalVariables.LIST_OF_MC_RESULTS = [];
    GlobalWidgets.pwdWidgets.clear();
    Get.toNamed(Routes.MAIN_PAGE);
  }
}
