// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

Widget title_text(text) {
  //22px
  return Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: Get.width * 0.050));
}

Widget sub_titel_text(text) {
  //18px
  return Text(text, style: TextStyle(fontWeight : FontWeight.w400,fontSize: Get.width * 0.040,color: AppColor.grey_color));
}
