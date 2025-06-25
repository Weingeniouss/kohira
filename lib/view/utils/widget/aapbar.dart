// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_color.dart';
import '../app_icon.dart';
import '../app_logo.dart';
import 'horizontalpading.dart';

PreferredSizeWidget Appbar() {
  final appbarsize = Get.height * 0.10;
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
              children: [
                SvgPicture.asset(AppIcon.menu),
                SizedBox(width: Get.width / 50),
                Image.asset(AppLogo.logo, scale: 15),
                Row(
                  children: [
                    SizedBox(width: Get.width / 20), SvgPicture.asset(AppIcon.like),
                    SizedBox(width: Get.width / 50), SvgPicture.asset(AppIcon.shop),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
