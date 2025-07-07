// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_color.dart';
import 'horizontalpading.dart';

PreferredSizeWidget Appbar({
  String? prefixicon,
  String? logo,
  void Function()? prefixonTap,
  String? lefticon,
  String? hedingname,
  String? suffixicon_1,
  String? suffixicon_2,
}) {
  final appbarsize = Get.height * 0.06;

  return PreferredSize(
    preferredSize: Size.fromHeight(appbarsize),
    child: Container(
      decoration: BoxDecoration(color: AppColor.Appbercolor),
      child: SafeArea(
        child: Container(
          height: appbarsize,
          decoration: BoxDecoration(color: AppColor.Appbercolor),
          child: horizontalpadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget?>[
                (prefixicon != null && prefixonTap != null)
                    ? GestureDetector(onTap: prefixonTap, child: SvgPicture.asset(prefixicon))
                    : null,
                (lefticon != null) ? GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(lefticon)) : null,

                (logo != null) ? Row(
                  children: [
                    SizedBox(width: Get.width / 8),
                    Image.asset(logo, scale: 15),
                  ],
                ) : null,

                (hedingname != null)
                    ? Row(
                        children: [
                          SizedBox(width: Get.width / 10),
                         Text(hedingname,style: TextStyle(fontSize: Get.width / 23,fontWeight: FontWeight.w600,color: AppColor.pink_color)),
                      ],
                    )
                    : null,

                Row(
                  children: <Widget?>[
                    SizedBox(width: Get.width / 20), (suffixicon_1 != null) ? SvgPicture.asset(suffixicon_1) : null,
                    SizedBox(width: Get.width / 50), (suffixicon_2 != null) ? SvgPicture.asset(suffixicon_2) : null,
                  ].whereType<Widget>().toList(),
                ),
              ].whereType<Widget>().toList(),
            ),
          ),
        ),
      ),
    ),
  );
}
