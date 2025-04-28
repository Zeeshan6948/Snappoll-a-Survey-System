import 'dart:async';
import 'dart:ui' as ui;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/start_screen.dart';
import 'package:snap_poll/widget/mc_question_widget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CardFormLayout extends StatefulWidget {
  const CardFormLayout({Key? key}) : super(key: key);

  @override
  _CardFormLayoutState createState() => _CardFormLayoutState();
}

class _CardFormLayoutState extends State<CardFormLayout> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  DocumentSnapshot? documentSnapshot;
  Map<String, dynamic>? fetchDoc;
  List<dynamic> listOfAllQuestions = [];
  List<dynamic> listOfAllSections = [];
  List<ContentConfig> listContentConfig = [];
  List<CheckboxListTileModel> checkboxListTiles = [];
  TextEditingController ctl = TextEditingController();
  TextEditingController otctl = TextEditingController();
  CarouselController carouselController = CarouselController();
  String _groupValue = 'Any';
  String start_age = '';
  String end_age = '';
  double initialRating = 0;
  int dynamicLinearScaleValue = 0;
  List<String> selectedLinearScaleValue = [];
  RangeValues _currentRangeValues = RangeValues(1, 100);
  late DateTime questionStartTime;
  late DateTime questionEndTime;
  SpeechToText speechToText = SpeechToText();

  String _lastWords = '';
  String _currentWords = '';
  bool isListening = false;
  bool speachSessionActive = false;

  late osm.MapController controller;
  List<osm.GeoPoint> myMarkers = [];
  int mapCounter = -1;
  GlobalKey globalKey = GlobalKey(); // Add a GlobalKey for RepaintBoundary
  osm.GeoPoint? tappedLocation;
  bool openFullScreenMap = false;
  static String ageValue = "Alter auswählen";
  @override
  void initState() {
    super.initState();
    if (GlobalVariables.idOfSurvey.contains('temp/')) {
      String id = GlobalVariables.idOfSurvey.split('/')[1];
      GlobalVariables.idOfSurvey = id;
      loadTempSurvey();
    } else {
      loadSurvey();
    }
    controller = osm.MapController(
      initPosition: osm.GeoPoint(latitude: 49.89873, longitude: 10.90067),
      // areaLimit: BoundingBox(
      //   east: 10.4922941,
      //   north: 47.8084648,
      //   south: 45.817995,
      //   west: 5.9559113,
      // ),
    );
    // controller.listenerMapLongTapping.addListener(() async {
    //   osm.GeoPoint? position = controller.listenerMapLongTapping.value;
    //   await controller.addMarker(
    //     position ?? osm.GeoPoint(latitude: 0.0, longitude: 0.0),
    //     markerIcon: osm.MarkerIcon(
    //       icon: Icon(
    //         Icons.location_on,
    //         color: Colors.red,
    //         size: 48,
    //       ),
    //     ),
    //   );
    //   setState(() {
    //     GlobalVariables.myMarkers.add(position??osm.GeoPoint(latitude: 0.0, longitude: 0.0));
    //   });
    //   print("Long pressed at: ${position!.latitude}, ${position!.longitude}");
    //   debugPrint( 'Size is${GlobalVariables.myMarkers.length}');
    // });
    controller.listenerMapSingleTapping.addListener(() {
      if (controller.listenerMapSingleTapping.value != null) {
        Get.toNamed(Routes.MAP_SCREEN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: GlobalWidgets().myTextRaleway(
                    context,
                    "Leave Survey?".tr,
                    ColorsX.appBarColor,
                    0,
                    0,
                    0,
                    0,
                    FontWeight.w700,
                    24),
                content: GlobalWidgets().myTextRaleway(
                    context,
                    "Are you sure you want to quit the survey?".tr,
                    ColorsX.appBarColor,
                    0,
                    0,
                    0,
                    0,
                    FontWeight.w500,
                    18),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  TextButton(
                    child: GlobalWidgets().myTextRaleway(context, "Stay".tr,
                        ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(false); // Stay on the current screen
                    },
                  ),
                  TextButton(
                    child: GlobalWidgets().myTextRaleway(context, "Quit".tr,
                        ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                    onPressed: () {
                      GlobalVariables.currentIndex = 0;
                      GlobalVariables.LIST_OF_ALL_ANSWERS = [];
                      GlobalVariables.myMarkers = [];
                      GlobalVariables.coordinates = [];
                      if (FirebaseAuth.instance.currentUser == null) {
                        Get.toNamed(Routes.INITIAL_SCREEN);
                      } else {
                        Get.toNamed(Routes.MAIN_PAGE);
                      }
                      // Navigate to the named route
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        body: body(context),
        appBar: AppBar(
            backgroundColor: ColorsX.appBarColor,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                cancelDialog();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: ColorsX.white,
                size: 18,
              ),
            )),
      ),
    );
  }

  body(BuildContext context) {
    return listOfAllQuestions.isEmpty
        ? Container()
        : Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.90,
            decoration: const BoxDecoration(color: ColorsX.white),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  cardOfQuestion(context),
                ],
              ),
            ),
          );
  }

  void cancelDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: GlobalWidgets().myTextRaleway(context, "Leave Survey?".tr,
                ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w700, 24),
            content: GlobalWidgets().myTextRaleway(
                context,
                "Are you sure you want to quit the survey?".tr,
                ColorsX.appBarColor,
                0,
                0,
                0,
                0,
                FontWeight.w500,
                18),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              TextButton(
                child: GlobalWidgets().myTextRaleway(context, "Stay".tr,
                    ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Stay on the current screen
                },
              ),
              TextButton(
                child: GlobalWidgets().myTextRaleway(context, "Quit".tr,
                    ColorsX.appBarColor, 0, 0, 0, 0, FontWeight.w600, 18),
                onPressed: () {
                  GlobalVariables.currentIndex = 0;
                  Get.back();
                  Get.back();
                  // Get.toNamed(Routes
                  //     .ALL_SURVEYS); // Navigate to the desired named route
                },
              )
            ],
          );
        });
  }

  void loadSurvey() async {
    GlobalWidgets.showProgressLoader("Please wait".tr);

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('surveys')
        .doc(GlobalVariables.idOfSurvey)
        .get();
    // .doc(GlobalVariables.idOfSurvey).get();
    if (snapshot.exists) {
      questionStartTime = DateTime.now();
      fetchDoc = snapshot.data() as Map<String, dynamic>?;
      GlobalWidgets.hideProgressLoader();
      listOfAllQuestions = fetchDoc?['questions'];
      listOfAllSections = fetchDoc?['sections'];
      listOfAllSections.removeAt(0);
      globalWidgets.titleDescriptionDialogForSurveyAnswer(
          "${fetchDoc?['title']}",
          "${fetchDoc?['short_description']}",
          context);
      setState(() {
        documentSnapshot = snapshot;
      });
    } else {
      GlobalWidgets.hideProgressLoader();
      errorDialog(context);
    }
    debugPrint(listOfAllQuestions.length.toString());
    debugPrint(listOfAllQuestions.toString());
  }

  void loadTempSurvey() async {
    GlobalWidgets.showProgressLoader("Please wait".tr);

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('temp_surveys')
        .doc(GlobalVariables.idOfSurvey)
        .get();
    // .doc(GlobalVariables.idOfSurvey).get();
    if (snapshot.exists) {
      questionStartTime = DateTime.now();
      fetchDoc = snapshot.data() as Map<String, dynamic>?;
      GlobalWidgets.hideProgressLoader();
      listOfAllQuestions = fetchDoc?['questions'];
      listOfAllSections = fetchDoc?['sections'];
      listOfAllSections.removeAt(0);
      globalWidgets.titleDescriptionDialogForSurveyAnswer(
          "${fetchDoc?['title']}",
          "${fetchDoc?['short_description']}",
          context);
      setState(() {
        documentSnapshot = snapshot;
      });
    } else {
      GlobalWidgets.hideProgressLoader();
      errorDialog(context);
    }
    debugPrint(listOfAllQuestions.length.toString());
    debugPrint(listOfAllQuestions.toString());
  }

  errorDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        headerAnimationLoop: true,
        title: "No Survey Found".tr,
        desc: 'Please try again'.tr,
        btnOkOnPress: () {
          Get.back();
        },
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  Future _stopListening() async {
    setState(() {
      otctl.value = TextEditingValue(text: _lastWords);
      speachSessionActive = false;
    });
    await speechToText.stop();
  }

  cardOfQuestion(BuildContext context) {
    return CarouselSlider(
      disableGesture: false,
      carouselController: carouselController,
      options: CarouselOptions(
          height: SizeConfig.screenHeight,
          enableInfiniteScroll: false,
          scrollPhysics: GlobalVariables.roleType == 'viewer'
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          initialPage: 0,
          autoPlay: false,
          viewportFraction: 1),
      items: listOfAllQuestions.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: ColorsX.white),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  globalWidgets.progressBarForSurveyQuestions(
                      listOfAllQuestions.length.toString(),
                      GlobalVariables.currentIndex.toString()),
                  Container(
                      width: GlobalVariables.ScrWidth,
                      child: globalWidgets.myTextRaleway(context, i['question'],
                          ColorsX.black, 20, 10, 10, 0, FontWeight.w500, 18)),
                  Visibility(
                      //Katharina_Work
                      visible: i['question'] ==
                          'In welchem Stadtviertel Bambergs wohnen Sie? ',
                      child: GestureDetector(
                          onTap: () => _showImageDialog(context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              globalWidgets.myTextRaleway(
                                  context,
                                  "Bild Anzeigen",
                                  ColorsX.blueGradientPureDark,
                                  0,
                                  5,
                                  10,
                                  0,
                                  FontWeight.w500,
                                  15)
                            ],
                          ))),
                  Visibility(
                      //Katharina_Work
                      visible: i['section'] ==
                          'Fragen zu jeweiligem Ort: ',
                      child: GlobalVariables.myMarkers.isEmpty ? Container() : startTimer(context, GlobalVariables.myMarkers, mapCounter+1)
                  ),
                  i['question_type'] == 'Yes No'
                      ? yesNoWidget(context)
                      : i['question_type'] == 'Single Choice'
                          ? singleChoiceWidget(context)
                          : i['question_type'] == 'Multiple Choice'
                              ? multipleChoiceWidget(context)
                              : i['question_type'] == 'Rating'
                                  ? ratingWidget(context)
                                  : i['question_type'] == 'Open Text'
                                      ? openTextWidget(context)
                                      : i['question_type'] == 'Range'
                                          ? rangeWidget(context)
                                          : i['question_type'] == 'Linear Scale'
                                              ? scaleRating(context, 0,
                                                  dynamicLinearScaleValue, 1, 0)
                                              : i['question_type'] == 'Map'
                                                  ? buildMap(context)
                                                  : i['question_type'] ==
                                                          'Multiple Rating'
                                                      ? multipleRatingWidget(
                                                          context)
                                                      : i['question_type'] ==
                                                              'Drop down'
                                                          ? agesDropdown(
                                                              context)
                                                          : Container(),
                  nextQuestion(context),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: globalWidgets.myTextFieldMultipleLines(
                          TextInputType.multiline,
                          ctl,
                          false,
                          'Add your thoughts'.tr),
                    ),
                  ),
                ],
              )),
            );
          },
        );
      }).toList(),
    );

    // for(int index = 0; index < listOfAllQuestions.length; index++){
    //   GlobalVariables.currentIndex = index;
    //   if(listOfAllSections.contains(listOfAllQuestions[index]['section'])) {
    //     return Container(
    //         child: Column(
    //           children: [
    //             globalWidgets.myTextRaleway(
    //                 context,
    //                 listOfAllSections[index],
    //                 ColorsX.black,
    //                 10,
    //                 10,
    //                 10,
    //                 0,
    //                 FontWeight.w500,
    //                 23),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: globalWidgets.myTextRaleway(
    //                   context,
    //                   listOfAllQuestions[index]['question'],
    //                   ColorsX.black,
    //                   20,
    //                   10,
    //                   10,
    //                   0,
    //                   FontWeight.w500,
    //                   18),
    //             ),
    //             listOfAllQuestions[index]['question_type'] == 'Yes No' ? yesNoWidget(context) : Container(),
    //             nextQuestion(context),
    //           ],
    //         )
    //     );
    //   }
    //   else {
    //     return globalWidgets.myTextRaleway(context, 'Not for this section', ColorsX.black,
    //         10, 10, 10, 0, FontWeight.w500, 15);
    //   }
    // }
  }

  Future<void> _addMarkers() async {
    for (var point in GlobalVariables.myMarkers) {
      await controller.addMarker(
        point,
        markerIcon: osm.MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );
      print("Added marker at: ${point.latitude}, ${point.longitude}");
    }
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: (SizeConfig.screenWidth > 600)
                              ? Image.asset(
                                  'assets/images/Smart_City.jpg',
                                  fit: BoxFit.contain, // Maintain aspect ratio
                                )
                              : Image.asset(
                                  'assets/images/Smart_City_90.jpg',
                                  fit: BoxFit.contain, // Maintain aspect ratio
                                ),
                        ),
                      )),
                ],
              ),
              Positioned(
                top: 5.0,
                right: 5.0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildMap(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.MAP_SCREEN);
      },
      child: Container(
        height: SizeConfig.screenHeight * .40,
        width: SizeConfig.screenWidth,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/Map_Image.png',
                  fit: BoxFit.contain, // Maintain aspect ratio
                ),
              ),
            ),
            // osm.OSMFlutter(
            //   controller: controller,
            //   osmOption: osm.OSMOption(
            //     showDefaultInfoWindow: true,
            //     showZoomController: true,
            //     zoomOption: const osm.ZoomOption(
            //       initZoom: 12.5,
            //       maxZoomLevel: 19,
            //       minZoomLevel: 8,
            //     ),
            //     userLocationMarker: osm.UserLocationMaker(
            //       personMarker: const osm.MarkerIcon(
            //         icon: Icon(Icons.location_on,
            //             color: ColorsX.blueGradientDark),
            //       ),
            //       directionArrowMarker: const osm.MarkerIcon(
            //         icon: Icon(
            //           Icons.double_arrow,
            //           size: 48,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onMapIsReady: (bool isReady) {
            //     print("Map is ready: $isReady");
            //     if (isReady) {
            //       _addMarkers(); // Add markers when the map is ready
            //     }
            //   },
            //   onGeoPointClicked: (osm.GeoPoint point) {
            //     setState(() {
            //       tappedLocation = point;
            //     });
            //     print("Tapped location: ${point.latitude}, ${point.longitude}");
            //   },
            // ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.MAP_SCREEN);
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: SizeConfig.screenWidth * .40,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: ColorsX.appBarColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fullscreen,
                        color: ColorsX.white,
                      ),
                      globalWidgets.myText(
                          context,
                          'Open Map in Full Screen'.tr,
                          ColorsX.white,
                          0,
                          0,
                          0,
                          0,
                          FontWeight.w600,
                          16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  yesNoWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            RadioListTile<String>(
              value: 'Yes',
              groupValue: _groupValue,
              title: globalWidgets.myTextRaleway(context, 'Yes'.tr,
                  Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
              onChanged: (newValue) => setState(() => _groupValue = newValue!),
              activeColor: Colors.red,
              selected: false,
            ),
            RadioListTile<String>(
              value: 'No',
              groupValue: _groupValue,
              title: globalWidgets.myTextRaleway(context, 'No'.tr, Colors.black,
                  0, 0, 0, 0, FontWeight.w400, 17),
              onChanged: (newValue) => setState(() => _groupValue = newValue!),
              activeColor: Colors.red,
              selected: false,
            ),
          ],
        ));
  }

  openTextWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(children: [
        Container(
          width: GlobalVariables.ScrWidth,
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: ColorsX.blackWithOpacity, width: 1.25)),
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: otctl,
            minLines: 8,
            maxLines: 8,
            obscureText: false,
            style: TextStyle(color: ColorsX.black),
            decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Please provide your answer here',
                hintStyle: TextStyle(color: ColorsX.subBlack)),
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
            visible: !kIsWeb,
            child: Center(
              child: globalWidgets.myTextRaleway(
                  context,
                  _lastWords.isNotEmpty
                      ? 'Release the microphone to stop recording!'
                      : 'Tap the microphone to start listening...',
                  ColorsX.uBstrongestGrey,
                  0,
                  0,
                  0,
                  0,
                  FontWeight.w400,
                  18),
            )),
        const SizedBox(height: 1),
        Visibility(
            visible: !kIsWeb,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _lastWords = "";
                        _currentWords = "";
                        otctl.text = "";
                      });
                      print("clear tapped");

                      print(_lastWords);
                    },
                    child: globalWidgets.myTextRaleway(context, "Clear".tr,
                        Colors.white, 0, 0, 0, 0, FontWeight.w300, 16),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsX.appBarColor,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
                AvatarGlow(
                  glowRadiusFactor: 75,
                  animate: speachSessionActive,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: Colors.grey,
                  repeat: true,
                  glowCount: 2,
                  child: GestureDetector(
                    onTapDown: (details) async {
                      print("object");
                      if (!speachSessionActive) {
                        setState(() {
                          speachSessionActive = true;
                        });
                        if (!isListening) {
                          Timer timer = Timer.periodic(
                              Duration(milliseconds: 50), (timer) async {
                            if (!speachSessionActive) {
                              timer.cancel();
                            }
                            if (!speechToText.isListening) {
                              bool available = await speechToText.initialize();
                              if (!available) {
                                speechToText.stop();
                                speechToText = SpeechToText();
                                available = await speechToText.initialize();
                              }
                            }
                            speechToText.listen(
                              listenMode: ListenMode.dictation,
                              cancelOnError: false,
                              partialResults: false,
                              onResult: (result) {
                                setState(() {
                                  _currentWords = result.recognizedWords;
                                  _lastWords += " $_currentWords";
                                  otctl.value =
                                      TextEditingValue(text: _lastWords);

                                  print(_lastWords);
                                  print(_currentWords);
                                });
                              },
                            );
                            _currentWords = "";
                          });
                        }
                      }
                    },
                    onTapUp: (details) {
                      setState(() {
                        isListening = false;
                        speachSessionActive = false;
                      });
                      print("tapup");
                      print(speachSessionActive);
                      _stopListening();
                    },
                    onTapCancel: () {
                      setState(() {
                        // isListening = false;
                        speachSessionActive = false;
                      });
                      print("tapcancel");
                      print(speachSessionActive);
                      _stopListening();
                    },
                    child: CircleAvatar(
                      backgroundColor: ColorsX.appBarColor,
                      radius: 35,
                      child: Icon(
                        speachSessionActive ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ]),
    );
  }

  singleChoiceWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: SizeConfig.screenHeight * 0.5,
      width: GlobalVariables.ScrWidth,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount:
            listOfAllQuestions[GlobalVariables.currentIndex]['options'].length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
            controlAffinity: ListTileControlAffinity.leading,
            value: listOfAllQuestions[GlobalVariables.currentIndex]['options']
                [index],
            groupValue: _groupValue,
            activeColor: ColorsX.appBarColor,
            selected: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: globalWidgets.myTextRaleway(
                      context,
                      listOfAllQuestions[GlobalVariables.currentIndex]
                          ['options'][index],
                      ColorsX.black,
                      0,
                      0,
                      0,
                      0,
                      FontWeight.w400,
                      16),
                ),
              ],
            ),
            onChanged: (newValue) => setState(() => _groupValue = newValue!),
          );
        },
      ),
    );
  }

  multipleChoiceWidget(BuildContext context) {
    List options = listOfAllQuestions[GlobalVariables.currentIndex]['options'];
    return MultipleChoiceQuestionWidget(options: options);
  }
