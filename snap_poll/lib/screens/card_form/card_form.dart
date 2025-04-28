import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/mc_question_template.dart';
import 'package:snap_poll/models/checkboxlisttile_model.dart';
import 'package:snap_poll/routes/app_pages.dart';
import 'package:snap_poll/screens/card_form/answer_button.dart';
import '../../data/questions.dart';
import '../../global/global_widgets.dart';

import '../../global/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CardForm extends StatefulWidget {
  const CardForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardFormState();
  }
}

class _CardFormState extends State<CardForm> {
  final GlobalWidgets globalWidgets = GlobalWidgets();
  final GlobalVariables globalVariables = GlobalVariables();

  Map<String, dynamic> result = {};
  var currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    // chooseAnswer(selectedAnswer);

    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      appBar: AppBar(
        backgroundColor: ColorsX.appBarColor,
        centerTitle: true,
        title: globalWidgets.myTextRaleway(
          context,
          "Card Survey",
          ColorsX.white,
          0,
          0,
          0,
          0,
          FontWeight.w400,
          16,
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: ColorsX.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    final currentQuestion =
        GlobalVariables.LIST_OF_ALL_QUESTIONS[currentQuestionIndex];
    List<String> options = [];
    for (int t = 0; t < currentQuestion['count']; t++) {
      options.add(currentQuestion['option $t']);
    }
    return MultipleChoiceQuestionWidget(
        question: currentQuestion['question'],
        options: options,
        onChanged: (result) {
          print("huhu");
        });
  }

// class MultipleChoiceModel {
//   late int id;
//   late String title;
//   late bool isChecked;
//   MultipleChoiceModel(
//       {required this.id, required this.title, required this.isChecked});
// }
}
