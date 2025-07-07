// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_String.dart';
import '../app_color.dart';

Widget inputField({
  required String hintText,
  String? icon,
  TextEditingController? controller,
  bool empty = false,
}) {
  return Column(
    children: [
      TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(10),
            child: SvgPicture.asset(icon ?? '', fit: BoxFit.cover),
          ),
          hintStyle: TextStyle(color: AppColor.black_color),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 11),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: (empty) ? 2 : 1,
              color: (empty) ? AppColor.pink_color : AppColor.textfild_color,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: (empty) ? 2 : 1,
              color: (empty) ? AppColor.pink_color : AppColor.textfild_color,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: (empty) ? 2 : 1,
              color: (empty) ? AppColor.pink_color : AppColor.textfild_color,
            ),
          ),
        ),
      ),
      SizedBox(height: Get.height / 50),
    ],
  );
}

Widget searchField({
  void Function(String)? onChanged,
  void Function()? onTap,
}){
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.textfild_color),
      borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
    ),
    child: Center(
      child: TextField(
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: Get.height / 60),
          prefixIcon: Icon(Icons.search, color: AppColor.hintColor),
          hintText: AppString.Searchs,
          hintStyle: TextStyle(color: AppColor.hintColor),
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    ),
  );
}
