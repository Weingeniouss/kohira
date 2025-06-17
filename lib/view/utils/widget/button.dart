// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../app_color.dart';
import 'app_size_text.dart';

Widget button(String? text) {
 return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(Get.width * (3 / 400)), color: AppColor.pink_color),
    child: Center(child: buttontext(text)),
  );
}

Widget circle(Widget? widget) {
 return Container(
    padding: EdgeInsets.all(9),
    decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(Get.width * (3 / 400)), color: AppColor.pink_color),
    child: Center(child: widget),
  );
}
