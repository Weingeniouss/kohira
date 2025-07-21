// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import '../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../app_color.dart';
import 'bottomNavigation/bottomNavigation.dart';
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
  final bottamSelect =  Get.put(Bottamnavigation());

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

                (suffixicon_1 == null && suffixicon_2 == null) ? SizedBox(width: Get.width / 500) : null,

                (hedingname != null)
                    ? Row(
                        children: [
                          SizedBox(width: Get.width / 10),
                          Text(hedingname,style: TextStyle(fontSize: Get.width / 23,fontWeight: FontWeight.w600,color: AppColor.pink_color)),
                      ],
                    )
                    : null,

                (suffixicon_1 == null && suffixicon_2 == null) ? SizedBox(width: Get.width / 10) : null,

                Row(
                  children: <Widget?>[
                    SizedBox(width: Get.width / 20), (suffixicon_1 != null)
                        ? GestureDetector(
                          onTap: () {
                              Bottom();
                              bottamSelect.indexThree();
                              Get.back();
                              Get.back();
                            },
                            child: SvgPicture.asset(suffixicon_1),
                          )
                        : null,
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
