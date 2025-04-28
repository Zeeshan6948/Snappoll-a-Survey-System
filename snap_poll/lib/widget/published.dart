import 'dart:io';
import 'csv_mobile.dart' if (dart.library.html) 'csv_web.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import '../global/colors.dart';
import '../global/global_variables.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';
import '../routes/app_pages.dart';

class Published extends StatefulWidget {
  const Published({Key? key}) : super(key: key);

  @override
  _PublishedState createState() => _PublishedState();
}

class _PublishedState extends State<Published> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: SizeConfig.screenWidth * .02),
      child: ListView(
        children: [
          Wrap(
            spacing: 1,
            children: <Widget>[
              for (int index = 0;
                  index < GlobalVariables.templatesList.length;
                  index++)
                GestureDetector(
                  onTap: () {
                    // GlobalVariables.idOfSurvey = "temp/${maintainersList[index].reference.id}";
                    GlobalVariables.idOfSurvey =
                        GlobalVariables.templatesList[index].reference.id;
                    debugPrint(GlobalVariables.idOfSurvey);
                    Get.toNamed(Routes.CARD_FORM_LAYOUT);
                  },
                  onLongPress: () {
                    GlobalVariables.roleType = 'admin';
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: new Icon(Icons.save),
                                title: globalWidgets.myTextRaleway(
                                    context,
                                    'Save results as CSV file'.tr,
                                    ColorsX.black,
                                    0,
                                    0,
                                    0,
                                    0,
                                    FontWeight.w400,
                                    14),
                                onTap: () async {
                                  if (!kIsWeb) {
                                    bool isPermissionGranted =
                                        await isStoragePermissionGranted();
                                    if (isPermissionGranted) {
                                      createCSV(index);
                                    } else {
                                      await requestStoragePermission();
                                      isPermissionGranted =
                                          await isStoragePermissionGranted();
                                      if (isPermissionGranted) {
                                        createCSV(index);
                                      } else {
                                        print(
                                            'Storage permission not granted.');
                                      }
                                    }
                                  } else if (kIsWeb) {
                                    createCSV(index);
                                  }
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.qr_code),
                                title: globalWidgets.myTextRaleway(
                                    context,
                                    'View QRCode'.tr,
                                    ColorsX.black,
                                    0,
                                    0,
                                    0,
                                    0,
                                    FontWeight.w400,
                                    14),
                                onTap: () async {
                                  GlobalVariables.idOfSurvey = GlobalVariables
                                      .templatesList[index].reference.id;
                                  Get.toNamed(Routes.QRCODE_SCREEN);
                                },
                              ),
                              GlobalVariables.roleType == 'maintainer' ||
                                      GlobalVariables.roleType == 'viewer'
                                  ? Container()
                                  : ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: globalWidgets.myTextRaleway(
                                          context,
                                          'Delete survey'.tr,
                                          ColorsX.black,
                                          0,
                                          0,
                                          0,
                                          0,
                                          FontWeight.w400,
                                          14),
                                      onTap: () {
                                        var docRef = GlobalVariables
                                            .templatesList[index].reference;
                                        docRef.delete().then((value) {
                                          // Delete successful
                                          setState(() {
                                            GlobalVariables.templatesList
                                                .removeAt(index);
                                          });
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        }).catchError((error) {
                                          // Delete failed
                                          print(
                                              "Failed to delete survey: $error");
                                        });
                                        // var docRef = maintainersList[index].reference;
                                        // docRef.delete().then((value) {
                                        //   // Delete successful
                                        //   setState(() {
                                        //     maintainersList.removeAt(index);
                                        //   });
                                        //   Navigator.pop(
                                        //       context); // Close the bottom sheet
                                        // }).catchError((error) {
                                        //   // Delete failed
                                        //   print("Failed to delete survey: $error");
                                        // });
                                      },
                                    ),
                            ],
                          );
                        });
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: SizeConfig.screenHeight * .35,
                      width: SizeConfig.screenWidth * .45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * .10,
                            width: SizeConfig.screenWidth * .20,
                            margin: EdgeInsets.only(top: 10),
                            child: Image.asset('assets/images/uni_logo.png'),
                          ),
                          globalWidgets.myText(
                              context,
                              '${GlobalVariables.templatesList[index]["title"]}',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              15),
                          globalWidgets.myTextCustom(
                              context,
                              '${GlobalVariables.templatesList[index]["short_description"]}',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              13),
                          globalWidgets.myText(
                              context,
                              '${GlobalVariables.templatesList[index]["questions"].length} Questions  |  '
                              '${GlobalVariables.templatesList[index]["sections"].length} Sections',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              12),
                          Expanded(child: Container()),
                          Visibility(
                            visible: true,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: ColorsX.appBarColor),
                              ),
                              child: globalWidgets.myText(
                                  context,
                                  'Preview'.tr,
                                  ColorsX.appBarColor,
                                  3,
                                  10,
                                  10,
                                  3,
                                  FontWeight.w500,
                                  14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> createCSV(int index) async {
    var docRef;
    // if(GlobalVariables.roleType == 'maintainer')
    //   docRef = maintainersList[index].reference;
    // else
    docRef = GlobalVariables.templatesList[index].reference;
    final QuerySnapshot querySnapshot =
        await docRef.collection('results').get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;
    if (firestoreResponseList.isEmpty) {
      print('results empty');
    } else {
      List<List<dynamic>> data = [];
      for (var x in firestoreResponseList) {
        if (x.exists) {
          print(x.data());
        }
      }
      var questionDoc =
          firestoreResponseList.firstWhere((doc) => doc.id == 'questionsID');
      List<dynamic> questions = questionDoc['questions'];
      print('Liste: $questions');
      List<dynamic> options = [];
      List<dynamic> answers = [];
      List<dynamic> questionCSV = [];
      questionCSV.add("answer_date");
      for (Map t in questions) {
        questionCSV.add(t['question']);
        if (t['question_type'] == "Multiple Rating") {
          options = t['options'];
          for (String t2 in options) {
            questionCSV.add(t2);
          }
        }
        questionCSV.add("suggestion");
        questionCSV.add('duration');
      }
      print(questionCSV);
      data.add(questionCSV);
      firestoreResponseList.remove(questionDoc);
      print("NACH DER LÖSCHUNG");
      for (var x in firestoreResponseList) {
        if (x.exists) {
          List<dynamic> result = x['result'];
          List<dynamic> resultCSV = [];
          resultCSV.add(x['answer_date']);
          for (var element in result) {
            resultCSV.add(element['answer'].toString());
            if (element['Q_type'] == 'Multiple Rating') {
              answers = element['answer'];
              for (String t2 in answers) {
                resultCSV.add(t2);
              }
            }
            resultCSV.add(element['suggestion']);
            resultCSV.add(element['time']);
          }
          data.add(resultCSV);
        }
      }
      print(data);
      if (!kIsWeb) {
        saveCSVToDownloads(index, data);
        saveDialog(context);
      }
      if (kIsWeb) {
        saveCSVToDownloads(index, data);
        saveDialog(context);
      }
    }
  }

  // Request storage permission
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

// Check if storage permission is granted
  Future<bool> isStoragePermissionGranted() async {
    var status = await Permission.storage.status;
    return status.isGranted;
  }

  saveDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: "Saved CSV file to device".tr,
        desc: 'Check your downloads folder'.tr,
        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.check_circle,
        btnOkColor: Colors.blueAccent)
      ..show();
  }
}
