import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';

import '../global/colors.dart';
import '../global/size_config.dart';

class EditQuestionScreen extends StatefulWidget {
  const EditQuestionScreen({Key? key}) : super(key: key);
  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  TextEditingController questionCtl = TextEditingController();
  TextEditingController optionOneCtl = TextEditingController();
  TextEditingController optionTwoCtl = TextEditingController();
  TextEditingController optionThreeCtl = TextEditingController();
  TextEditingController dynamicScaleValueCtl = TextEditingController();
  // static String sectionValue = "Select Section";
  String _groupValue = 'Any';
  RxString questionText = GlobalVariables.QUESTION_TYPE == "Single Choice"
      ? 'Add your question here'.tr.obs
      : GlobalVariables.QUESTION_TYPE == "Yes No"
          ? 'Add your question here'.tr.obs
          : GlobalVariables.QUESTION_TYPE == "Open Text"
              ? 'Add your question here'.tr.obs
              : GlobalVariables.QUESTION_TYPE == "Range"
                  ? 'Add your question here'.tr.obs
                  : GlobalVariables.QUESTION_TYPE == "Rating"
                      ? 'Add your question here'.tr.obs
                      : GlobalVariables.QUESTION_TYPE == "Linear Scale"
                          ? 'Add your question here'.tr.obs
                          : "Add your question here".tr.obs;
  RxString optionOneText = "This is option ".obs;
  RxString optionTwoText = "This is option ".obs;
  RxString optionThreeText = "This is option ".obs;
  List<String> listOfOptions = [];
  List<String> minlistOfOptions = [];
  List<String> maxlistOfOptions = [];
  List<String> interlistOfOptions = [];
  List<RadioListTileModel> radioListTiles = []; // List to hold checkbox models
  List<CheckboxListTileModel> checkboxListTiles = [];
  List<MultiRatingTileModel> multiratingTiles = [];
  int counter = 0; // Counter for unique checkbox IDs
  String start_age = '';
  String end_age = '';
  RangeValues _currentRangeValues = const RangeValues(1, 100);

