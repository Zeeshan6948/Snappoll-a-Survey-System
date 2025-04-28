import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_variables.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/routes/app_pages.dart';

class SurveryQuestionList extends StatefulWidget {
  GlobalWidgets globalWidgets;

  SurveryQuestionList({super.key, required this.globalWidgets});

  @override
  State<StatefulWidget> createState() {
    return _SurveryQuestionListState();
  }
}

class _SurveryQuestionListState extends State<SurveryQuestionList> {
  String section = GlobalVariables.LIST_OF_ALL_SECTIONS.isEmpty
      ? ''
      : GlobalVariables.LIST_OF_ALL_SECTIONS.first;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (GlobalVariables.LIST_OF_ALL_SECTIONS.isNotEmpty)
          // DropdownButton(
          //   value: section,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       GlobalVariables.currentSection = newValue!;
          //       print(newValue);
          //       section = newValue ?? '';
          //     });
          //   },
          //   items: GlobalVariables.LIST_OF_ALL_SECTIONS
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(
          //         value,
          //         style: TextStyle(fontSize: 18),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ListTile(
          leading: const Icon(Icons.download_done),
          title: widget.globalWidgets.myTextRaleway(context, 'Yes / No',
              ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Get.back();
            GlobalVariables.QUESTION_TYPE = "Yes No";
            Get.toNamed(Routes.EDIT_YN_QUESTION_SCREEN, arguments: section);
          },
        ),
        ListTile(
          leading: const Icon(Icons.radio),
          title: widget.globalWidgets.myTextRaleway(context, 'Single Choice',
              ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Get.back();
            GlobalVariables.QUESTION_TYPE = "Single Choice";
            Get.toNamed(Routes.EDIT_SC_QUESTION_SCREEN, arguments: section);
            // widget.globalWidgets.pwdWidgets.add(SingleChoice());
          },
        ),
        ListTile(
          leading: new Icon(Icons.check_box),
          title: widget.globalWidgets.myTextRaleway(context, 'Multiple Choice',
              ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Get.back();
            GlobalVariables.QUESTION_TYPE = "Multiple Choice";
            Get.toNamed(Routes.EDIT_MC_QUESTION_SCREEN, arguments: section);
            // widget.globalWidgets.pwdWidgets.add(SingleChoice());
          },
        ),
        ListTile(
          leading: new Icon(Icons.trip_origin),
          title: widget.globalWidgets.myTextRaleway(
              context, 'Range', ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: new Icon(Icons.linear_scale),
          title: widget.globalWidgets.myTextRaleway(context, 'Linear Scale',
              ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: new Icon(Icons.star),
          title: widget.globalWidgets.myTextRaleway(context, 'Rating',
              ColorsX.black, 0, 0, 0, 0, FontWeight.w400, 14),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.download_done),
          title: widget.globalWidgets.myTextRaleway(
              context,
              'Open Text Question',
              ColorsX.black,
              0,
              0,
              0,
              0,
              FontWeight.w400,
              14),
          onTap: () {
            Get.back();
            GlobalVariables.QUESTION_TYPE = "Open Text";
            Get.toNamed(Routes.EDIT_OT_QUESTION_SCREEN);
          },
        ),
        ListTile(
          leading: const Icon(Icons.download_done),
          title: widget.globalWidgets.myTextRaleway(
              context,
              'Adding Image Functionality ',
              ColorsX.black,
              0,
              0,
              0,
              0,
              FontWeight.w400,
              14),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.Adding_Image);
          },
        ),
      ],
    );
  }
}
