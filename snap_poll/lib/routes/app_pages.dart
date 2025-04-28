import 'package:get/get.dart';
import 'package:snap_poll/screens/all_surveys.dart';
import 'package:snap_poll/screens/card_form_layout.dart';
import 'package:snap_poll/screens/card_form/edit_question_screens/edit_ot_question_screen.dart';
import 'package:snap_poll/screens/choose_access.dart';
import 'package:snap_poll/screens/create_form_options.dart';
import 'package:snap_poll/screens/create_survey_question.dart';
import 'package:snap_poll/screens/card_form/edit_question_screens/edit_yn_question_screen.dart';
import 'package:snap_poll/screens/edit_question_screen.dart';
import 'package:snap_poll/screens/form_layout_option.dart';
import 'package:snap_poll/screens/main_page.dart';
import 'package:snap_poll/screens/card_form/edit_question_screens/edit_mc_question_screen.dart';
import 'package:snap_poll/screens/open_street_map_screen.dart';
import 'package:snap_poll/screens/pending_surveys.dart';
import 'package:snap_poll/screens/sign_in_screen.dart';
import 'package:snap_poll/screens/widgets/create_survey_question_add.dart';
import 'package:snap_poll/widget/image_adding.dart';
import 'package:snap_poll/screens/qr_code_screen.dart';

import '../screens/card_form/edit_question_screens/edit_ot_question_screen.dart';
import '../screens/card_form/edit_question_screens/edit_sc_question_screen.dart';
import '../screens/edit_question_screen.dart';
import '../screens/initial_qr_or_signin.dart';
import '../screens/splash.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.INITIAL_SCREEN,
      page: () => Initial(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.MAIN_PAGE,
      page: () => SignInScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_FORM_OPTIONS,
      page: () => FormLayoutOption(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORM_LAYOUT_OPTION,
      page: () => FormLayoutOption(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CARD_FORM_LAYOUT,
      page: () => CardFormLayout(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ALL_SURVEYS,
      page: () => AllSurveys(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SURVEY_QUESTION,
      page: () => const CreateSurveyQuestion(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SURVEY_QUESTION_ADD,
      page: () => const CreateSurveyQuestionAdd(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_ACCESS,
      page: () => const ChooseAccess(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PENDING_SURVEYS,
      page: () => const PendingSurveys(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_QUESTION_SCREEN,
      page: () => const EditQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_YN_QUESTION_SCREEN,
      page: () => EditYNQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_MC_QUESTION_SCREEN,
      page: () => EditMCQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SC_QUESTION_SCREEN,
      page: () => EditSCQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_OT_QUESTION_SCREEN,
      page: () => EditOTQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_QUESTION_SCREEN,
      page: () => EditQuestionScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.QRCODE_SCREEN,
      page: () => QrCodeScreen(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAP_SCREEN,
      page: () => OpenStreetMapScreen(),
      // binding: LoginBinding(),
    ),
  ];
}
