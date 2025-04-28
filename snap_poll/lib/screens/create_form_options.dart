import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snap_poll/global/global_widgets.dart';

import '../global/colors.dart';
import '../global/size_config.dart';
import '../routes/app_pages.dart';

// This screen has absolutely no use right now

class CreateFormOptions extends StatelessWidget {
  final GlobalWidgets globalWidgets = GlobalWidgets();

  CreateFormOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      appBar: AppBar(
          backgroundColor: ColorsX.appBarColor,
          centerTitle: true,
          title: globalWidgets.myTextRaleway(context, "Surveys", ColorsX.white,
              0, 0, 0, 0, FontWeight.w400, 16),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: ColorsX.white,
              size: 18,
            ),
          )),
    );
  }

  body(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: const BoxDecoration(color: ColorsX.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            globalWidgets.myTextRaleway(context, "Create a Survey",
                ColorsX.fullblack, 20, 0, 0, 0, FontWeight.w700, 22),
            globalWidgets.myTextRaleway(
                context,
                "Create a survey to start gathering data.",
                ColorsX.subBlack,
                10,
                0,
                0,
                0,
                FontWeight.w400,
                13),
            createRowOne(context),
            // createRowTwo(context),
          ],
        ),
      ),
    );
  }

  createRowOne(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.FORM_LAYOUT_OPTION);
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: const BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Icon(
                Icons.add,
                color: ColorsX.appBarColor,
                size: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                globalWidgets.myTextRaleway(context, "Start From Scratch",
                    ColorsX.fullblack, 20, 10, 0, 0, FontWeight.w600, 17),
                globalWidgets.myTextRaleway(
                    context,
                    "A blank slate is all you need",
                    ColorsX.subBlack,
                    20,
                    10,
                    0,
                    0,
                    FontWeight.w700,
                    13),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createRowTwo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SURVEY_TASK);
      },
      child: Container(
        height: SizeConfig.screenHeight * .12,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(
            color: ColorsX.greyBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * .25,
              height: SizeConfig.screenHeight * .12,
              decoration: const BoxDecoration(
                  color: ColorsX.cardBlueBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: const Icon(
                Icons.description_outlined,
                color: ColorsX.appBarColor,
                size: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                globalWidgets.myTextRaleway(context, "Use Template",
                    ColorsX.fullblack, 20, 10, 0, 0, FontWeight.w600, 17),
                globalWidgets.myTextRaleway(
                    context,
                    "Choose from the templates",
                    ColorsX.subBlack,
                    20,
                    10,
                    0,
                    0,
                    FontWeight.w700,
                    13),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
