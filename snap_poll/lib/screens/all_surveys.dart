import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';

import '../global/global_widgets.dart';

class AllSurveys extends StatefulWidget {
  const AllSurveys({Key? key}) : super(key: key);

  @override
  _AllSurveysState createState() => _AllSurveysState();
}

class _AllSurveysState extends State<AllSurveys> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DocumentSnapshot> allSurveys = [];
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(GlobalVariables.currentIndex);
    loadAllSurveys();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.toNamed(Routes.MAIN_PAGE);
          return false;
        },
        child: Scaffold(
          body: body(context),
          appBar: AppBar(
              backgroundColor: ColorsX.appBarColor,
              centerTitle: true,
              title: globalWidgets.myTextRaleway(context, "Created Surveys",
                  ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 20),
              leading: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MAIN_PAGE);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorsX.white,
                  size: 18,
                ),
              )),
        ));
  }

  body(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
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
                                  print('Storage permission not granted.');
                                }
                              }
                            },
                          ),
                          ListTile(
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
                              var docRef = allSurveys[index].reference;
                              docRef.delete().then((value) {
                                // Delete successful
                                setState(() {
                                  allSurveys.removeAt(index);
                                });
                                Navigator.pop(
                                    context); // Close the bottom sheet
                              }).catchError((error) {
                                // Delete failed
                                print("Failed to delete survey: $error");
                              });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: globalWidgets.myTextRaleway(
                                context,
                                'Edit Survey'.tr,
                                ColorsX.black,
                                0,
                                0,
                                0,
                                0,
                                FontWeight.w400,
                                14),
                            onTap: () {
                              DocumentSnapshot docRef = allSurveys[index];
                              GlobalVariables.idOfSurvey = docRef.id;
                              GlobalVariables.Fetched_Document =
                                  docRef.data() as Map<String, dynamic>?;
                              Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
                            },
                          )
                        ],
                      );
                    });
              },
              onTap: () {
                GlobalVariables.idOfSurvey =
                    "${allSurveys[index].reference.id}";
                Get.toNamed(Routes.CARD_FORM_LAYOUT);
              },
              child: ListTile(
                title: globalWidgets.myTextCustomOneLine(
                    context,
                    "${allSurveys[index].get('title')}",
                    ColorsX.black,
                    0,
                    0,
                    10,
                    10,
                    FontWeight.w500,
                    17),
                subtitle: globalWidgets.myTextCustomOneLine(
                    context,
                    "${allSurveys[index].get('short_description')}",
                    ColorsX.black.withOpacity(0.7),
                    0,
                    0,
                    10,
                    0,
                    FontWeight.w400,
                    14),
                // trailing: GestureDetector(
                //   onTap: (){},
                //   child: Icon(Icons.share_rounded, color: ColorsX.appBarColor,),
                // ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 5,
              thickness: 0.5,
              indent: 5,
              endIndent: 5,
              color: ColorsX.greytext,
            );
          },
          itemCount: allSurveys.length),
    );
  }

  loadAllSurveys() async {
    GlobalWidgets.showProgressLoader("Please wait".tr);

    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('surveys').get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;
    GlobalWidgets.hideProgressLoader();
    if (firestoreResponseList.isEmpty) {
      print("No results");
      errorDialog(context, 'No survey available so far');
    } else {
      List<DocumentSnapshot> temp = firestoreResponseList;
      firestoreResponseList.removeWhere(
          (element) => (element.get('user_id') != GlobalVariables.userId));
      // if(temp.isNotEmpty){
      // for (var element in temp) {
      //   if (element.get('user_id') != GlobalVariables.userId) {
      //     temp.remove(element);
      //   }
      //
      // }
      // }
      if (firestoreResponseList.isEmpty) {
        errorDialog(context, 'You have not created any survey yet.');
      } else {
        setState(() {
          allSurveys = firestoreResponseList;
        });
      }
    }
  }

  Future<void> createCSV(int index) async {
    var docRef = allSurveys[index].reference;
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
      List<dynamic> questionCSV = [];
      questionCSV.add("answer_date");
      for (Map t in questions) {
        questionCSV.add(t['question']);
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
            resultCSV.add(element['suggestion']);
            resultCSV.add(element['time']);
          }
          data.add(resultCSV);
        }
      }
      print(data);
      saveCSVToDownloads(index, data);
    }
  }

  Future<void> saveCSVToDownloads(
      int index, List<List<dynamic>> csvData) async {
    // Generate the CSV string
    String csvString = const ListToCsvConverter().convert(csvData);

    // Get the document directory using path_provider package
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    // Create the CSV file path
    String filePath = '${directory.path}/${allSurveys[index].reference.id}.csv';

    // Write the CSV string to the file
    File file = File(filePath);
    await file.writeAsString(csvString);

    print('CSV file saved to: $filePath');
    saveDialog(context);
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

  errorDialog(BuildContext context, String description) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: true,
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "No Survey Found",
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(context, description, ColorsX.subBlack,
                10, 0, 0, 20, FontWeight.w400, 12),
          ],
        ), // \n Save or remember ID to Log In' ,

        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }
}