  @override
  void initState() {
    super.initState();

    if (GlobalVariables.Fetched_Document != null) {
      List<dynamic> listOfAllOptions = [];
      List<dynamic> minlistAllOptions = [];
      List<dynamic> maxlistAllOptions = [];
      List<dynamic> interlistAllOptions = [];
      questionText.value = GlobalVariables.Fetched_Document?['questions']
          [GlobalWidgets.pwdWidgets.length]['question'];
      if (GlobalVariables.QUESTION_TYPE == "Single Choice") {
        listOfAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['options'];
        for (String a in listOfAllOptions) {
          radioListTiles.add(RadioListTileModel(id: counter.obs, title: a.obs));
          counter++;
        }
      } else if (GlobalVariables.QUESTION_TYPE == "Multiple Choice") {
        listOfAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['options'];
        for (String a in listOfAllOptions) {
          checkboxListTiles.add(CheckboxListTileModel(
              id: counter.obs, title: a.obs, isChecked: false));
          counter++;
        }
      } else if (GlobalVariables.QUESTION_TYPE == "Multiple Rating") {
        listOfAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['options'];
        minlistAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['minimum'];
        maxlistAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['maximum'];
        interlistAllOptions = GlobalVariables.Fetched_Document?['questions']
            [GlobalWidgets.pwdWidgets.length]['interval'];
        for (; counter < listOfAllOptions.length;) {
          multiratingTiles.add(MultiRatingTileModel(
            id: counter.obs,
            title: listOfAllOptions[counter].toString().obs,
            minimum: int.parse(minlistAllOptions[counter]).obs,
            maximum: int.parse(maxlistAllOptions[counter]).obs,
            interval: int.parse(interlistAllOptions[counter]).obs,
          ));
          counter++;
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => CheckforRecreation());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
          return false;
        },
        child: Container(
          child: Stack(
            children: [
              Container(
                height: SizeConfig.screenHeight * .15,
                decoration: const BoxDecoration(color: ColorsX.appBarColor),
              ),
              Container(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.screenHeight * .015),
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * .16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: question(context)),
                    // globalWidgets.myTextRaleway(
                    //     context,
                    //     'Select your section to categorise the question'.tr,
                    //     ColorsX.black,
                    //     20,
                    //     20,
                    //     20,
                    //     10,
                    //     FontWeight.w500,
                    //     14),
                    // sectionDropdown(),
                    saveQuestionButton(context)
                  ],
                ),
              ),
              Visibility(
                visible: GlobalVariables.QUESTION_TYPE == 'Single Choice' ||
                    GlobalVariables.QUESTION_TYPE == 'Multiple Choice' ||
                    GlobalVariables.QUESTION_TYPE == 'Multiple Rating',
                child: Container(
                  padding: EdgeInsets.only(
                      right: SizeConfig.screenHeight * .015,
                      bottom: SizeConfig.screenHeight * .1),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      backgroundColor: ColorsX.appBarColor,
                      heroTag: 'bottom_sheet',
                      onPressed: () {
                        if (GlobalVariables.QUESTION_TYPE == 'Single Choice') {
                          setState(() {
                            radioListTiles.add(RadioListTileModel(
                              // Create a new RadioListTile model and add it to the list
                              id: counter.obs,
                              title: "Edit option".tr.obs,
                            ));
                            counter++;
                          });
                        } else if (GlobalVariables.QUESTION_TYPE ==
                            'Multiple Choice') {
                          setState(() {
                            checkboxListTiles.add(CheckboxListTileModel(
                              // Create a new checkbox model and add it to the list
                              id: counter.obs,
                              title: "Edit option".tr.obs,
                              isChecked: false,
                            ));
                            counter++;
                          });
                        } else if (GlobalVariables.QUESTION_TYPE ==
                            'Multiple Rating') {
                          dynamicScaleDialog(context, dynamicScaleValueCtl);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: globalWidgets.myTextRaleway(
                          context,
                          'Add Options'.tr,
                          ColorsX.white,
                          0,
                          0,
                          0,
                          0,
                          FontWeight.w500,
                          14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  sectionDropdown() {
    return Container(
      width: SizeConfig.screenWidth,
      height: 50,
      margin: const EdgeInsets.only(top: 5, right: 20, left: 20),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsX.black),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(GlobalVariables.sectionValue),
        underline: const SizedBox(),
        value: GlobalVariables.sectionValue,
        //elevation: 5,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        icon: Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(
            Icons.arrow_drop_down,
            color: ColorsX.black,
          ),
        ),
        items: GlobalVariables.SECTIONS_LIST
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(right: SizeConfig.marginVerticalXXsmall),
              child: globalWidgets.myTextRaleway(context, value, ColorsX.black,
                  0, 10, 0, 0, FontWeight.w400, 15),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            GlobalVariables.sectionValue = value!;
            print(GlobalVariables.sectionValue);
          });
        },
      ),
    );
  }

  Widget question(BuildContext context) {
    return GlobalVariables.QUESTION_TYPE == "Single Choice"
        ? Column(
            children: [
              Visibility(
                visible: true,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: globalWidgets.myTextRaleway(
                        context,
                        GlobalVariables.sectionValue,
                        ColorsX.black,
                        10,
                        10,
                        10,
                        0,
                        FontWeight.w400,
                        12)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(() => SizedBox(
                      width: SizeConfig.screenWidth * .70,
                      child: globalWidgets.myTextRaleway(
                          context,
                          questionText.value,
                          Colors.black,
                          10,
                          10,
                          10,
                          10,
                          FontWeight.w500,
                          17))),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      openEditQuestionDilog(context, questionCtl,
                          'Edit question', 'Add a question you want to ask');
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
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Get.currentRoute == "/edit-question-screen") return;
                      openDeleteQuestionDilog(context, questionCtl,
                          'Edit question', 'Add a question you want to ask');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Icon(
                        Icons.delete,
                        color: ColorsX.appBarColor,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
              SizedBox(
                  height: SizeConfig.screenHeight * 0.4,
                  child: ListView.builder(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.screenHeight * .05),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: radioListTiles.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<String>(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: radioListTiles[index].title.value,
                        groupValue: _groupValue,
                        activeColor: ColorsX.appBarColor,
                        selected: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(radioListTiles[index].title.value),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: () {
                                openEditOptionDilog(
                                    context,
                                    radioListTiles[index].textCtl,
                                    'Edit option'.tr,
                                    'Edit your first option',
                                    index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const Icon(
                                  Icons.edit,
                                  color: ColorsX.appBarColor,
                                ),
                              ),
                            ),
                            Container(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                openDeleteDilog(context, index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: const Icon(
                                  Icons.delete,
                                  color: ColorsX.appBarColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue!),
                      );
                    },
                  )),
            ],
          )
        : GlobalVariables.QUESTION_TYPE == "Yes No"
            ? Column(
                children: [
                  Visibility(
                    visible: true,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: globalWidgets.myTextRaleway(
                            context,
                            GlobalVariables.sectionValue,
                            ColorsX.black,
                            10,
                            10,
                            10,
                            0,
                            FontWeight.w400,
                            12)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Obx(() => SizedBox(
                          width: SizeConfig.screenWidth * .70,
                          child: globalWidgets.myTextRaleway(
                              context,
                              questionText.value,
                              Colors.black,
                              10,
                              10,
                              10,
                              10,
                              FontWeight.w500,
                              17))),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          openEditQuestionDilog(
                              context,
                              questionCtl,
                              'Edit question',
                              'Add a question you want to ask');
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
                    title: globalWidgets.myTextRaleway(context, 'Yes'.tr,
                        Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    activeColor: ColorsX.appBarColor,
                    selected: false,
                  ),
                  RadioListTile<String>(
                    value: 'No',
                    groupValue: _groupValue,
                    title: globalWidgets.myTextRaleway(context, 'No'.tr,
                        Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    activeColor: ColorsX.appBarColor,
                    selected: false,
                  ),
                ],
              )
            : GlobalVariables.QUESTION_TYPE == "Open Text"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: true,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: globalWidgets.myTextRaleway(
                                context,
                                GlobalVariables.sectionValue,
                                ColorsX.black,
                                10,
                                10,
                                10,
                                0,
                                FontWeight.w400,
                                12)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Obx(() => SizedBox(
                              width: SizeConfig.screenWidth * .70,
                              child: globalWidgets.myTextRaleway(
                                  context,
                                  questionText.value,
                                  Colors.black,
                                  10,
                                  10,
                                  10,
                                  10,
                                  FontWeight.w500,
                                  17))),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              openEditQuestionDilog(
                                  context,
                                  questionCtl,
                                  'Edit question',
                                  'Add a question you want to ask');
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
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (Get.currentRoute == "/edit-question-screen")
                                return;
                              openDeleteQuestionDilog(
                                  context,
                                  questionCtl,
                                  'Edit question',
                                  'Add a question you want to ask');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Icon(
                                Icons.delete,
                                color: ColorsX.appBarColor,
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 40),
                        ),
                      ),
                    ],
                  )
                : GlobalVariables.QUESTION_TYPE == "Range"
                    ? Column(
                        children: [
                          Visibility(
                            visible: true,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: globalWidgets.myTextRaleway(
                                    context,
                                    GlobalVariables.sectionValue,
                                    ColorsX.black,
                                    10,
                                    10,
                                    10,
                                    0,
                                    FontWeight.w400,
                                    12)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Obx(() => SizedBox(
                                  width: SizeConfig.screenWidth * .70,
                                  child: globalWidgets.myTextRaleway(
                                      context,
                                      questionText.value,
                                      Colors.black,
                                      10,
                                      10,
                                      10,
                                      10,
                                      FontWeight.w500,
                                      17))),
                              Expanded(child: Container()),
                              GestureDetector(
                                onTap: () {
                                  openEditQuestionDilog(
                                      context,
                                      questionCtl,
                                      'Edit question',
                                      'Add a question you want to ask');
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
                          ageLimit(context),
                        ],
                      )
                    : GlobalVariables.QUESTION_TYPE == "Rating"
                        ? Column(
                            children: [
                              Visibility(
                                visible: true,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: globalWidgets.myTextRaleway(
                                        context,
                                        GlobalVariables.sectionValue,
                                        ColorsX.black,
                                        10,
                                        10,
                                        10,
                                        0,
                                        FontWeight.w400,
                                        12)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Obx(() => SizedBox(
                                      width: SizeConfig.screenWidth * .70,
                                      child: globalWidgets.myTextRaleway(
                                          context,
                                          questionText.value,
                                          Colors.black,
                                          10,
                                          10,
                                          10,
                                          10,
                                          FontWeight.w500,
                                          17))),
                                  Expanded(child: Container()),
                                  GestureDetector(
                                    onTap: () {
                                      openEditQuestionDilog(
                                          context,
                                          questionCtl,
                                          'Edit question',
                                          'Add a question you want to ask');
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
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.currentRoute ==
                                          "/edit-question-screen") return;
                                      openDeleteQuestionDilog(
                                          context,
                                          questionCtl,
                                          'Edit question',
                                          'Add a question you want to ask');
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Icon(
                                        Icons.delete,
                                        color: ColorsX.appBarColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              ratingBar(context),
                            ],
                          )
                        : GlobalVariables.QUESTION_TYPE == "Linear Scale"
                            ? Column(
                                children: [
                                  Visibility(
                                    visible: true,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: globalWidgets.myTextRaleway(
                                            context,
                                            GlobalVariables.sectionValue,
                                            ColorsX.black,
                                            10,
                                            10,
                                            10,
                                            0,
                                            FontWeight.w400,
                                            12)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Obx(() => SizedBox(
                                          width: SizeConfig.screenWidth * .70,
                                          child: globalWidgets.myTextRaleway(
                                              context,
                                              questionText.value,
                                              Colors.black,
                                              10,
                                              10,
                                              10,
                                              10,
                                              FontWeight.w500,
                                              17))),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                        onTap: () {
                                          openEditQuestionDilog(
                                              context,
                                              questionCtl,
                                              'Edit question',
                                              'Add a question you want to ask');
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
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
                                  //scaleRating(context),
                                ],
                              )
                            : GlobalVariables.QUESTION_TYPE == "Multiple Choice"
                                ? Column(
                                    children: [
                                      Visibility(
                                        visible: true,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: globalWidgets.myTextRaleway(
                                                context,
                                                GlobalVariables.sectionValue,
                                                ColorsX.black,
                                                10,
                                                10,
                                                10,
                                                0,
                                                FontWeight.w400,
                                                12)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Obx(() => SizedBox(
                                              width:
                                                  SizeConfig.screenWidth * .70,
                                              child:
                                                  globalWidgets.myTextRaleway(
                                                      context,
                                                      questionText.value,
                                                      Colors.black,
                                                      10,
                                                      10,
                                                      10,
                                                      10,
                                                      FontWeight.w500,
                                                      17))),
                                          Expanded(child: Container()),
                                          GestureDetector(
                                            onTap: () {
                                              openEditQuestionDilog(
                                                  context,
                                                  questionCtl,
                                                  'Edit question',
                                                  'Add a question you want to ask');
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: const Icon(
                                                Icons.edit,
                                                color: ColorsX.appBarColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (Get.currentRoute ==
                                                  "/edit-question-screen")
                                                return;
                                              openDeleteQuestionDilog(
                                                  context,
                                                  questionCtl,
                                                  'Edit question',
                                                  'Add a question you want to ask');
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: const Icon(
                                                Icons.delete,
                                                color: ColorsX.appBarColor,
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                        ],
                                      ),
                                      SizedBox(
                                          height: SizeConfig.screenHeight * 0.4,
                                          child: ListView.builder(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.screenHeight *
                                                        .05),
                                            shrinkWrap: true,
                                            itemCount: checkboxListTiles.length,
                                            itemBuilder: (context, index) {
                                              return CheckboxListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: checkboxListTiles[index]
                                                    .isChecked,
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        checkboxListTiles[index]
                                                            .title
                                                            .value),
                                                    Expanded(
                                                        child: Container()),
                                                    GestureDetector(
                                                      onTap: () {
                                                        openEditOptionDilog(
                                                            context,
                                                            checkboxListTiles[
                                                                    index]
                                                                .textCtl,
                                                            'Edit option'.tr,
                                                            'Edit your first option',
                                                            index);
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        child: const Icon(
                                                          Icons.edit,
                                                          color: ColorsX
                                                              .appBarColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        openDeleteDilog(
                                                            context, index);
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        child: const Icon(
                                                          Icons.delete,
                                                          color: ColorsX
                                                              .appBarColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkboxListTiles[index]
                                                        .isChecked = value!;
                                                  });
                                                },
                                              );
                                            },
                                          )),
                                    ],
                                  )
                                : GlobalVariables.QUESTION_TYPE ==
                                        "Multiple Rating"
                                    ? Column(
                                        children: [
                                          Visibility(
                                            visible: true,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                    globalWidgets.myTextRaleway(
                                                        context,
                                                        GlobalVariables
                                                            .sectionValue,
                                                        ColorsX.black,
                                                        10,
                                                        10,
                                                        10,
                                                        0,
                                                        FontWeight.w400,
                                                        12)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Obx(() => SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          .80,
                                                  child: globalWidgets
                                                      .myTextRaleway(
                                                          context,
                                                          questionText.value,
                                                          Colors.black,
                                                          10,
                                                          10,
                                                          10,
                                                          10,
                                                          FontWeight.w500,
                                                          17))),
                                              Expanded(child: Container()),
                                              GestureDetector(
                                                onTap: () {
                                                  openEditQuestionDilog(
                                                      context,
                                                      questionCtl,
                                                      'Edit question',
                                                      'Add a question you want to ask');
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: ColorsX.appBarColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (Get.currentRoute ==
                                                      "/edit-question-screen")
                                                    return;
                                                  openDeleteQuestionDilog(
                                                      context,
                                                      questionCtl,
                                                      'Edit question',
                                                      'Add a question you want to ask');
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: ColorsX.appBarColor,
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  SizeConfig.screenHeight * 0.4,
                                              child: ListView.builder(
                                                padding: EdgeInsets.only(
                                                    bottom: SizeConfig
                                                            .screenHeight *
                                                        .05),
                                                shrinkWrap: true,
                                                itemCount:
                                                    multiratingTiles.length,
                                                itemBuilder: (context, index) {
                                                  return RawMaterialButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      splashColor:
                                                          Colors.transparent,
                                                      onPressed: () {},
                                                      child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(multiratingTiles[
                                                                        index]
                                                                    .title
                                                                    .value),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    openEditOptionDilog(
                                                                        context,
                                                                        multiratingTiles[index]
                                                                            .textCtl,
                                                                        'Edit option'
                                                                            .tr,
                                                                        'Edit your first option',
                                                                        index);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: ColorsX
                                                                          .appBarColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 30,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    openDeleteDilog(
                                                                        context,
                                                                        index);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: ColorsX
                                                                          .appBarColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  scaleRating(
                                                                      context,
                                                                      multiratingTiles[
                                                                              index]
                                                                          .minimum
                                                                          .value,
                                                                      multiratingTiles[
                                                                              index]
                                                                          .maximum
                                                                          .value,
                                                                      multiratingTiles[
                                                                              index]
                                                                          .interval
                                                                          .value)
                                                                ])
                                                          ]));
                                                },
                                              )),
                                        ],
                                      )
                                    : GlobalVariables.QUESTION_TYPE == 'Map'
                                        ? Column(
                                            children: [
                                              Visibility(
                                                visible: true,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: globalWidgets
                                                        .myTextRaleway(
                                                            context,
                                                            GlobalVariables
                                                                .sectionValue,
                                                            ColorsX.black,
                                                            10,
                                                            10,
                                                            10,
                                                            0,
                                                            FontWeight.w400,
                                                            12)),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          .80,
                                                      child: globalWidgets
                                                          .myTextRaleway(
                                                              context,
                                                              questionText
                                                                  .value,
                                                              Colors.black,
                                                              10,
                                                              10,
                                                              10,
                                                              10,
                                                              FontWeight.w500,
                                                              17)),
                                                  Expanded(child: Container()),
                                                  GestureDetector(
                                                    onTap: () {
                                                      openEditQuestionDilog(
                                                          context,
                                                          questionCtl,
                                                          'Edit question',
                                                          'Add a question you want to ask');
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color:
                                                            ColorsX.appBarColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (Get.currentRoute ==
                                                          "/edit-question-screen")
                                                        return;
                                                      openDeleteQuestionDilog(
                                                          context,
                                                          questionCtl,
                                                          'Edit question',
                                                          'Add a question you want to ask');
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color:
                                                            ColorsX.appBarColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.4,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: SizeConfig
                                                                .screenHeight *
                                                            .05),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        multiratingTiles.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RawMaterialButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          splashColor: Colors
                                                              .transparent,
                                                          onPressed: () {},
                                                          child: Column(
                                                              children: <Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(multiratingTiles[
                                                                            index]
                                                                        .title
                                                                        .value),
                                                                    Expanded(
                                                                        child:
                                                                            Container()),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        openEditOptionDilog(
                                                                            context,
                                                                            multiratingTiles[index].textCtl,
                                                                            'Edit option'.tr,
                                                                            'Edit your first option',
                                                                            index);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              ColorsX.appBarColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 30,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        openDeleteDilog(
                                                                            context,
                                                                            index);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              ColorsX.appBarColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      scaleRating(
                                                                          context,
                                                                          multiratingTiles[index]
                                                                              .minimum
                                                                              .value,
                                                                          multiratingTiles[index]
                                                                              .maximum
                                                                              .value,
                                                                          multiratingTiles[index]
                                                                              .interval
                                                                              .value)
                                                                    ])
                                                              ]));
                                                    },
                                                  )),
                                            ],
                                          )
                                        : Container();
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
            'Edit here'.tr), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Edit'.tr,
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          Map<String, dynamic> map = <String, dynamic>{};
          int index = -1;
          for (int i = 0;
              i < GlobalVariables.LIST_OF_ALL_QUESTIONS.length;
              i++) {
            map = GlobalVariables.LIST_OF_ALL_QUESTIONS[i];
            if (map['question'] == questionText.value) {
              index = i;
              break;
            }
          }
          GlobalWidgets.hideKeyboard(context);
          if (GlobalVariables.QUESTION_TYPE == "Single Choice") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
            // optionOneText.value =
            // optionOneCtl.text.isEmpty ? optionOneText.value : optionOneCtl.text;
            // optionTwoText.value =
            // optionTwoCtl.text.isEmpty ? optionTwoText.value : optionTwoCtl.text;
            // optionThreeText.value =
            // optionThreeCtl.text.isEmpty ? optionThreeText.value : optionThreeCtl
            //     .text;
          } else if (GlobalVariables.QUESTION_TYPE == "Yes No") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Multiple Choice") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Multiple Rating") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Range") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Rating") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Linear Scale") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Open Text") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          } else if (GlobalVariables.QUESTION_TYPE == "Map") {
            questionText.value = questionCtl.text.isEmpty
                ? questionText.value
                : questionCtl.text;
          }
          if (index != -1) {
            map['question'] = questionText.value;
            GlobalVariables.LIST_OF_ALL_QUESTIONS[index] = map;
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  openDeleteQuestionDilog(BuildContext context, TextEditingController ctl,
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
        title: "Delete".tr,
        desc: "Delete this option", //
        body: globalWidgets.myTextRaleway(
            context,
            'Delete this option?'.tr,
            Colors.black,
            0,
            0,
            0,
            0,
            FontWeight.w400,
            17), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Delete'.tr,
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          Map<String, dynamic> map = <String, dynamic>{};
          int index = -1;
          for (int i = 0;
              i < GlobalVariables.LIST_OF_ALL_QUESTIONS.length;
              i++) {
            map = GlobalVariables.LIST_OF_ALL_QUESTIONS[i];
            if (map['question'] == questionText.value) {
              index = i;
              break;
            }
          }
          map.removeWhere((key, value) => value == questionText.value);
          GlobalVariables.LIST_OF_ALL_QUESTIONS.removeAt(index);
          GlobalWidgets.pwdWidgets.removeAt(index);
          GlobalWidgets.pwdWidgetsTemp = [];
          if (GlobalVariables.LIST_OF_ALL_QUESTIONS.isNotEmpty) {
            for (int i = 0;
                i < GlobalVariables.LIST_OF_ALL_QUESTIONS.length;
                i++) {
              if (GlobalVariables.LIST_OF_ALL_QUESTIONS[i]
                  .toString()
                  .contains(GlobalVariables.sectionValue)) {
                GlobalWidgets.pwdWidgetsTemp.add(GlobalWidgets.pwdWidgets[i]);
                Get.toNamed(Routes.CREATE_SURVEY_QUESTION_ADD);
              }
            }
          }
          Navigator.popAndPushNamed(context, Routes.CREATE_SURVEY_QUESTION_ADD);
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  dynamicScaleDialog(
    BuildContext context,
    TextEditingController ctl,
  ) {
    TextEditingController ctl2 = TextEditingController();
    TextEditingController ctl3 = TextEditingController();
    ctl.clear();
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
            globalWidgets.myTextRaleway(context, "Add Value".tr, ColorsX.black,
                10, 0, 0, 0, FontWeight.w600, 18),
            globalWidgets.myTextRaleway(
                context,
                "Add maximum value for scale rating".tr,
                ColorsX.subBlack,
                10,
                0,
                0,
                20,
                FontWeight.w400,
                12),
            globalWidgets.myTextField(
                TextInputType.number, ctl, false, 'Starting Value'.tr),
            globalWidgets.myTextField(
                TextInputType.number, ctl2, false, 'Ending Value'.tr),
            globalWidgets.myTextField(
                TextInputType.number, ctl3, false, 'Interval'.tr),
          ],
        ),
        btnCancelOnPress: () {
          // Get.back();
        },
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Done'.tr,
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          int min = int.parse(ctl.text);
          int max = int.parse(ctl2.text);
          int intval = int.parse(ctl3.text);
          int count = 0;
          for (min; min < max; intval) {
            min += intval;
            count++;
          }
          GlobalWidgets.hideKeyboard(context);
          if (ctl.text.isEmpty || ctl2.text.isEmpty || ctl3.text.isEmpty) {
            GlobalWidgets.showToast('Please type all values'.tr);
          } else if (count > 16) {
            GlobalWidgets.showToast('too many values'.tr);
          } else {
            GlobalVariables.dynamicScaleValue = int.parse(ctl.text);
            min = int.parse(ctl.text);
            //Get.toNamed(Routes.EDIT_QUESTION_SCREEN);
            setState(() {
              multiratingTiles.add(MultiRatingTileModel(
                // Create a new checkbox model and add it to the list
                id: counter.obs,
                title: "Edit option".tr.obs,
                minimum: RxInt(min),
                maximum: RxInt(max),
                interval: RxInt(intval),
              ));
              counter++;
            });
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  openDeleteDilog(BuildContext context, int index) {
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
        title: "Delete".tr,
        desc: "Delete this option", //
        body: globalWidgets.myTextRaleway(
            context,
            'Delete this option?'.tr,
            Colors.black,
            0,
            0,
            0,
            0,
            FontWeight.w400,
            17), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Delete'.tr,
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          setState(() {
            if (GlobalVariables.QUESTION_TYPE == 'Single Choice') {
              radioListTiles.removeAt(index);
              counter--;
              for (RadioListTileModel c in radioListTiles) {
                c.id = radioListTiles.indexOf(c).obs;
              }
            } else if (GlobalVariables.QUESTION_TYPE == 'Multiple Rating') {
              multiratingTiles.removeAt(index);
              counter--;
              for (MultiRatingTileModel c in multiratingTiles) {
                c.id = multiratingTiles.indexOf(c).obs;
              }
            } else {
              checkboxListTiles.removeAt(index);
              counter--;
              for (CheckboxListTileModel c in checkboxListTiles) {
                c.id = checkboxListTiles.indexOf(c).obs;
              }
            }
          });
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  openEditOptionDilog(BuildContext context, TextEditingController ctl,
      String title, String description, int index) {
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
            'Edit here'.tr), // \n Save or remember ID to Log In' ,
        btnCancelOnPress: () {},
        btnCancelColor: ColorsX.subBlack,
        btnOkText: 'Edit'.tr,
        buttonsTextStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        btnCancelText: 'Cancel'.tr,
        btnOkOnPress: () {
          debugPrint('OnClcik');
          GlobalWidgets.hideKeyboard(context);
          if (GlobalVariables.QUESTION_TYPE == 'Single Choice') {
            setState(() {
              radioListTiles[index].title.value =
                  radioListTiles[index].textCtl.text;
            });
          } else if (GlobalVariables.QUESTION_TYPE == 'Multiple Choice') {
            setState(() {
              checkboxListTiles[index].title.value =
                  checkboxListTiles[index].textCtl.text;
            });
          } else if (GlobalVariables.QUESTION_TYPE == 'Multiple Rating') {
            setState(() {
              multiratingTiles[index].title.value =
                  multiratingTiles[index].textCtl.text;
            });
          }
        },
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        })
      ..show();
  }

  saveQuestionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (GlobalVariables.sectionValue == "Select Section") {
          GlobalWidgets.showToast("Please select section".tr);
        } else {
          if (GlobalVariables.QUESTION_TYPE == "Single Choice") {
            singleChoiceQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Multiple Choice") {
            multipleChoiceQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Multiple Rating") {
            multipleRatingQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Yes No") {
            yesNoQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Range") {
            rangeQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Rating") {
            ratingQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Linear Scale") {
            scaleRatingQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Open Text") {
            openTextQuestionSave(context);
          } else if (GlobalVariables.QUESTION_TYPE == "Map") {
            mapQuestionSave(context);
          }
        }
      },
      child: Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: ColorsX.appBarColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: globalWidgets.myTextRaleway(context, "SAVE QUESTION".tr,
                ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 17),
          ),
        ),
      ),
    );
  }

  singleChoiceQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here' ||
        radioListTiles.isEmpty) {
      GlobalWidgets.showToast('Please fill all the information');
    } else {
      for (RadioListTileModel c in radioListTiles) {
        listOfOptions.add(c.title.value);
        // ids have to be separated for counter sometimes later
      }
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': listOfOptions,
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  multipleChoiceQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here' ||
        checkboxListTiles.isEmpty) {
      GlobalWidgets.showToast('Please fill all the information');
    } else {
      for (CheckboxListTileModel c in checkboxListTiles) {
        listOfOptions.add(c.title.value);
      }
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': listOfOptions,
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  multipleRatingQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here' ||
        multiratingTiles.isEmpty) {
      GlobalWidgets.showToast('Please fill all the information');
    } else {
      for (MultiRatingTileModel c in multiratingTiles) {
        listOfOptions.add(c.title.value);
        minlistOfOptions.add(c.minimum.toString());
        maxlistOfOptions.add(c.maximum.toString());
        interlistOfOptions.add(c.interval.toString());
      }
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': listOfOptions,
        'minimum': minlistOfOptions,
        'maximum': maxlistOfOptions,
        'interval': interlistOfOptions,
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  openTextQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here'.tr) {
      GlobalWidgets.showToast('Please fill all the information'.tr);
    } else {
      Map<String, dynamic> map = {
        'question_type': 'Open Text',
        'question': questionText.value,
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  yesNoQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here'.tr) {
      GlobalWidgets.showToast('Please fill all the information'.tr);
    } else {
      listOfOptions.add('Yes');
      listOfOptions.add('No');
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': listOfOptions,
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  mapQuestionSave(BuildContext context) {
    List<String> listForMapOptions = [];
    // listForMapOptions.add('Female'.tr);
    // listForMapOptions.add('Male'.tr);
    // listForMapOptions.add('Trans'.tr);

    // Map<String, dynamic> qu_1 = {
    //   'question_type': 'Single Choice',
    //   'question': 'Which gender are you?'.tr,
    //   'options': listForMapOptions,
    //   'is_from_map': 'yes',
    //   'section': GlobalVariables.sectionValue
    // };

    // Map<String, dynamic> qu_2 = {
    //   'question_type': 'Open Text',
    //   'question': 'How old are you?'.tr,
    //   'is_from_map': 'yes',
    //   'section': GlobalVariables.sectionValue
    // };

    // listForMapOptions = [];
    // listForMapOptions.add('None'.tr);
    // listForMapOptions.add('Secondary school diploma'.tr);
    // listForMapOptions.add('High school diploma'.tr);
    // listForMapOptions.add('Completed vocational training'.tr);
    // listForMapOptions.add('Bachelors'.tr);
    // listForMapOptions.add('Master'.tr);
    // listForMapOptions.add('Doctorate'.tr);
    // listForMapOptions.add('Habilitation'.tr);
    // Map<String, dynamic> qu_3 = {
    //   'question_type': 'Single Choice',
    //   'question': 'What is your highest level of education?'.tr,
    //   'options': listForMapOptions,
    //   'is_from_map': 'yes',
    //   'section': GlobalVariables.sectionValue
    // };

    // Map<String, dynamic> qu_4 = {
    //   'question_type': 'Open Text',
    //   'question': 'How long have you lived in Bamberg?'.tr,
    //   'is_from_map': 'yes',
    //   'section': GlobalVariables.sectionValue
    // };

    // listForMapOptions = [];
    // listForMapOptions.add('Bamberg-Nord');
    // listForMapOptions.add('Bamberg-Ost/Lagarde');
    // listForMapOptions.add('Bruderwald');
    // listForMapOptions.add('Bug');
    // listForMapOptions.add('Gartenstadt');
    // listForMapOptions.add('Gärtnerstadt');
    // listForMapOptions.add('Gaustadt');
    // listForMapOptions.add('Gereuth/Südflur');
    // listForMapOptions.add('Hain');
    // listForMapOptions.add('Innenstadt');
    // listForMapOptions.add('Kaulberg');
    // listForMapOptions.add('Michelsberg/Sand');
    // listForMapOptions.add('Nördliche Insel');
    // listForMapOptions.add('Starkenfeld/Malerviertel');
    // listForMapOptions.add('Stephansberg');
    // listForMapOptions.add('Südwest');
    // listForMapOptions.add('Volkspark');
    // listForMapOptions.add('Wildensorg');
    // listForMapOptions.add('Wunderburg/Hochgericht');

    // Map<String, dynamic> qu_5 = {
    //   'question_type': 'Single Choice',
    //   'question': 'In which district of Bamberg do you live?'.tr,
    //   'is_from_map': 'yes',
    //   'options': listForMapOptions,
    //   'section': GlobalVariables.sectionValue
    // };

    Map<String, dynamic> qu_6 = {
      'question_type': 'Map',
      'is_from_map': 'yes',
      'question': questionText.value,
      'options': [],
      'section': GlobalVariables.sectionValue
    };
    // Map<String, dynamic> qu_7 = {
    //   'question_type': 'Linear Scale',
    //   'is_from_map': 'yes',
    //   'question': 'How unsafe do you feel in this place? (Scale 0-4, 0=not unsure to 4=very unsure)'.tr,
    //   'options': [],
    //   'max_value': '4',
    //   'section': GlobalVariables.sectionValue
    // };
    // listForMapOptions = [];
    // listForMapOptions.add('Day'.tr);
    // listForMapOptions.add('Night'.tr);
    // listForMapOptions.add('Both'.tr);

    // Map<String, dynamic> qu_8 = {
    //   'question_type': 'Single Choice',
    //   'question': 'At what time of day do you feel unsafe in this place?'.tr,
    //   'is_from_map': 'yes',
    //   'options': listForMapOptions,
    //   'section': GlobalVariables.sectionValue
    // };

    // Map<String, dynamic> qu_9 = {
    //   'question_type': 'Open Text',
    //   'is_from_map': 'yes',
    //   'question': 'List environmental factors for each location and have them state: How much do the factors listed here influence your uncertainty in this location? (0-4, 0=not to 4=very)'.tr,
    //   'section': GlobalVariables.sectionValue
    // };

    // listForMapOptions = [];
    // listForMapOptions.add('Yes');
    // listForMapOptions.add('No');
    // Map<String, dynamic> qu_10 = {
    //   'question_type': 'Yes No',
    //   'question': 'Have you or anyone you know had a negative security experience at this location in the past?'.tr,
    //   'options': listForMapOptions,
    //   'is_from_map': 'yes',
    //   'section': GlobalVariables.sectionValue
    // };

    // Map<String, dynamic> qu_11 = {
    //   'question_type': 'Open Text',
    //   'is_from_map': 'yes',
    //   'question': 'You now have the opportunity to name other places where you feel unsafe in Bamberg'.tr,
    //   'section': GlobalVariables.sectionValue
    // };

    // Map<String, dynamic> qu_12 = {
    //   'question_type': 'Range',
    //   'is_from_map': 'yes',
    //   'question': 'Finally, please provide information about your quality of life in Bamberg.'.tr,
    //   'options': [],
    //   'range_ending': '100',
    //   'range_starting': '0',
    //   'section': GlobalVariables.sectionValue
    // };

    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_1);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_2);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_3);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_4);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_5);
    GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_6);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_7);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_8);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_9);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_10);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_11);
    // GlobalVariables.LIST_OF_ALL_QUESTIONS.add(qu_12);
    debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
    setState(() {
      GlobalWidgets.pwdWidgets.add(question(context));
    });
    Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
  }

  rangeQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here'.tr) {
      GlobalWidgets.showToast('Please fill all the information'.tr);
    } else {
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'range_starting': start_age,
        'range_ending': end_age,
        'options': [],
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  ratingQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here'.tr) {
      GlobalWidgets.showToast('Please fill all the information'.tr);
    } else {
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': [],
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  scaleRatingQuestionSave(BuildContext context) {
    if (questionText.value == 'Add your question here'.tr) {
      GlobalWidgets.showToast('Please fill all the information'.tr);
    } else {
      Map<String, dynamic> map = {
        'question_type': GlobalVariables.QUESTION_TYPE,
        'question': questionText.value,
        'options': [],
        'max_value': GlobalVariables.dynamicScaleValue.toString(),
        'section': GlobalVariables.sectionValue
      };

      GlobalVariables.LIST_OF_ALL_QUESTIONS.add(map);
      debugPrint(GlobalVariables.LIST_OF_ALL_QUESTIONS.toString());
      setState(() {
        GlobalWidgets.pwdWidgets.add(question(context));
      });
      Get.toNamed(Routes.CREATE_SURVEY_QUESTION);
    }
  }

  ageLimit(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      min: 1,
      max: 100,
      divisions: 100,
      inactiveColor: ColorsX.yellowColor,
      activeColor: ColorsX.appBarColor,
      semanticFormatterCallback:
          ageValuesRange(_currentRangeValues.start, _currentRangeValues.end),
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
          start_age = _currentRangeValues.start.toStringAsFixed(0);
          end_age = _currentRangeValues.end.toStringAsFixed(0);
        });
      },
    );
  }

  ratingBar(BuildContext context) {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  scaleRating(BuildContext context, int min, int max, int interv) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.7,
      child: Wrap(
        spacing: 8,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int index = min; index < max; index += interv)
            scaleRatingItem(context, index, (index).toString()),
        ],
      ),
    );
  }

  scaleRatingItem(BuildContext context, int index, String value) {
    return Container(
      height: 50,
      width: 30,
      decoration:
          const BoxDecoration(color: ColorsX.subBlack, shape: BoxShape.circle),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: globalWidgets.myTextRaleway(
              context, value, ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 11),
        ),
      ),
    );
  }

  ageValuesRange(double start, double end) {
    debugPrint(start.toStringAsFixed(0));
    debugPrint(end.toStringAsFixed(0));
  }

  CheckforRecreation() {
    if (GlobalVariables.Fetched_Document != null) {
      if (GlobalVariables.QUESTION_TYPE == "Single Choice") {
        singleChoiceQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Multiple Choice") {
        multipleChoiceQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Multiple Rating") {
        multipleRatingQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Yes No") {
        yesNoQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Range") {
        rangeQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Rating") {
        ratingQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Linear Scale") {
        scaleRatingQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Open Text") {
        openTextQuestionSave(context);
      } else if (GlobalVariables.QUESTION_TYPE == "Map") {
        mapQuestionSave(context);
      }
    }
  }

  openStreetMapImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.MAP_SCREEN);
      },
      child: Container(
        height: SizeConfig.screenHeight * .15,
        width: SizeConfig.screenWidth * .99,
        child: Image.asset(
          'assets/images/bamberg_map.png',
          height: SizeConfig.screenHeight * .15,
          width: SizeConfig.screenWidth * .95,
        ),
      ),
    );
  }
}

class RadioListTileModel {
  RxInt id;
  RxString title;
  TextEditingController textCtl = TextEditingController();

  RadioListTileModel({required this.id, required this.title});
}

class MultiRatingTileModel {
  RxInt id;
  RxString title;
  RxInt minimum;
  RxInt maximum;
  RxInt interval;
  TextEditingController textCtl = TextEditingController();

  MultiRatingTileModel(
      {required this.id,
      required this.title,
      required this.minimum,
      required this.maximum,
      required this.interval});
}

class CheckboxListTileModel {
  RxInt id;
  RxString title;
  bool isChecked;
  TextEditingController textCtl = TextEditingController();

  CheckboxListTileModel(
      {required this.id, required this.title, required this.isChecked});
}
