import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/global_variables.dart';
import '../global/colors.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';
import '../routes/app_pages.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  String _groupValue = 'Any';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .75,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: ColorsX.appBarColor,
        ),
        child: Drawer(
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              // _createHeader(),
              SizedBox(
                height: SizeConfig.screenHeight * .10,
              ),
              globalWidgets.myTextRaleway(context, 'SURVEY ELEMENTS',
                  ColorsX.greydashboard, 10, 10, 0, 0, FontWeight.w400, 13),
              _createDrawerItem(Icons.star, 'Star Rating', context),
              _createDrawerItem(Icons.scale, 'Scale Rating', context),
              _createDrawerItem(Icons.propane_tank, 'Ranking', context),
              _createDrawerItem(Icons.linear_scale, 'Linear Scale', context),
              _createDrawerItem(Icons.trip_origin, 'Range', context),
              const Divider(
                color: ColorsX.white,
              ),
              globalWidgets.myTextRaleway(context, 'BASIC ELEMENTS',
                  ColorsX.greydashboard, 10, 10, 0, 0, FontWeight.w400, 13),
              _createDrawerItem(Icons.text_decrease, 'Short Text', context),
              _createDrawerItem(Icons.text_increase, 'Long Text', context),
              _createDrawerItem(Icons.download_done, 'Yes / No', context),
              _createDrawerItem(Icons.radio, 'Single Choice', context),
              _createDrawerItem(Icons.check_box, 'Multiple Choice', context),
              const Divider(
                color: ColorsX.white,
              ),
              _createDrawerItem(
                  Icons.share_rounded, 'Share with Friends', context),
              _createDrawerItem(Icons.bug_report, 'Scan QR', context),
              const Divider(
                color: ColorsX.white,
              ),
              _createDrawerItem(Icons.logout, 'Logout', context),
              const Divider(
                color: ColorsX.white,
              ),
              // ListTile(
              //   title: Text('Powered by Epopiah', style: TextStyle(color: ColorsX.white),),
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _createDrawerItem(IconData icon, String text, BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: ColorsX.white,
        ),
        title: globalWidgets.myText(
            context, text, ColorsX.white, 0, 2, 0, 0, FontWeight.w600, 16),
        onTap: () async {
          if (text == "Star Rating") {
            Get.back();
          }
          if (text == "Yes / No") {
            Get.back();
          }
          if (text == "Scan QR") {
            Get.back();
            scanQRCode(context);
          }
          if (text == "Share with Friends") {
            Get.back();
            Share.share(
                'This is an amazing app to find best match for your surveys. ');
          }
          if (text == "Logout") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Get.back();
            Get.toNamed(Routes.LOGIN_SCREEN);
          }
        },
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

  logoutNow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Get.back();
    Get.toNamed(Routes.LOGIN_SCREEN);
  }
}
