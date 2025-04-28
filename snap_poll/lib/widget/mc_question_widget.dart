import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:snap_poll/global/global_variables.dart';

import '../global/colors.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
  final List<dynamic> options;

  MultipleChoiceQuestionWidget({required this.options});

  @override
  State<MultipleChoiceQuestionWidget> createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  GlobalWidgets globalWidgets = GlobalWidgets();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: SizeConfig.screenHeight * 0.5,
      width: GlobalVariables.ScrWidth,
      child: ListView(
        shrinkWrap: true,
        children: widget.options
            .map((option) => CheckboxListTile(
                value: GlobalVariables.LIST_OF_MC_RESULTS.contains(option),
                controlAffinity: ListTileControlAffinity.leading,
                checkColor: ColorsX.white,
                activeColor: ColorsX.appBarColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * .60,
                      child: globalWidgets.myTextRaleway(context, option,
                          ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 16),
                    ),
                  ],
                ),
                dense: true,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      GlobalVariables.LIST_OF_MC_RESULTS.add(option);
                      print(GlobalVariables.LIST_OF_MC_RESULTS);
                    } else {
                      GlobalVariables.LIST_OF_MC_RESULTS.remove(option);
                      print(GlobalVariables.LIST_OF_MC_RESULTS);
                    }
                  });
                }))
            .toList(),
      ),
    );
  }
}
