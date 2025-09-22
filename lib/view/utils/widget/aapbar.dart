// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors, unused_import, unnecessary_null_comparison, deprecated_member_use

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
import '../app_color.dart';
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
})
{
  final appbarsize = Get.height * 0.09;
  final bottamSelect = Get.put(Bottamnavigation());
  final count = Get.put(CountController());
  return PreferredSize(
    preferredSize: Size.fromHeight(appbarsize),
    child: Container(
      decoration: BoxDecoration(color: AppColor.Appbercolor),
      child: SafeArea(
        child: Container(
          height: appbarsize,
          decoration: BoxDecoration(color: AppColor.Appbercolor),
          child: Stack(
            children: [
              horizontalpadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget?>[

                    // Prefix Icon
                    (prefixicon != null && prefixonTap != null) ? GestureDetector(
                      onTap: prefixonTap,
                      child: Container(
                        color: AppColor.Appbercolor,
                        padding: EdgeInsets.only(right: (suffixicon_1 == null && suffixicon_2 == null) ? 1 : 1, bottom: 28, top: 25),
                        child: SvgPicture.asset(prefixicon),
                      ),
                    ) : null,

                    // Left Icon
                    (lefticon != null) ? GestureDetector(
                      onTap: () {
                        if (onTaplefticon != null) {onTaplefticon();}
                        else {
                          Get.back();
                        }
                      },
                      child: Container(
                        color: AppColor.Appbercolor,
                        padding: EdgeInsets.only(right: 5, bottom: 28, top: 28),
                        child: SvgPicture.asset(lefticon),
                      ),
                    ) : SizedBox.shrink(),

                    (logo != null) ? SizedBox(width: Get.width / 7) : null,
                    (logo != null) ? Image.asset(logo, scale: 15) : null,

                    SizedBox(),

                    // Middle Heading
                    (hedingname != null)
                        ? Text(hedingname, textAlign: TextAlign.center, style: TextStyle(fontSize: Get.width / 23, fontWeight: FontWeight.w600, color: AppColor.pink_color))
                        : const SizedBox.shrink(),

                    // Second Heading (when no hedingname)
                    (hedingname_2 != null && hedingname == null) ? Expanded(
                      child: Text(hedingname_2, softWrap: true, overflow: TextOverflow.visible, textAlign: TextAlign.center, style: TextStyle(fontSize: Get.width / 23, fontWeight: FontWeight.w600, color: AppColor.pink_color)),
                    ) : null,

                    // Wishlist + Cart
                    (lefticon != null) ? null : SizedBox(),

                    Row(
                      children: [

                        // Wishlist
                        if (suffixicon_1 != null)
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(() => WishlistScreen()),
                                child: Container(
                                  color: AppColor.Appbercolor,
                                  padding: EdgeInsets.only(top: 20,bottom: 20),
                                  child: SvgPicture.asset(suffixicon_1),
                                ),
                              ),
                              Obx(() {
                                if (count.isLoading.value || count.data == null || count.data['wishlist'] == null || count.data['wishlist']['count'] == 0) {
                                  return SizedBox.shrink();
                                }
                                return Positioned(
                                  right: -10, top: 8,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColor.pink_color,
                                    child: Text(
                                      count.data['wishlist']['count'].toString(),
                                      style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 38),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),

                        SizedBox(width: Get.width / 35),

                        //Cart
                        if (suffixicon_2 != null)
                          Stack(
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
                                  color: AppColor.Appbercolor,
                                  padding: EdgeInsets.only(top: 21,bottom: 21),
                                  child: SvgPicture.asset(suffixicon_2),
                                ),
                              ),
                              Obx(() {
                                if (count.isLoading.value || count.data == null || count.data['cart'] == null || count.data['cart']['count'] == 0) {
                                  return SizedBox.shrink();
                                }
                                return Positioned(
                                  right: -10,
                                  top: 8,
                                  child: GestureDetector(
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
                                        style: TextStyle(color: AppColor.white_color, fontSize: Get.width / 38),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ].whereType<Widget>().toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}