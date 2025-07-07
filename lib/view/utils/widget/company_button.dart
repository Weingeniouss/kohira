// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../app_color.dart';

Widget company_button(text,icon) {
  return Container(
    width: Get.width / 2.4,
    padding: EdgeInsets.symmetric( horizontal: Get.width * 0.020, vertical: Get.width * 0.025),
    decoration: BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(Get.width * (3 / 400)),
      border: Border.all(color: AppColor.textfild_color),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: Get.width / 50),
        Text(text, style: TextStyle(fontSize: Get.width * 0.0400, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}