// ignore_for_file: dead_null_aware_expression, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors, unused_import, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/wishlist.dart';
import 'package:kohira/controller/API/menu/others/count.dart';
import 'package:kohira/view/screen/menu/myCart/myCart.dart';
import 'package:kohira/view/screen/menu/myCart/wishList/wishlist.dart';
import 'package:kohira/view/utils/app_icon.dart';
import '../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../controller/user_inerface/menu/home/home.dart';
import '../../screen/menu/category/showproduct.dart';
import '../app_color.dart';
import '../app_constants.dart';
import 'bottomNavigation/bottomNavigation.dart';
import 'horizontalpading.dart';

PreferredSizeWidget Appbar({
  String? prefixicon,
  String? logo,
  void Function()? prefixonTap,
  String? lefticon,
  String? hedingname,
  String? hedingname_2,
  String? suffixicon_1,
  String? suffixicon_2,
  void Function()? onTaplefticon,
}) {
  final appbarsize = Get.height * 0.09;
  final bottamSelect = Get.put(Bottamnavigation());
  final count = Get.put(CountController());
  final bool isGuest = (tokans.isEmpty ?? true);

  if (isGuest) {
    cartCount = pref!.getString('count') ?? '0';
    wishCount = pref!.getString('wishcount') ?? '0';
  }

  final String? titleText = hedingname ?? hedingname_2;

  return PreferredSize(
    preferredSize: Size.fromHeight(appbarsize),
    child: Container(
      color: AppColor.white_color,
      child: SafeArea(
        child: Container(
          height: appbarsize,
          decoration: BoxDecoration(
            color: AppColor.white_color,
            boxShadow: kElevationToShadow[2],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Perfectly Centered Title or Logo
              if (titleText != null && titleText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Get.width / 23,
                      fontWeight: FontWeight.w600,
                      color: AppColor.pink_color,
                    ),
                  ),
                )
              else if (logo != null)
                Image.asset(logo, scale: 15),

              // 2. Left Action Icons
              Positioned(
                left: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixicon != null && prefixonTap != null)
                      GestureDetector(
                        onTap: prefixonTap,
                        child: Container(
                          color: AppColor.white_color,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SvgPicture.asset(prefixicon),
                        ),
                      ),
                    if (lefticon != null)
                      GestureDetector(
                        onTap: () {
                          if (onTaplefticon != null) {
                            onTaplefticon();
                          } else {
                            Get.back();
                          }
                        },
                        child: Container(
                          color: AppColor.white_color,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SvgPicture.asset(lefticon),
                        ),
                      ),
                  ],
                ),
              ),

              // 3. Right Action Icons (Wishlist & Cart)
              Positioned(
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Wishlist Icon
                    if (suffixicon_1 != null)
                      _buildWishlistIcon(suffixicon_1, isGuest, count),

                    if (suffixicon_1 != null && suffixicon_2 != null)
                      SizedBox(width: Get.width / 35),

                    // Cart Icon
                    if (suffixicon_2 != null)
                      _buildCartIcon(
                          suffixicon_2, isGuest, count, bottamSelect),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildWishlistIcon(
    String iconPath, bool isGuest, CountController count) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      GestureDetector(
        onTap: () => Get.to(() => WishlistScreen()),
        child: Container(
          color: AppColor.white_color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SvgPicture.asset(iconPath),
        ),
      ),
      Positioned(
        right: -8,
        top: 4,
        child: isGuest
            ? CircleAvatar(
                radius: 10,
                backgroundColor: AppColor.pink_color,
                child: Text(
                  wishCount,
                  style: TextStyle(
                    color: AppColor.white_color,
                    fontSize: Get.width / 38,
                  ),
                ),
              )
            : Obx(() {
                if (count.isLoading.value ||
                    count.data == null ||
                    count.data['wishlist'] == null ||
                    count.data['wishlist']['count'] == 0) {
                  return const SizedBox.shrink();
                }
                return CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColor.pink_color,
                  child: Text(
                    count.data['wishlist']['count'].toString(),
                    style: TextStyle(
                      color: AppColor.white_color,
                      fontSize: Get.width / 38,
                    ),
                  ),
                );
              }),
      ),
    ],
  );
}

Widget _buildCartIcon(String iconPath, bool isGuest, CountController count,
    Bottamnavigation bottamSelect) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      GestureDetector(
        onTap: () {
          Bottom();
          bottamSelect.indexThree();
          Get.back();
          Get.back();
        },
        child: Container(
          color: AppColor.white_color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SvgPicture.asset(iconPath),
        ),
      ),
      Positioned(
        right: -8,
        top: 4,
        child: isGuest
            ? GestureDetector(
                onTap: () {
                  Bottom();
                  bottamSelect.indexThree();
                  Get.back();
                  Get.back();
                },
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColor.pink_color,
                  child: Text(
                    cartCount,
                    style: TextStyle(
                      color: AppColor.white_color,
                      fontSize: Get.width / 38,
                    ),
                  ),
                ),
              )
            : Obx(() {
                if (count.isLoading.value ||
                    count.data == null ||
                    count.data['cart'] == null ||
                    count.data['cart']['count'] == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    Bottom();
                    bottamSelect.indexThree();
                    Get.back();
                    Get.back();
                  },
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColor.pink_color,
                    child: Text(
                      count.data['cart']['count'].toString(),
                      style: TextStyle(
                        color: AppColor.white_color,
                        fontSize: Get.width / 38,
                      ),
                    ),
                  ),
                );
              }),
      ),
    ],
  );
}
