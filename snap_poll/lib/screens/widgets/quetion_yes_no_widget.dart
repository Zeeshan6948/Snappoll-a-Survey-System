// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snap_poll/global/global_widgets.dart';
//
// class QuestionYesNoWidget extends StatelessWidget {
//   GlobalWidgets globalWidgets;
//   QuestionYesNoWidget({super.key, required this.globalWidgets});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Obx(() => globalWidgets.myTextRaleway(context, questionText.value,
//                 Colors.black, 10, 10, 10, 10, FontWeight.w500, 17)),
//             Expanded(child: Container()),
//             GestureDetector(
//               onTap: () {
//                 openEditQuestionDilog(context, questionCtl, 'Edit question',
//                     'Write a question you want to ask');
//               },
//               child: Container(
//                 margin: EdgeInsets.only(top: 10),
//                 child: Icon(
//                   Icons.edit,
//                   //  color: ColorsX.appBarColor,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//           ],
//         ),
//         RadioListTile<String>(
//           value: 'Yes',
//           groupValue: _groupValue,
//           title: globalWidgets.myTextRaleway(
//               context, 'Yes', Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
//           onChanged: (newValue) => setState(() => _groupValue = newValue!),
//           activeColor: Colors.red,
//           selected: false,
//         ),
//         RadioListTile<String>(
//           value: 'No',
//           groupValue: _groupValue,
//           title: globalWidgets.myTextRaleway(
//               context, 'No', Colors.black, 0, 0, 0, 0, FontWeight.w400, 17),
//           onChanged: (newValue) => setState(() => _groupValue = newValue!),
//           activeColor: Colors.red,
//           selected: false,
//         ),
//       ],
//     );
//   }
// }
