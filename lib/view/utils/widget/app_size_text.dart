// ignore_for_file: strict_top_level_inference

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

Widget forgetpassword(text) {
  //16px
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Get.width * 0.04,
      color: AppColor.pink_color,
    ),
  );
}

Widget buttontext(text, {double? fontSize}) {
  //18px
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.white_color,
      fontSize: fontSize ?? Get.width * 0.040,
    ),
  );
}