// Function to count questions containing the search string
  // katharina work
  int countQuestionsContaining(String searchString) {
    return listOfAllQuestions.where((question) => question["section"] == searchString).length;
  }

  multipleRatingWidget(BuildContext context) {
    //katharina work
    //getting all questions of location related questions for details
    int count = countQuestionsContaining("Fragen zu jeweiligem Ort: ");
    debugPrint("count is"+count.toString());
    List options = listOfAllQuestions[GlobalVariables.currentIndex]['options'];
    List minimum = listOfAllQuestions[GlobalVariables.currentIndex]['minimum'];
    List maximum = listOfAllQuestions[GlobalVariables.currentIndex]['maximum'];
    List interval =
        listOfAllQuestions[GlobalVariables.currentIndex]['interval'];
    if (selectedLinearScaleValue.length == 0) {
      for (int i = 0; i < options.length; i++) {
        selectedLinearScaleValue.add(("-1").toString());
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: SizeConfig.screenHeight * 0.5,
      width: GlobalVariables.ScrWidth,
      child: (listOfAllQuestions[GlobalVariables.currentIndex]['section'] ==
          "Fragen zu jeweiligem Ort: ") ? ListView.builder(
          padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * .02),
          shrinkWrap: true,
          // itemCount: options.length,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return RawMaterialButton(
                padding: const EdgeInsets.all(5.0),
                splashColor: Colors.transparent,
                onPressed: () {},
                child: Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * .60,
                      child: globalWidgets.myTextRaleway(
                          context,
                          options[index],
                          ColorsX.black,
                          0,
                          0,
                          0,
                          0,
                          FontWeight.w400,
                          16),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      scaleRating(
                          context,
                          int.parse(minimum[index]),
                          int.parse(maximum[index]),
                          int.parse(interval[index]),
                          index)
                    ]),
                  ],
                ));
          }) : ListView.builder(
          padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * .05),
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return RawMaterialButton(
                padding: const EdgeInsets.all(20.0),
                splashColor: Colors.transparent,
                onPressed: () {},
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                        width: SizeConfig.screenWidth * .60,
                        child: globalWidgets.myTextRaleway(
                            context,
                            options[index],
                            ColorsX.black,
                            0,
                            0,
                            0,
                            0,
                            FontWeight.w400,
                            16),
                      )),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    scaleRating(
                        context,
                        int.parse(minimum[index]),
                        int.parse(maximum[index]),
                        int.parse(interval[index]),
                        index)
                  ])
                ]));
          }),
    );
  }
  ratingWidget(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        initialRating = rating;
        print(rating);
      },
    );
  }

  rangeWidget(BuildContext context) {
    // _currentRangeValues = RangeValues(
    //     double.parse(
    //         listOfAllQuestions[GlobalVariables.currentIndex]['range_starting']),
    //     double.parse(
    //         listOfAllQuestions[GlobalVariables.currentIndex]['range_ending']));
    // // _currentRangeValues = RangeValues(1,70);
    // return RangeSlider(
    //   values: _currentRangeValues,
    //   min: double.parse(
    //       listOfAllQuestions[GlobalVariables.currentIndex]['range_starting']),
    //   max: double.parse(
    //       listOfAllQuestions[GlobalVariables.currentIndex]['range_ending']),
    //   divisions: 100,
    //   // int.parse(listOfAllQuestions[GlobalVariables.currentIndex]['range_ending']),
    //   inactiveColor: ColorsX.yellowColor,
    //   activeColor: ColorsX.appBarColor,
    //   semanticFormatterCallback:
    //       ageValuesRange(_currentRangeValues.start, _currentRangeValues.end),
    //   labels: RangeLabels(
    //     _currentRangeValues.start.round().toString(),
    //     _currentRangeValues.end.round().toString(),
    //   ),
    //   onChanged: (RangeValues values) {
    //     setState(() {
    //       _currentRangeValues = values;
    //       start_age = _currentRangeValues.start.toStringAsFixed(0);
    //       end_age = _currentRangeValues.end.toStringAsFixed(0);
    //       debugPrint(values.toString());
    //       debugPrint(start_age.toString());
    //       debugPrint(end_age.toString());
    //     });
    //   },
    // );
    if (selectedLinearScaleValue.length == 0) {
      selectedLinearScaleValue.add(("-1").toString());
    }
    return SleekCircularSlider(
      min: 0,
      max: 100,
      initialValue: 30,
      appearance: CircularSliderAppearance(
        size: SizeConfig.screenWidth * .35,
      ),
      onChange: (double value) {
        // callback providing a value while its being changed (with a pan gesture)
        selectedLinearScaleValue[0] = value.toString();
      },
      onChangeStart: (double startValue) {
        // callback providing a starting value (when a pan gesture starts)
      },
      onChangeEnd: (double endValue) {
        // ucallback providing an ending value (when a pan gesture ends)
      },
      innerWidget: (double value) {
        // use your custom widget inside the slider (gets a slider value from the callback)
        return Center(
            child: globalWidgets.myText(
                context,
                value.toStringAsFixed(0) + ' %',
                ColorsX.black,
                0,
                0,
                0,
                0,
                FontWeight.w600,
                18));
      },
    );
  }

  scaleRating(BuildContext context, int min, int max, int interv, int Ano) {
    String value =
        "${listOfAllQuestions[GlobalVariables.currentIndex]['max_value']}" ==
                "null"
            ? "0"
            : "${listOfAllQuestions[GlobalVariables.currentIndex]['max_value']}";
    dynamicLinearScaleValue = int.parse(value);
    if (dynamicLinearScaleValue != 0) {
      max = dynamicLinearScaleValue;
      selectedLinearScaleValue.add(("-1").toString());
    }
    debugPrint("$value");
    return Expanded(
        child: Container(
      width: SizeConfig.screenWidth * 0.7,
      child: Wrap(
        spacing: 8,
        children: [
          for (int index = min; index < max; index += interv)
            scaleRatingItem(context, index, (index).toString(), Ano),
          // for (int i = 0; i < GlobalVariables.myMarkers.length; i++)
          // if (listOfAllQuestions[GlobalVariables.currentIndex]['section'] ==
          //     "Fragen zu jeweiligem Ort: ") //Katharina_Work
          //   startTimer(context, GlobalVariables.myMarkers, Ano, min, max, interv, Ano)
            // Ano != 2 ? startTimer(context, GlobalVariables.myMarkers, Ano, min, max, interv, Ano):
            // mapImages(context, GlobalVariables.myMarkers, Ano),
          // Wrap(
          //   spacing: 8,
          //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     for (int index = min; index < max; index += interv)
          //       scaleRatingItem(context, index, (index).toString(), Ano),
          //   ],
          // ),
        ],
      ),
    ));
  }

  startTimer(
    BuildContext context,
    List<osm.GeoPoint> myMarkers,
    int index,
    // int min,
    // int max,
    // int interv,
    // int ano,
  ) {
    return Container(
      child: FutureBuilder(
        future: _delay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the Future is still running, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            // Once the Future is complete, show the widget
            return mapImages(context, GlobalVariables.myMarkers, index);
          } else {
            // Handle possible errors
            return Text("Error occurred!");
          }
        },
      ),
    );
    // return mapImages(context, GlobalVariables.myMarkers, index,min, max,  interv, ano);
  }

  Future<void> _delay() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  agesDropdown(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: 50,
      margin: EdgeInsets.only(top: 5, right: 10, left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsX.subBlack),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(ageValue),
        underline: SizedBox(),
        value: ageValue,
        //elevation: 5,
        style: TextStyle(color: Colors.black, fontSize: 14),
        icon: Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.arrow_drop_down,
            color: ColorsX.subBlack,
          ),
        ),
        items: GlobalVariables.agesList
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(right: SizeConfig.marginVerticalXXsmall),
              child: globalWidgets.myText(context, value, ColorsX.black, 0, 10,
                  0, 0, FontWeight.w400, 15),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            ageValue = value!;
            print(ageValue);
          });
        },
      ),
    );
  }

  scaleRatingItem(BuildContext context, int index, String value, int Ano) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLinearScaleValue[Ano] = value;
        });
      },
      child: Container(
        height: 50,
        width: 30,
        decoration: BoxDecoration(
            color: selectedLinearScaleValue[Ano] == value
                ? ColorsX.appBarColor
                : ColorsX.subBlack,
            shape: BoxShape.circle),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: globalWidgets.myTextRaleway(
                context, value, ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 11),
          ),
        ),
      ),
    );
  }

  ageValuesRange(double start, double end) {
    debugPrint(start.toStringAsFixed(0));
    debugPrint(end.toStringAsFixed(0));
  }

  nextQuestion(BuildContext context) {
    return GestureDetector(
      onTap: () {

        if (listOfAllQuestions[GlobalVariables.currentIndex]['section'] == 'Fragen zu jeweiligem Ort: ') {

            mapCounter = mapCounter++;

        }
        if (listOfAllQuestions[GlobalVariables.currentIndex]['question_type'] ==
            'Yes No') {
          debugPrint(_groupValue);
          if (_groupValue == 'Any') {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': _groupValue,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            _groupValue = 'Any';
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Single Choice') {
          debugPrint(_groupValue);
          if (_groupValue == 'Any') {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': _groupValue,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            _groupValue = 'Any';
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Multiple Choice') {
          debugPrint(GlobalVariables.LIST_OF_MC_RESULTS.toString());
          if (GlobalVariables.LIST_OF_MC_RESULTS.isEmpty) {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': GlobalVariables.LIST_OF_MC_RESULTS,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            GlobalVariables.LIST_OF_MC_RESULTS = [];
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Multiple Rating') {
          if (selectedLinearScaleValue.obs.contains("-1")) {
            //selectedLinearScaleValue == '' //Katharina_Work
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': selectedLinearScaleValue.obs,
              'Q_type': 'Multiple Rating',
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            selectedLinearScaleValue.clear();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Rating') {
          if (initialRating == 0) {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': initialRating,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Linear Scale') {
          if (selectedLinearScaleValue == '') {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': selectedLinearScaleValue,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            dynamicLinearScaleValue = 0;
            selectedLinearScaleValue.clear();
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Drop down') {
          if (ageValue == 'Alter auswählen') {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': ageValue,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            ageValue = 'Alter auswählen';
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Range') {
          if (selectedLinearScaleValue == '') {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': selectedLinearScaleValue.obs,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            dynamicLinearScaleValue = 0;
            selectedLinearScaleValue.clear();
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Map') {
          if (GlobalVariables.coordinates.isEmpty &&
              GlobalVariables.myMarkers.isEmpty) {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else if (GlobalVariables.myMarkers.length < 3) {
            GlobalWidgets.showToast('Please mark at least three locations'.tr);
          } else {
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': GlobalVariables.myMarkers.toString(),
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        } else if (listOfAllQuestions[GlobalVariables.currentIndex]
                ['question_type'] ==
            'Open Text') {
          debugPrint(GlobalVariables.LIST_OF_MC_RESULTS.toString());
          if (otctl.text.isEmpty) {
            GlobalWidgets.showToast('Please answer the question'.tr);
          } else {
            FocusManager.instance.primaryFocus?.unfocus();
            questionEndTime = DateTime.now();
            Duration engagementTime =
                questionEndTime.difference(questionStartTime);
            Map<String, dynamic> map = {
              'answer': otctl.text,
              'suggestion': ctl.text.isEmpty ? "" : ctl.text,
              'time': engagementTime.toString()
            };
            GlobalVariables.LIST_OF_ALL_ANSWERS.add(map);
            debugPrint(GlobalVariables.LIST_OF_ALL_ANSWERS.toString());
            _stopListening();
            _lastWords = "";
            _currentWords = "";
            otctl.clear();
            questionStartTime = DateTime.now();
            checkLastQuestion();
          }
        }
        debugPrint("map counter"+mapCounter.toString());
      },
      child: Container(
        width: GlobalVariables.ScrWidth,
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: listOfAllQuestions.length - GlobalVariables.currentIndex == 1
              ? ColorsX.appBarColor
              : ColorsX.appBarColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: globalWidgets.myTextRaleway(
                context,
                listOfAllQuestions.length - GlobalVariables.currentIndex == 1
                    ? "Submit Survey".tr
                    : "Next QUESTION".tr,
                ColorsX.white,
                0,
                0,
                0,
                0,
                FontWeight.w600,
                17),
          ),
        ),
      ),
    );
  }

  void checkLastQuestion() async {
    if (listOfAllQuestions.length - GlobalVariables.currentIndex == 1) {
      // GlobalWidgets.showToast('finish');
      var parentDocRef = FirebaseFirestore.instance
          .collection('surveys')
          .doc(GlobalVariables.idOfSurvey);
      DateTime date = DateTime.now();
      String d = DateFormat('dd.MM.yyyy – HH:mm').format(date);
      print(d);
      Map<String, dynamic> data = {
        'result': GlobalVariables.LIST_OF_ALL_ANSWERS,
        'answer_date': d
      };
      addMapToSubcollection(parentDocRef, 'results', data);
      // setState(() {
      GlobalVariables.currentIndex = 0;
      GlobalVariables.LIST_OF_ALL_ANSWERS = [];
      GlobalVariables.myMarkers = [];
      GlobalVariables.coordinates = [];
      // });
      submitDialog(context);
    } else {
      // setState(() {
      GlobalVariables.currentIndex = GlobalVariables.currentIndex + 1;
      // });
      ctl.clear();

      carouselController.jumpToPage(GlobalVariables.currentIndex);
      // clearSpeechRecognition();
    }
  }

  submitDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        body: Column(
          children: [
            globalWidgets.myTextRaleway(context, "Survey Finished",
                ColorsX.black, 10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                'Thank you for sharing your thoughts',
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.QRCODE_SCREEN);
              },
              child: Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: listOfAllQuestions.length -
                              GlobalVariables.currentIndex ==
                          1
                      ? ColorsX.appBarColor
                      : ColorsX.buttonBackground,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: globalWidgets.myTextRaleway(context, "Share QR ",
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
                  ),
                ),
              ),
            ),
          ],
        ), //
        btnOkOnPress: () async {
          if (FirebaseAuth.instance.currentUser == null) {
            Get.toNamed(Routes.INITIAL_SCREEN);
          } else {
            Get.toNamed(Routes.MAIN_PAGE);
          }
        },
        btnOkIcon: Icons.check_circle,
        btnOkColor: ColorsX.appBarColor)
      ..show();
  }

  void addMapToSubcollection(DocumentReference parentDocRef,
      String subcollectionName, Map<String, dynamic> data) {
    CollectionReference subcollectionRef =
        parentDocRef.collection(subcollectionName);
    subcollectionRef.add(data);
  }

  // mapImages(BuildContext context, List<osm.GeoPoint> myMarkers, int index) {
  //   // default constructor
  //   // osm.MapController mycontroller = osm.MapController.withPosition(
  //   //   initPosition: osm.GeoPoint(
  //   //     latitude: myMarkers[index].latitude,
  //   //     longitude: myMarkers[index].longitude,
  //   //   ),
  //   // );
  //   debugPrint(myMarkers[index].latitude.toString());
  //   return Column(
  //     children: [
  //       Container(
  //         height: SizeConfig.screenHeight * .15,
  //         width: SizeConfig.screenWidth,
  //         child: Stack(
  //           children: [
  //             Image.memory(
  //               GlobalVariables.screenshots[index],
  //               fit: BoxFit.fitWidth,
  //             ),
  //           // osm.OSMFlutter(
  //           //   controller: mycontroller,
  //           //   osmOption: osm.OSMOption(
  //           //     showDefaultInfoWindow: true,
  //           //     showZoomController: true,
  //           //     zoomOption: const osm.ZoomOption(
  //           //       initZoom: 15,
  //           //       maxZoomLevel: 15,
  //           //       minZoomLevel: 15,
  //           //     ),
  //           //     userLocationMarker: osm.UserLocationMaker(
  //           //       personMarker: osm.MarkerIcon(
  //           //         icon: Icon(
  //           //           Icons.location_history_rounded,
  //           //           color: Colors.red,
  //           //           size: 48,
  //           //         ),
  //           //       ),
  //           //       directionArrowMarker: osm.MarkerIcon(
  //           //         icon: Icon(
  //           //           Icons.double_arrow,
  //           //           size: 48,
  //           //         ),
  //           //       ),
  //           //     ),
  //           //   ),
  //           //   onMapIsReady: (bool isReady) {
  //           //     print("Map is ready: $isReady");
  //           //     if (isReady) {
  //           //       _addMarkersImagesForQuestions(mycontroller,
  //           //           myMarkers[index]); // Add markers when the map is ready
  //           //     }
  //           //   },
  //           // ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  mapImages(BuildContext context, List<osm.GeoPoint> myMarkers, int index) {
    // default constructor
    osm.MapController mycontroller = osm.MapController.withPosition(
      initPosition: osm.GeoPoint(
        latitude: myMarkers[index].latitude,
        longitude: myMarkers[index].longitude,
      ),
    );
    debugPrint(myMarkers[index].latitude.toString());
    return Column(
      children: [
        Container(
          height: SizeConfig.screenHeight * .10,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [
              osm.OSMFlutter(
              controller: mycontroller,
              osmOption: osm.OSMOption(
                showDefaultInfoWindow: true,
                showZoomController: true,
                zoomOption: const osm.ZoomOption(
                  initZoom: 15,
                  maxZoomLevel: 15,
                  minZoomLevel: 15,
                ),
                userLocationMarker: osm.UserLocationMaker(
                  personMarker: osm.MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: osm.MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
              ),
              onMapIsReady: (bool isReady) {
                print("Map is ready: $isReady");
                if (isReady) {
                  _addMarkersImagesForQuestions(mycontroller,
                      myMarkers[index]); // Add markers when the map is ready
                }
              },
            ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addMarkersImagesForQuestions(
      osm.MapController mycontroller, osm.GeoPoint point) async {
    // setState(() async {
      await mycontroller.addMarker(
        point,
        markerIcon: osm.MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );

      // // Capture screenshot using RepaintBoundary's key
      // RenderRepaintBoundary boundary =
      // globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // var image = await boundary.toImage();
      // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      // Uint8List imageBytes = byteData!.buffer.asUint8List();
      //
      // // Resize the image to 30x30 using 'image' package
      // img.Image? decodedImage = img.decodeImage(imageBytes);
      // img.Image resizedImage = img.copyResize(decodedImage!, width: 30, height: 30);
      //
      // // Save the image to the app's directory
      // final directory = await getApplicationDocumentsDirectory();
      // final imagePath = '${directory.path}/marker_image_${DateTime.now().millisecondsSinceEpoch}.png';
      //
      // // Save resized image to file
      // final File imageFile = File(imagePath)..writeAsBytesSync(img.encodePng(resizedImage));
      //
      // // Update the saved images list
      // setState(() {
      //   _savedImageBytesList.add(imageFile.readAsBytesSync());
      // });
      //
      // print("Image saved at: $imagePath");
    // });
  }
}

class CheckboxListTileModel {
  int id;
  String title;
  bool isChecked;
  TextEditingController textCtl = TextEditingController();

  CheckboxListTileModel(
      {required this.id, required this.title, required this.isChecked});
}
