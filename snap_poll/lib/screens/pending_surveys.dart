import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/main.dart';
import 'package:snap_poll/widget/published.dart';
import 'package:snap_poll/widget/templates.dart';

import '../global/colors.dart';
import '../global/global_variables.dart';
import '../global/size_config.dart';
import '../routes/app_pages.dart';

class PendingSurveys extends StatefulWidget {
  const PendingSurveys({Key? key}) : super(key: key);

  @override
  _PendingSurveysState createState() => _PendingSurveysState();
}

class _PendingSurveysState extends State<PendingSurveys>
    with TickerProviderStateMixin {
  TabController? controller;
  int selectedIndexOfTab = 0;
  GlobalWidgets globalWidgets = GlobalWidgets();
  List<DocumentSnapshot> tempSurveys = [];
  List<DocumentSnapshot> maintainersList = [];
  List<DocumentSnapshot> viewersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);

    controller?.addListener(() {
      setState(() {
        selectedIndexOfTab = controller!.index;
      });
      print("Selected Index: " + controller!.index.toString());
    });

    checkPendingSurveys();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsX.appBarColor,
          bottom: TabBar(
            indicatorColor: ColorsX.appBarColor,
            indicatorWeight: 4,
            isScrollable: true,
            unselectedLabelStyle:
                TextStyle(color: ColorsX.white.withOpacity(0.5)),
            tabs: [
              // Tab(icon: Icon(Icons.person),text: 'Viewed By Me',),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(color: Colors.redAccent, width: 1)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: globalWidgets.myText(context, "Published",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(color: Colors.redAccent, width: 1)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: globalWidgets.myText(context, "Pending",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(color: Colors.redAccent, width: 1)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: globalWidgets.myText(context, "Maintainer",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(color: Colors.redAccent, width: 1)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: globalWidgets.myText(context, "Viewer",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(color: Colors.redAccent, width: 1)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: globalWidgets.myText(context, "Templates",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
                  ),
                ),
              ),
            ],
            labelStyle: TextStyle(fontSize: 16.0, fontFamily: "Mukta"),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: globalWidgets.myText(context, "Your Surveys".tr, ColorsX.white,
              0, 0, 0, 0, FontWeight.w400, 16),
        ),
        body: TabBarView(
          children: [
            GlobalVariables.templatesList.isEmpty
                ? Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          // color:  const Color(0xff70b4ff).withOpacity(0.8),
                          color: ColorsX.white,
                        ),
                        child: Center(
                          child: globalWidgets.myText(
                              context,
                              'You have not created any survey yet.',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              17),
                        ),
                      )
                    ],
                  )
                : Published(),
            // Stack(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         // color:  const Color(0xff70b4ff).withOpacity(0.8),
            //         color: ColorsX.white,
            //       ),
            //       child: ListView.separated(
            //           itemCount: GlobalVariables.templatesList.length,
            //           separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.appBarColor),
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: (){
            //                 // GlobalVariables.idOfSurvey = "temp/${maintainersList[index].reference.id}";
            //                 GlobalVariables.idOfSurvey = GlobalVariables.templatesList[index].reference.id;
            //                 debugPrint(GlobalVariables.idOfSurvey);
            //                 GlobalVariables.roleType = 'admin';
            //                 Get.toNamed(Routes.CARD_FORM_LAYOUT);
            //               },
            //               onLongPress: () {
            //                 GlobalVariables.roleType = 'admin';
            //                 showModalBottomSheet(
            //                     context: context,
            //                     builder: (context) {
            //                       return Column(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           ListTile(
            //                             leading: new Icon(Icons.save),
            //                             title: globalWidgets.myTextRaleway(
            //                                 context,
            //                                 'Save results as CSV file'.tr,
            //                                 ColorsX.black,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 FontWeight.w400,
            //                                 14),
            //                             onTap: () async {
            //                               bool isPermissionGranted =
            //                               await isStoragePermissionGranted();
            //                               if (isPermissionGranted) {
            //                                 createCSV(index);
            //                               } else {
            //                                 await requestStoragePermission();
            //                                 isPermissionGranted =
            //                                 await isStoragePermissionGranted();
            //                                 if (isPermissionGranted) {
            //                                   createCSV(index);
            //                                 } else {
            //                                   print('Storage permission not granted.');
            //                                 }
            //                               }
            //                             },
            //                           ),
            //                           GlobalVariables.roleType == 'maintainer' ||
            //                               GlobalVariables.roleType == 'viewer' ?
            //                           Container() : ListTile(
            //                             leading: const Icon(Icons.delete),
            //                             title: globalWidgets.myTextRaleway(
            //                                 context,
            //                                 'Delete survey'.tr,
            //                                 ColorsX.black,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 FontWeight.w400,
            //                                 14),
            //                             onTap: () {
            //
            //                               var docRef = GlobalVariables.templatesList[index].reference;
            //                               docRef.delete().then((value) {
            //                                 // Delete successful
            //                                 setState(() {
            //                                   GlobalVariables.templatesList.removeAt(index);
            //                                 });
            //                                 Navigator.pop(
            //                                     context); // Close the bottom sheet
            //                               }).catchError((error) {
            //                                 // Delete failed
            //                                 print("Failed to delete survey: $error");
            //                               });
            //                               // var docRef = maintainersList[index].reference;
            //                               // docRef.delete().then((value) {
            //                               //   // Delete successful
            //                               //   setState(() {
            //                               //     maintainersList.removeAt(index);
            //                               //   });
            //                               //   Navigator.pop(
            //                               //       context); // Close the bottom sheet
            //                               // }).catchError((error) {
            //                               //   // Delete failed
            //                               //   print("Failed to delete survey: $error");
            //                               // });
            //                             },
            //                           ),
            //                         ],
            //                       );
            //                     });
            //               },
            //               child: ListTile(
            //                 // leading: showImageOfItem(context),
            //                 title: globalWidgets.myText(
            //                     context,
            //                     '${GlobalVariables.templatesList[index]["title"]}', ColorsX.black,
            //                     0, 10, 0, 0, FontWeight.w600, 17),
            //                 subtitle: globalWidgets.myTextCustomOneLine(
            //                     context,
            //                     '${GlobalVariables.templatesList[index]["short_description"]}', ColorsX.black.withOpacity(0.7),
            //                     0, 10, 0, 0, FontWeight.w600, 14),
            //               ),
            //             );
            //           }),
            //     )
            //   ],
            // ),
            tempSurveys.length == 0
                ? Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          // color:  const Color(0xff70b4ff).withOpacity(0.8),
                          color: ColorsX.white,
                        ),
                        child: Center(
                          child: globalWidgets.myText(
                              context,
                              'You have not created any survey yet.',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              17),
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      pending(context, tempSurveys),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     // color:  const Color(0xff70b4ff).withOpacity(0.8),
                      //     color: ColorsX.white,
                      //   ),
                      //   child: ListView.separated(
                      //       itemCount: tempSurveys.length,
                      //       separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.appBarColor),
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return GestureDetector(
                      //           onTap: (){
                      //             // GlobalVariables.idOfSurvey = "temp/${maintainersList[index].reference.id}";
                      //             GlobalVariables.idOfSurvey = "temp/${tempSurveys[index].reference.id}";
                      //             debugPrint(GlobalVariables.idOfSurvey);
                      //             GlobalVariables.roleType = 'admin';
                      //             Get.toNamed(Routes.CARD_FORM_LAYOUT);
                      //           },
                      //           onLongPress: () {
                      //             GlobalVariables.roleType = 'admin';
                      //             showModalBottomSheet(
                      //                 context: context,
                      //                 builder: (context) {
                      //                   return Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       ListTile(
                      //                         leading: new Icon(Icons.save),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Save results as CSV file'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () async {
                      //                           bool isPermissionGranted =
                      //                           await isStoragePermissionGranted();
                      //                           if (isPermissionGranted) {
                      //                             createCSV(index);
                      //                           } else {
                      //                             await requestStoragePermission();
                      //                             isPermissionGranted =
                      //                             await isStoragePermissionGranted();
                      //                             if (isPermissionGranted) {
                      //                               createCSV(index);
                      //                             } else {
                      //                               print('Storage permission not granted.');
                      //                             }
                      //                           }
                      //                         },
                      //                       ),
                      //                       GlobalVariables.roleType == 'maintainer' ||
                      //                           GlobalVariables.roleType == 'viewer' ?
                      //                       Container() : ListTile(
                      //                         leading: const Icon(Icons.delete),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Delete survey'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () {
                      //
                      //                           var docRef = tempSurveys[index].reference;
                      //                           docRef.delete().then((value) {
                      //                             // Delete successful
                      //                             setState(() {
                      //                               tempSurveys.removeAt(index);
                      //                             });
                      //                             Navigator.pop(
                      //                                 context); // Close the bottom sheet
                      //                           }).catchError((error) {
                      //                             // Delete failed
                      //                             print("Failed to delete survey: $error");
                      //                           });
                      //                           // var docRef = maintainersList[index].reference;
                      //                           // docRef.delete().then((value) {
                      //                           //   // Delete successful
                      //                           //   setState(() {
                      //                           //     maintainersList.removeAt(index);
                      //                           //   });
                      //                           //   Navigator.pop(
                      //                           //       context); // Close the bottom sheet
                      //                           // }).catchError((error) {
                      //                           //   // Delete failed
                      //                           //   print("Failed to delete survey: $error");
                      //                           // });
                      //                         },
                      //                       ),
                      //                       ListTile(
                      //                         leading: const Icon(Icons.edit),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Edit Survey'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () {
                      //                           GlobalVariables.MAINTAINER_LIST.clear();
                      //                           GlobalVariables.VIEWER_LIST.clear();
                      //                           if(GlobalVariables.roleType == 'maintainer') {
                      //                             DocumentSnapshot docRef = maintainersList[index];
                      //                             GlobalVariables.idOfSurvey =
                      //                                 'temp/' + docRef.id;
                      //                             GlobalVariables.Fetched_Document =
                      //                             docRef.data() as Map<String,
                      //                                 dynamic>?;
                      //                             Get.toNamed(
                      //                                 Routes.CREATE_SURVEY_QUESTION);
                      //                           }else{
                      //
                      //                             DocumentSnapshot docRef = tempSurveys[index];
                      //                             GlobalVariables.idOfSurvey =
                      //                                 'temp/' + docRef.id;
                      //                             GlobalVariables.Fetched_Document =
                      //                             docRef.data() as Map<String,
                      //                                 dynamic>?;
                      //                             Get.toNamed(
                      //                                 Routes.CREATE_SURVEY_QUESTION);
                      //                           }
                      //                         },
                      //                       )
                      //                     ],
                      //                   );
                      //                 });
                      //           },
                      //           child: ListTile(
                      //             // leading: showImageOfItem(context),
                      //             trailing: GestureDetector(
                      //               onTap: (){
                      //                 debugPrint("tapped");
                      //                 GlobalVariables.idOfSurvey = tempSurveys[index].reference.id;
                      //                 debugPrint(GlobalVariables.idOfSurvey);
                      //                 publishDialog(context, index);
                      //               },
                      //               child: globalWidgets.myText(
                      //                   context,
                      //                   'Publish'.tr,
                      //                   ColorsX.appBarColor, 0, 10, 0, 0, FontWeight.w400, 15),
                      //             ),
                      //             title: globalWidgets.myText(
                      //                 context,
                      //                 '${tempSurveys[index]["title"]}', ColorsX.black,
                      //                 0, 10, 0, 0, FontWeight.w600, 17),
                      //             subtitle: globalWidgets.myTextCustomOneLine(
                      //                 context,
                      //                 '${tempSurveys[index]["short_description"]}', ColorsX.black.withOpacity(0.7),
                      //                 0, 10, 0, 0, FontWeight.w600, 14),
                      //           ),
                      //         );
                      //       }),
                      // )
                    ],
                  ),
            maintainersList.length == 0
                ? Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          // color:  const Color(0xff70b4ff).withOpacity(0.8),
                          color: ColorsX.white,
                        ),
                        child: Center(
                          child: globalWidgets.myText(
                              context,
                              'No maintainer access yet.',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              17),
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      maintainers(context, maintainersList),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     // color:  const Color(0xff70b4ff).withOpacity(0.8),
                      //     color:  ColorsX.white,
                      //   ),
                      //   child: ListView.separated(
                      //       itemCount: maintainersList.length,
                      //       separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.appBarColor),
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return GestureDetector(
                      //           onTap: (){
                      //             GlobalVariables.idOfSurvey = "temp/${maintainersList[index].reference.id}";
                      //             debugPrint(GlobalVariables.idOfSurvey);
                      //             GlobalVariables.roleType = 'maintainer';
                      //             Get.toNamed(Routes.CARD_FORM_LAYOUT);
                      //           },
                      //           onLongPress: () {
                      //             GlobalVariables.roleType = 'maintainer';
                      //             showModalBottomSheet(
                      //                 context: context,
                      //                 builder: (context) {
                      //                   return Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       ListTile(
                      //                         leading: new Icon(Icons.save),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Save results as CSV file'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () async {
                      //                           bool isPermissionGranted =
                      //                           await isStoragePermissionGranted();
                      //                           if (isPermissionGranted) {
                      //                             createCSV(index);
                      //                           } else {
                      //                             await requestStoragePermission();
                      //                             isPermissionGranted =
                      //                             await isStoragePermissionGranted();
                      //                             if (isPermissionGranted) {
                      //                               createCSV(index);
                      //                             } else {
                      //                               print('Storage permission not granted.');
                      //                             }
                      //                           }
                      //                         },
                      //                       ),
                      //                       GlobalVariables.roleType == 'maintainer' ||
                      //                           GlobalVariables.roleType == 'viewer' ?
                      //                       Container() : ListTile(
                      //                         leading: const Icon(Icons.delete),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Delete survey'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () {
                      //                           var docRef = tempSurveys[index].reference;
                      //                           docRef.delete().then((value) {
                      //                             // Delete successful
                      //                             setState(() {
                      //                               tempSurveys.removeAt(index);
                      //                             });
                      //                             Navigator.pop(
                      //                                 context); // Close the bottom sheet
                      //                           }).catchError((error) {
                      //                             // Delete failed
                      //                             print("Failed to delete survey: $error");
                      //                           });
                      //                           // var docRef = maintainersList[index].reference;
                      //                           // docRef.delete().then((value) {
                      //                           //   // Delete successful
                      //                           //   setState(() {
                      //                           //     maintainersList.removeAt(index);
                      //                           //   });
                      //                           //   Navigator.pop(
                      //                           //       context); // Close the bottom sheet
                      //                           // }).catchError((error) {
                      //                           //   // Delete failed
                      //                           //   print("Failed to delete survey: $error");
                      //                           // });
                      //                         },
                      //                       ),
                      //                       ListTile(
                      //                         leading: const Icon(Icons.edit),
                      //                         title: globalWidgets.myTextRaleway(
                      //                             context,
                      //                             'Edit Survey'.tr,
                      //                             ColorsX.black,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             0,
                      //                             FontWeight.w400,
                      //                             14),
                      //                         onTap: () {
                      //                           DocumentSnapshot docRef = maintainersList[index];
                      //                           GlobalVariables.idOfSurvey ='temp/'+ docRef.id;
                      //                           GlobalVariables.Fetched_Document =
                      //                           docRef.data() as Map<String, dynamic>?;
                      //                           Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
                      //                         },
                      //                       )
                      //                     ],
                      //                   );
                      //                 });
                      //           },
                      //           child: ListTile(
                      //             // leading: showImageOfItem(context),
                      //             // trailing: globalWidgets.myText(
                      //             //     context,
                      //             //     '${maintainersList[index]["title"]}',
                      //             //     ColorsX.white, 0, 10, 0, 0, FontWeight.w400, 15),
                      //             title: globalWidgets.myText(
                      //                 context,
                      //                 '${maintainersList[index]["title"]}', ColorsX.black,
                      //                 0, 10, 0, 0, FontWeight.w600, 17),
                      //             subtitle: globalWidgets.myTextCustomOneLine(
                      //                 context,
                      //                 '${maintainersList[index]["short_description"]}', ColorsX.black.withOpacity(0.7),
                      //                 0, 10, 0, 0, FontWeight.w600, 14),
                      //           ),
                      //         );
                      //       }),
                      // )
                    ],
                  ),
            viewersList.length == 0
                ? Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          // color:  const Color(0xff70b4ff).withOpacity(0.8),
                          color: ColorsX.white,
                        ),
                        child: Center(
                          child: globalWidgets.myText(
                              context,
                              'No viewer access yet.',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              17),
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      viewer(context, viewersList),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     // color:  const Color(0xff70b4ff).withOpacity(0.8),
                      //     color:  ColorsX.white,
                      //   ),
                      //   child: ListView.separated(
                      //       itemCount: viewersList.length,
                      //       separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.appBarColor),
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return GestureDetector(
                      //           onTap: (){
                      //             GlobalVariables.idOfSurvey = "temp/${viewersList[index].reference.id}";
                      //             debugPrint(GlobalVariables.idOfSurvey);
                      //             GlobalVariables.roleType = 'viewer';
                      //             Get.toNamed(Routes.CARD_FORM_LAYOUT);
                      //           },
                      //           child: ListTile(
                      //             // leading: showImageOfItem(context),
                      //             // trailing: globalWidgets.myText(
                      //             //     context,
                      //             //     '${viewersList[index]["title"]}',
                      //             //     ColorsX.white, 0, 10, 0, 0, FontWeight.w400, 15),
                      //             title: globalWidgets.myText(
                      //                 context,
                      //                 '${viewersList[index]["title"]}', ColorsX.black,
                      //                 0, 10, 0, 0, FontWeight.w600, 17),
                      //             subtitle: globalWidgets.myTextCustomOneLine(
                      //                 context,
                      //                 '${viewersList[index]["short_description"]}', ColorsX.black.withOpacity(0.7),
                      //                 0, 10, 0, 0, FontWeight.w600, 14),
                      //           ),
                      //         );
                      //       }),
                      // )
                    ],
                  ),
            GlobalVariables.templatesList.isEmpty
                ? Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          // color:  const Color(0xff70b4ff).withOpacity(0.8),
                          color: ColorsX.white,
                        ),
                        child: Center(
                          child: globalWidgets.myText(
                              context,
                              'No templates found yet.'.tr,
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              17),
                        ),
                      )
                    ],
                  )
                : Templates(),
            // Stack(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         // color:  const Color(0xff70b4ff).withOpacity(0.8),
            //         color:  ColorsX.white,
            //       ),
            //       child: ListView.separated(
            //           itemCount: GlobalVariables.templatesList.length,
            //           separatorBuilder: (context, index) =>Divider(height: 1, color: ColorsX.appBarColor),
            //           itemBuilder: (BuildContext context, int index) {
            //             return GestureDetector(
            //               onTap: (){
            //                 GlobalVariables.idOfSurvey = "temp/${GlobalVariables.templatesList[index].reference.id}";
            //                 debugPrint(GlobalVariables.idOfSurvey);
            //                 GlobalVariables.roleType = 'maintainer';
            //                 Get.toNamed(Routes.CARD_FORM_LAYOUT);
            //               },
            //               onLongPress: () {
            //                 GlobalVariables.roleType = 'maintainer';
            //                 showModalBottomSheet(
            //                     context: context,
            //                     builder: (context) {
            //                       return Column(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           ListTile(
            //                             leading: new Icon(Icons.save),
            //                             title: globalWidgets.myTextRaleway(
            //                                 context,
            //                                 'Save results as CSV file'.tr,
            //                                 ColorsX.black,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 FontWeight.w400,
            //                                 14),
            //                             onTap: () async {
            //                               bool isPermissionGranted =
            //                               await isStoragePermissionGranted();
            //                               if (isPermissionGranted) {
            //                                 createCSV(index);
            //                               } else {
            //                                 await requestStoragePermission();
            //                                 isPermissionGranted =
            //                                 await isStoragePermissionGranted();
            //                                 if (isPermissionGranted) {
            //                                   createCSV(index);
            //                                 } else {
            //                                   print('Storage permission not granted.');
            //                                 }
            //                               }
            //                             },
            //                           ),
            //                           GlobalVariables.roleType == 'maintainer' ||
            //                               GlobalVariables.roleType == 'viewer' ?
            //                           Container() : ListTile(
            //                             leading: const Icon(Icons.delete),
            //                             title: globalWidgets.myTextRaleway(
            //                                 context,
            //                                 'Delete survey'.tr,
            //                                 ColorsX.black,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 FontWeight.w400,
            //                                 14),
            //                             onTap: () {
            //                               var docRef = GlobalVariables.templatesList[index].reference;
            //                               docRef.delete().then((value) {
            //                                 // Delete successful
            //                                 setState(() {
            //                                   GlobalVariables.templatesList.removeAt(index);
            //                                 });
            //                                 Navigator.pop(
            //                                     context); // Close the bottom sheet
            //                               }).catchError((error) {
            //                                 // Delete failed
            //                                 print("Failed to delete survey: $error");
            //                               });
            //                               // var docRef = maintainersList[index].reference;
            //                               // docRef.delete().then((value) {
            //                               //   // Delete successful
            //                               //   setState(() {
            //                               //     maintainersList.removeAt(index);
            //                               //   });
            //                               //   Navigator.pop(
            //                               //       context); // Close the bottom sheet
            //                               // }).catchError((error) {
            //                               //   // Delete failed
            //                               //   print("Failed to delete survey: $error");
            //                               // });
            //                             },
            //                           ),
            //                           ListTile(
            //                             leading: const Icon(Icons.edit),
            //                             title: globalWidgets.myTextRaleway(
            //                                 context,
            //                                 'Edit Survey'.tr,
            //                                 ColorsX.black,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 0,
            //                                 FontWeight.w400,
            //                                 14),
            //                             onTap: () {
            //                               DocumentSnapshot docRef = GlobalVariables.templatesList[index];
            //                               GlobalVariables.idOfSurvey ='temp/'+ docRef.id;
            //                               GlobalVariables.Fetched_Document =
            //                               docRef.data() as Map<String, dynamic>?;
            //                               Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
            //                             },
            //                           )
            //                         ],
            //                       );
            //                     });
            //               },
            //               child: ListTile(
            //                 // leading: showImageOfItem(context),
            //                 // trailing: globalWidgets.myText(
            //                 //     context,
            //                 //     '${maintainersList[index]["title"]}',
            //                 //     ColorsX.white, 0, 10, 0, 0, FontWeight.w400, 15),
            //                 title: globalWidgets.myText(
            //                     context,
            //                     '${GlobalVariables.templatesList[index]["title"]}', ColorsX.black,
            //                     0, 10, 0, 0, FontWeight.w600, 17),
            //                 subtitle: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     globalWidgets.myTextCustomOneLine(
            //                         context,
            //                         '${GlobalVariables.templatesList[index]["short_description"]}',
            //                         ColorsX.black.withOpacity(0.7), 0, 10, 0, 0, FontWeight.w600, 14),
            //                     SizedBox(height: 10,),
            //                     globalWidgets.myText(
            //                         context, '${GlobalVariables.templatesList[index]["questions"].length} Questions  |  '
            //                         '${GlobalVariables.templatesList[index]["sections"].length} Sections',
            //                         ColorsX.black.withOpacity(0.7),
            //                         0, 10, 0, 0, FontWeight.w600, 12),
            //                     // globalWidgets.myTextCustomOneLine(
            //                     //     context, '${GlobalVariables.templatesList[index]["sections"].length} Sections',
            //                     //     ColorsX.black.withOpacity(0.7), 0, 10, 0, 0, FontWeight.w600, 14),
            //                   ],
            //                 )
            //               ),
            //             );
            //           }),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  publishDialog(BuildContext context, int index) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.question,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        closeIcon: Container(),
        // closeIcon: IconButton(icon : Icon(Icons.close, color: ColorsX.light_orange,),onPressed: () {
        //   Get.back();
        //   // Get.toNamed(Routes.LOGIN_SCREEN);
        // },),
        showCloseIcon: true,
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Publish".tr, ColorsX.black,
                10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "Are you sure you want to publish the survey?".tr,
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
          ],
        ),
        btnCancelOnPress: () {
          // Get.back();
        },
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done'.tr,
        buttonsTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () async {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          debugPrint(GlobalVariables.idOfSurvey);
          GlobalWidgets.showProgressLoader('');
          var collection = FirebaseFirestore.instance.collection('surveys');
          // if (GlobalVariables.idOfSurvey != "") {
          //   var documentId = GlobalVariables.idOfSurvey;
          //   final DocumentReference _temp;
          //   _temp = FirebaseFirestore.instance
          //       .collection('surveys')
          //       .doc(documentId);
          //   _temp.delete();
          // }
          Map<String, dynamic> map = {
            'title': '${tempSurveys[index]["title"]}',
            'short_description': '${tempSurveys[index]["short_description"]}',
            'questions': tempSurveys[index]["questions"],
            'sections': tempSurveys[index]["sections"],
            'user_id': GlobalVariables.userId,
            'maintainers': tempSurveys[index]["maintainers"],
            'viewers': tempSurveys[index]["viewers"],
          };
          var docRef = await collection.add(map);
          var documentId = docRef.id;

          GlobalWidgets.hideProgressLoader();
          if (documentId.toString().isEmpty) {
            GlobalWidgets.showToast('Survey not saved. Try again'.tr);
          } else {
            var resultsCollectionRef = FirebaseFirestore.instance
                .collection('surveys/$documentId/results');
            await resultsCollectionRef
                .doc('questionsID')
                .set({'questions': tempSurveys[index]["questions"]});
            String tempValueOfPublishedSurvey = documentId;
            GlobalWidgets.showProgressLoader('Deleting Old Survey');
            var collection =
                FirebaseFirestore.instance.collection('temp_surveys');
            await collection.doc(GlobalVariables.idOfSurvey).delete();
            GlobalWidgets.hideProgressLoader();
            GlobalVariables.idOfSurvey = tempValueOfPublishedSurvey;
            GlobalVariables.TITLE_OF_SURVEY = "";
            GlobalWidgets.pwdWidgets.clear;
            // shortDescriptionCtl.clear();
            GlobalVariables.SECTIONS_LIST.clear();
            GlobalVariables.LIST_OF_ALL_QUESTIONS.clear();
            Get.toNamed(Routes.QRCODE_SCREEN);
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  checkPendingSurveys() async {
    GlobalWidgets.showProgressLoader("Please wait".tr);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString('email');

    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temp_surveys').get();
    final List<DocumentSnapshot> firestoreResponseList = querySnapshot.docs;
    GlobalWidgets.hideProgressLoader();
    if (firestoreResponseList.isEmpty) {
      print("No pending surveys");
    } else {
      List<DocumentSnapshot> maintainers = querySnapshot.docs;
      List<DocumentSnapshot> viewers = querySnapshot.docs;
      debugPrint(GlobalVariables.userId);
      debugPrint(email);
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

      maintainers.removeWhere(
          (element) => (!element.get('maintainers').contains(email)));
      if (maintainers.isEmpty) {
        print('you are not maintainer');
      } else {
        setState(() {
          maintainersList = maintainers;
        });
      }
      viewers
          .removeWhere((element) => (!element.get('viewers').contains(email)));
      if (viewers.isEmpty) {
        print('you are not viewer');
      } else {
        setState(() {
          viewersList = viewers;
        });
      }
      if (firestoreResponseList.isEmpty) {
        print("No pending surveys admin");
      } else {
        setState(() {
          tempSurveys = firestoreResponseList;
        });
      }
    }
    loadAllSurveys();
  }

  Future<void> createCSV(int index) async {
    var docRef;
    if (GlobalVariables.roleType == 'maintainer')
      docRef = maintainersList[index].reference;
    else
      docRef = tempSurveys[index].reference;
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
    String filePath = '';
    // Create the CSV file path
    if (GlobalVariables.roleType == 'maintainer')
      filePath = '${directory.path}/${maintainersList[index].reference.id}.csv';
    else
      filePath = '${directory.path}/${tempSurveys[index].reference.id}.csv';

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
          GlobalVariables.templatesList = firestoreResponseList;
        });
      }
    }
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
          // Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  pending(
    BuildContext context,
    List<DocumentSnapshot<Object?>> tempSurveys,
  ) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: SizeConfig.screenWidth * .02),
      child: ListView(
        children: [
          Wrap(
            spacing: 1,
            children: <Widget>[
              for (int index = 0; index < tempSurveys.length; index++)
                GestureDetector(
                  onTap: () {
                    // GlobalVariables.idOfSurvey = "temp/${maintainersList[index].reference.id}";
                    GlobalVariables.idOfSurvey =
                        "temp/${tempSurveys[index].reference.id}";
                    debugPrint(GlobalVariables.idOfSurvey);
                    GlobalVariables.roleType = 'admin';
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
                                        var docRef =
                                            tempSurveys[index].reference;
                                        docRef.delete().then((value) {
                                          // Delete successful
                                          setState(() {
                                            tempSurveys.removeAt(index);
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
                                  EasyLoading.instance.maskColor =
                                      Colors.white.withOpacity(1);
                                  EasyLoading.instance.maskType =
                                      EasyLoadingMaskType.custom;
                                  GlobalWidgets.showProgressLoader(
                                      "Loading Survey");
                                  GlobalVariables.MAINTAINER_LIST.clear();
                                  GlobalVariables.VIEWER_LIST.clear();
                                  if (GlobalVariables.roleType ==
                                      'maintainer') {
                                    DocumentSnapshot docRef =
                                        maintainersList[index];
                                    GlobalVariables.idOfSurvey =
                                        'temp/' + docRef.id;
                                    GlobalVariables.Fetched_Document =
                                        docRef.data() as Map<String, dynamic>?;
                                    Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
                                  } else {
                                    DocumentSnapshot docRef =
                                        tempSurveys[index];
                                    GlobalVariables.idOfSurvey =
                                        'temp/' + docRef.id;
                                    GlobalVariables.Fetched_Document =
                                        docRef.data() as Map<String, dynamic>?;
                                    Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
                                  }
                                },
                              )
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
                              '${tempSurveys[index]["title"]}',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              15),
                          globalWidgets.myTextCustom(
                              context,
                              '${tempSurveys[index]["short_description"]}',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              13),
                          globalWidgets.myText(
                              context,
                              '${tempSurveys[index]["questions"].length} Questions  |  '
                              '${tempSurveys[index]["sections"].length} Sections',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              12),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              debugPrint("tapped");
                              GlobalVariables.idOfSurvey =
                                  tempSurveys[index].reference.id;
                              debugPrint(GlobalVariables.idOfSurvey);
                              publishDialog(context, index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: ColorsX.appBarColor),
                              ),
                              child: globalWidgets.myText(
                                  context,
                                  'Publish'.tr,
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

  maintainers(
    BuildContext context,
    List<DocumentSnapshot<Object?>> tempSurveys,
  ) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: SizeConfig.screenWidth * .02),
      child: ListView(
        children: [
          Wrap(
            spacing: 1,
            children: <Widget>[
              for (int index = 0; index < tempSurveys.length; index++)
                GestureDetector(
                  onTap: () {
                    GlobalVariables.idOfSurvey =
                        "temp/${tempSurveys[index].reference.id}";
                    debugPrint(GlobalVariables.idOfSurvey);
                    GlobalVariables.roleType = 'maintainer';
                    Get.toNamed(Routes.CARD_FORM_LAYOUT);
                  },
                  onLongPress: () {
                    GlobalVariables.roleType = 'maintainer';
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
                                        var docRef =
                                            tempSurveys[index].reference;
                                        docRef.delete().then((value) {
                                          // Delete successful
                                          setState(() {
                                            tempSurveys.removeAt(index);
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
                                  EasyLoading.instance.maskColor =
                                      Colors.white.withOpacity(1);
                                  EasyLoading.instance.maskType =
                                      EasyLoadingMaskType.custom;
                                  GlobalWidgets.showProgressLoader(
                                      "Loading Survey");
                                  DocumentSnapshot docRef =
                                      maintainersList[index];
                                  GlobalVariables.idOfSurvey =
                                      'temp/' + docRef.id;
                                  GlobalVariables.Fetched_Document =
                                      docRef.data() as Map<String, dynamic>?;
                                  Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
                                },
                              )
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
                              '${tempSurveys[index]["title"]}',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              15),
                          globalWidgets.myTextCustom(
                              context,
                              '${tempSurveys[index]["short_description"]}',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              13),
                          globalWidgets.myText(
                              context,
                              '${tempSurveys[index]["questions"].length} Questions  |  '
                              '${tempSurveys[index]["sections"].length} Sections',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              12),
                          Expanded(child: Container()),
                          // GestureDetector(
                          //   onTap: (){
                          //     debugPrint("tapped");
                          //     GlobalVariables.idOfSurvey = tempSurveys[index].reference.id;
                          //     debugPrint(GlobalVariables.idOfSurvey);
                          //     publishDialog(context, index);
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(bottom: 8),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(20)),
                          //       border: Border.all(color: ColorsX.appBarColor),
                          //     ),
                          //     child: globalWidgets.myText(context, 'Publish'.tr,
                          //         ColorsX.appBarColor, 3, 10, 10, 3, FontWeight.w500, 14),
                          //   ),
                          // ),
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

  viewer(
    BuildContext context,
    List<DocumentSnapshot<Object?>> tempSurveys,
  ) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(left: SizeConfig.screenWidth * .02),
      child: ListView(
        children: [
          Wrap(
            spacing: 1,
            children: <Widget>[
              for (int index = 0; index < tempSurveys.length; index++)
                GestureDetector(
                  onTap: () {
                    GlobalVariables.idOfSurvey =
                        "temp/${tempSurveys[index].reference.id}";
                    debugPrint(GlobalVariables.idOfSurvey);
                    GlobalVariables.roleType = 'viewer';
                    Get.toNamed(Routes.CARD_FORM_LAYOUT);
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
                              '${tempSurveys[index]["title"]}',
                              ColorsX.black,
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              15),
                          globalWidgets.myTextCustom(
                              context,
                              '${tempSurveys[index]["short_description"]}',
                              ColorsX.black.withOpacity(0.7),
                              0,
                              10,
                              0,
                              0,
                              FontWeight.w600,
                              13),
                          globalWidgets.myText(
                              context,
                              '${tempSurveys[index]["questions"].length} Questions  |  '
                              '${tempSurveys[index]["sections"].length} Sections',
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
                          // GestureDetector(
                          //   onTap: (){
                          //     debugPrint("tapped");
                          //     GlobalVariables.idOfSurvey = tempSurveys[index].reference.id;
                          //     debugPrint(GlobalVariables.idOfSurvey);
                          //     publishDialog(context, index);
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(bottom: 8),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(20)),
                          //       border: Border.all(color: ColorsX.appBarColor),
                          //     ),
                          //     child: globalWidgets.myText(context, 'Publish'.tr,
                          //         ColorsX.appBarColor, 3, 10, 10, 3, FontWeight.w500, 14),
                          //   ),
                          // ),
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
}
