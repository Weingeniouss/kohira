// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../app_color.dart';
import 'app_size_text.dart';

Widget button(String? text, {double? fontSize, EdgeInsetsGeometry? padding}) {
  return Container(
    padding: padding ?? EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(Get.width * (3 / 400)),
      // color: AppColor.pink_color,
      color: AppColor.black_color,
    ),
    child: Center(child: buttontext(text, fontSize: fontSize)),
  );
}

Widget circle(Widget? widget) {
  return Container(
    padding: EdgeInsets.all(9),
    decoration: BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(Get.width * (3 / 400)),
      color: AppColor.pink_color,
    ),
    child: Center(child: widget),
  );
}
