import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckboxListTileModel {
  RxInt id;
  RxString title;
  bool isChecked;
  TextEditingController textCtl = TextEditingController();

  CheckboxListTileModel(
      {required this.id, required this.title, required this.isChecked});
}
