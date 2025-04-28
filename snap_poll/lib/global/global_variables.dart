import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:snap_poll/global/size_config.dart';

class GlobalVariables {
  static String my_ID = '';
  static String MY_EMAIL_ADDRESS = '';
  static String QUESTION_TYPE = '';
  static String idOfSurvey = '';
  static String TITLE_OF_SURVEY = '';
  static String sectionValue = "Select Section";
  static String descriptionCTLValue = "";
  // static final List<String> SECTIONS_LIST = ["Select Section"];
  static final List<String> SECTIONS_LIST = [];
  static final List<String> MAINTAINER_LIST = [];
  static final List<String> VIEWER_LIST = [];
  static List<DocumentSnapshot> templatesList = [];
  static String roleType = "user";
  static var LIST_OF_ALL_QUESTIONS = [];
  static var LIST_OF_ALL_SECTIONS = [];
  static var LIST_OF_ALL_ANSWERS = [];
  static var LIST_OF_MC_RESULTS = [];
  static var Swaping_Array = [];
  static var Swaping_Array2 = [];
  static List<DocumentSnapshot> allUsers = [];
  static int currentIndex = 0;
  static int dynamicScaleValue = 5;
  static int dynamicScaleValueE = 0;
  static int dynamicScaleValueI = 0;
  static int mapCounter = 0;
  static String currentSection = '';
  static bool isEng = true;
  static String? userId = "";
  static Map<String, dynamic>? Fetched_Document;
  static List<osm.GeoPoint> myMarkers = [];
  static List<dynamic> coordinates = [];
  static List<Uint8List> screenshots = [];

  static final List<String>  agesList = ["Alter auswählen","2006","2005","2004","2003","2002","2001","2000","1999","1998","1997"
    ,"1996","1995","1994","1993","1992","1991","1990","1989","1988","1987","1986","1985","1984","1983","1982","1981","1980","1979"
    ,"1978","1977","1976","1975","1974","1973","1972","1971","1970","1969","1968","1967","1966","1965","1964","1963","1962","19761"
    ,"1960"];
  static double ScrWidth =
      SizeConfig.screenWidth > 600 ? 600 : SizeConfig.screenWidth;
}
