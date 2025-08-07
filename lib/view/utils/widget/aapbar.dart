// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors, unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/wishlist.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import '../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../controller/user_inerface/menu/home/home.dart';
import '../app_color.dart';
import 'bottomNavigation/bottomNavigation.dart';
import 'horizontalpading.dart';

PreferredSizeWidget Appbar(
    {
      String? prefixicon,
      String? logo,
      void Function()? prefixonTap,
      String? lefticon,
      String? hedingname,
      String? suffixicon_1,
      String? suffixicon_2,
      void Function()? onTaplefticon
    })
{
  final appbarsize = Get.height * 0.09;
  final bottamSelect = Get.put(Bottamnavigation());
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
                (lefticon != null)
                    ? GestureDetector(
                        onTap: () {
                          if (onTaplefticon != null) {
                            onTaplefticon();
                          }
                          else {
                            Get.back();
                          }
                        },
                        child: SvgPicture.asset(lefticon),
                      )
                    : SizedBox.shrink(),
                (logo != null)
                    ? Row(
                        children: [
                          SizedBox(width: Get.width / 8),
                          Image.asset(logo, scale: 15),
                        ],
                      )
                    : null,

                (suffixicon_1 == null && suffixicon_2 == null) ? SizedBox(width: Get.width / 500) : null,

                (hedingname != null)
                    ? Row(
                        children: [
                          SizedBox(width: Get.width / 10),
                          Text(
                            hedingname,
                            style: TextStyle(
                              fontSize: Get.width / 23,
                              fontWeight: FontWeight.w600,
                              color: AppColor.pink_color,
                            ),
                          ),
                        ],
                      )
                    : null,

                (suffixicon_1 == null && suffixicon_2 == null) ? SizedBox(width: Get.width / 10) : null,
                (prefixicon != null && prefixonTap != null) ? SizedBox(width: Get.width / 1000) : null,

                Obx(() {
                  final count = Get.put(CountController());
                  if (count.isLoading.value) SizedBox();
                  if (count.data.isEmpty && count.data == null) SizedBox();
                  return Stack(
                    children: [
                      Row(
                        children: <Widget?>[
                          SizedBox(width: Get.width / 20),
                          (suffixicon_1 != null)
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(() => WishlistScreen());
                                  },
                                  child: SvgPicture.asset(suffixicon_1),
                                )
                              : null,
                          SizedBox(width: Get.width / 30),
                          (suffixicon_2 != null)
                              ? GestureDetector(
                                  onTap: () {
                                    Bottom();
                                    bottamSelect.indexThree();
                                    Get.back();
                                    Get.back();
                                  },
                                  child: SvgPicture.asset(suffixicon_2),
                          )
                              : null,
                        ].whereType<Widget>().toList(),
                      ),

                      //Add to cart
                      (count.isLoading.value || count.data == null || count.data['cart'] == null)
                          ? SizedBox()
                          : Positioned(
                              right: 13, top: 0,
                              child: (count.data['cart']['count'] == null || count.data['cart']['count'] == 0)
                                  ? SizedBox()
                                  : CircleAvatar(
                                      radius: 8,
                                      backgroundColor: AppColor.pink_color,
                                      child: Center(
                                        child: Text(
                                          (count.data['cart']['count'] == 0) ? '' : count.data['cart']['count'].toString(),
                                          style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 40),
                                        ),
                                      ),
                                    ),
                            ),

                      //Wishlist count
                      (count.isLoading.value || count.data == null || count.data['cart'] == null)
                          ? SizedBox()
                          : Positioned(
                              right: 45, top: 0,
                              child: (count.data['wishlist']['count'] == null || count.data['wishlist']['count'] == 0)
                                  ? SizedBox()
                                  : CircleAvatar(
                                      radius: 8,
                                      backgroundColor: AppColor.pink_color,
                                      child: Center(
                                        child: Text(
                                          (count.data['wishlist']['count'] == 0)
                                              ? ''
                                              : count.data['wishlist']['count'].toString(),
                                          style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 40),
                                        ),
                                      ),
                                    ),
                            ),
                    ],
                  );
                })
              ].whereType<Widget>().toList(),
            ),
          ),
        ),
      ),
    ),
  );
}
