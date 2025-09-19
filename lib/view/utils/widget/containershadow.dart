// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

Widget containershadow({required Widget child}){
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.textfild_color),
      borderRadius: BorderRadius.circular(Get.width / 50),
      boxShadow: [
        BoxShadow(
          color: AppColor.black_color.withOpacity(0.0),
          blurRadius: 5,
          spreadRadius: 1,
          offset: Offset(0, 0),
        ),
      ],
      color: AppColor.white_color,
    ),
    child: child,
  );
}