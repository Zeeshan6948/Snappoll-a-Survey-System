import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';

import '../global/colors.dart';
import '../global/global_widgets.dart';
import '../global/size_config.dart';

class CreateSurveyScreen extends StatelessWidget {
  GlobalWidgets globalWidgets = GlobalWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      appBar: AppBar(
        backgroundColor: ColorsX.appBarColor,
        centerTitle: true,
        title: globalWidgets.myTextRaleway(context, "Create new Survey",
            ColorsX.white, 0, 0, 0, 0, FontWeight.w400, 16),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorsX.white,
            size: 18,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(25, 25, 25, 25),
                                      child: Card(
                                        elevation: 20,
                                        color: Colors.amber,
                                        child: Text('Single-Choice QUestion'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          )));
                },
                child: Icon(
                  Icons.add_box_rounded,
                  size: 32.0,
                ),
              ))
        ],
      ),
    );
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(color: ColorsX.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            globalWidgets.myTextRaleway(context, "Add Elements to your Survey",
                ColorsX.fullblack, 20, 0, 0, 0, FontWeight.w700, 22),
            globalWidgets.myTextRaleway(
                context,
                "Click on the button above to add steps",
                ColorsX.subBlack,
                10,
                0,
                0,
                0,
                FontWeight.w400,
                13),
          ],
        ),
      ),
    );
  }
}
