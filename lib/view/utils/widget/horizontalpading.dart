// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget horizontalpadding({required Widget child}) {
  return Padding(padding: EdgeInsets.symmetric(horizontal: Get.width / 25),child: child);
}

Widget logopading({required Widget child}){
  return Padding(padding: EdgeInsets.all(30),child: child);
}
