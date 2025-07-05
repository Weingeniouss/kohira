// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_logo.dart';
import '../../../utils/widget/horizontalpading.dart';

class Drawers extends StatelessWidget {
  const Drawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: AppColor.white_color,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.030),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppLogo.logo, scale: 13),
                ],
              ),
              SizedBox(height: Get.height * 0.030),
              Divider(color: AppColor.textfild_color),
              SizedBox(height: Get.height * 0.030),
              drawerIcon(icon: AppIcon.bracelet, text: AppString.bracelet, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.collection, text: AppString.collection, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.earrings, text: AppString.earrings, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.mangalsutra, text: AppString.mangalsutra, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.necklace, text: AppString.necklace, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.ring, text: AppString.ring, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.custom, text: AppString.custom, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.dummy, text: AppString.dummy, color: AppColor.white_color),
              drawerIcon(icon: AppIcon.Order, text: AppString.Order),
              drawerIcon(icon: AppIcon.Wishlist, text: AppString.Wishlist),
              drawerIcon(icon: AppIcon.Wallet, text: AppString.Wallet),
              drawerIcon(icon: AppIcon.Addresses, text: AppString.Addresses),
              drawerIcon(icon: AppIcon.HelpCenter, text: AppString.HelpCenter),
              drawerIcon(icon: AppIcon.PrivacyPolicy, text: AppString.PrivacyPolicy),
              drawerIcon(icon: AppIcon.Logout, text: AppString.Logout),
              SizedBox(height: Get.height * 0.030),
            ],
          ),
        ),
      ),
    );
  }
}

Widget drawerIcon({required String icon,
    required String text,
    void Function()? onTap,
    Color? color
}) {
  return horizontalpadding(
    child: GestureDetector(
      onTap: () => onTap,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
            decoration: BoxDecoration(
              color: AppColor.pink_color,
              borderRadius: BorderRadius.circular(Get.width / 50),
            ),
            padding: EdgeInsets.all(10),
            child: SvgPicture.asset(icon, width: Get.width * 0.018, height: Get.height * 0.018, color: color),
          ),
          SizedBox(width: Get.width / 30),
          Text(text, style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}
