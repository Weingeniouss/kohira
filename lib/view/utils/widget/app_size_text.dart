import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_color.dart';

Widget forgetpassword(text) {
  //16px
  return Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: Get.width * 0.04,color: AppColor.pink_color));
}

Widget buttontext(text){
  //18px
  return Text(text, style: TextStyle(fontWeight: FontWeight.w500,color: AppColor.white_color, fontSize: Get.width * 0.040));
}
