// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/subCategrory.dart';
import 'package:kohira/controller/database/local/localstore.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/drawer.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/menu/category/subcategory.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_json.dart';
import 'package:kohira/view/utils/app_logo.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';

class Drawers extends StatefulWidget {
  Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final subcategrory = Get.put(Subcategrory());
  final drawer = Get.put(DrawerInterface());

  String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bracelet' :return AppIcon.bracelet;
      case 'collection':return AppIcon.collection;
      case 'earrings':return AppIcon.earrings;
      case 'mangalsutra':return AppIcon.mangalsutra;
      case 'necklace' :return AppIcon.necklace;
      case 'rings': return AppIcon.ring;
      default: return 'asset/icon/drawericon/default_icon.svg'; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = category.filterData.value!.data.where((item) => ![7, 8, 9].contains(item.id)).toList();
    final filteredCategories2 = category.filterData.value!.data.where((item) => ![1, 2, 3, 4, 5, 6].contains(item.id)).toList();
    return Drawer(
      width: Get.width * 0.650,
      elevation: 0,
      backgroundColor: AppColor.white_color,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.030),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset(AppLogo.logo, scale: 13)]),
            SizedBox(height: Get.height * 0.030),
            Divider(color: AppColor.textfild_color),
            SizedBox(height: Get.height * 0.030),
            Expanded(
              child: SingleChildScrollView(
                child: Obx((){
                  if (category.filterData.value == null) {
                    return Scaffold(body: Center(child: Lottie.asset(AppJson.noData)));
                  }
                  return Obx((){
                    return Column(
                      children: [
                        horizontalpadding(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredCategories.length,
                            itemBuilder: (BuildContext context, int index) {
                              final categoryItem = filteredCategories[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => categoryItem.isExpanded = !(categoryItem.isExpanded)),
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                                            decoration: BoxDecoration(color: AppColor.pink_color, borderRadius: BorderRadius.circular(Get.width / 50)),
                                            padding: EdgeInsets.all(10),
                                            child: SvgPicture.asset(getCategoryIcon(categoryItem.name), width: Get.width * 0.018, height: Get.height * 0.018,color: AppColor.white_color),
                                          ),
                                          SizedBox(width: Get.width / 30),
                                          SizedBox(width: Get.width / 3.5, child: Text(categoryItem.name, style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500))),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AnimatedCrossFade(
                                    duration: Duration(milliseconds: 600),
                                    firstChild: SizedBox.shrink(),
                                    secondChild: categoryItem.subcategory.isNotEmpty ? Padding(
                                      padding: EdgeInsets.only(left: Get.width * 0.08),
                                      child: Column(
                                        children: [
                                          ...categoryItem.subcategory.take(6).map((subItem) {
                                            return GestureDetector(
                                              onTap: () {
                                                category.selectCategorySlug(subItem.slug);
                                                Get.to(() => Subcategorys(
                                                  subcategory_slug: subItem.slug,
                                                  subcategrorysname: AppString.product,
                                                 ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text("*"),
                                                    SizedBox(width: Get.width * 0.015),
                                                    SizedBox(
                                                      width: Get.width / 3,
                                                      child: Text(subItem.name, style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                          if (categoryItem.subcategory.length > 6)
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => Subcategorys(
                                                  subcategrorys: categoryItem.slug,
                                                  subcategrorysname: AppString.product,
                                                ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text("*"),
                                                    SizedBox(width: Get.width * 0.015),
                                                    Text("View All (${categoryItem.subcategory.length})", style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400, color: Colors.blue)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ) : SizedBox.shrink(),
                                    crossFadeState: categoryItem.isExpanded == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  ),
                                  Divider(color: AppColor.textfild_color, height: 1),
                                ],
                              );
                            },
                          ),
                        ),

                        // drawerIcon(icon: AppIcon.bracelet, text: AppString.bracelet, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.collection, text: AppString.collection, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.earrings, text: AppString.earrings, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.mangalsutra, text: AppString.mangalsutra, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.necklace, text: AppString.necklace, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.ring, text: AppString.ring, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.custom, text: AppString.custom, color: AppColor.white_color),
                        // drawerIcon(icon: AppIcon.dummy, text: AppString.dummy, color: AppColor.white_color),

                        drawerIcon(
                          icon: AppIcon.Order,
                          text: AppString.allJewellery,
                          onTap: drawer.selectedJewellery,
                        ),
                        AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 600),
                          child: (drawer.allJewellery.value) ? horizontalpadding(
                            child: Padding(
                              padding: EdgeInsets.only(left: Get.width / 20),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredCategories2.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final categoryItem = filteredCategories2[index];
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() => categoryItem.isExpanded = !(categoryItem.isExpanded)),
                                        child: SizedBox(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(vertical: Get.width * 0.020),
                                                decoration: BoxDecoration(color: AppColor.pink_color, borderRadius: BorderRadius.circular(Get.width / 50)),
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(AppIcon.Order, width: Get.width * 0.018, height: Get.height * 0.018),
                                              ),
                                              SizedBox(width: Get.width / 30),
                                              SizedBox(width: Get.width / 3.5, child: Text(categoryItem.name, style: TextStyle(fontSize: Get.width * 0.032, fontWeight: FontWeight.w500))),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      AnimatedCrossFade(
                                        duration: Duration(milliseconds: 600),
                                        firstChild: SizedBox.shrink(),
                                        secondChild: categoryItem.subcategory.isNotEmpty ? Padding(
                                          padding: EdgeInsets.only(left: Get.width * 0.08),
                                          child: Column(
                                            children: [
                                              ...categoryItem.subcategory.take(6).map((subItem) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    category.selectCategorySlug(subItem.slug);
                                                    Get.to(() => Subcategorys(
                                                      subcategory_slug: subItem.slug,
                                                      subcategrorysname: AppString.product,
                                                    ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                    child: Row(
                                                      children: [
                                                        Text("*"),
                                                        SizedBox(width: Get.width * 0.015),
                                                        SizedBox(
                                                          width: Get.width / 3,
                                                          child: Text(subItem.name, style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              if (categoryItem.subcategory.length > 6)
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => Subcategorys(
                                                      subcategrorys: categoryItem.slug,
                                                      subcategrorysname: AppString.product,
                                                    ), transition: Transition.rightToLeft, duration: Duration(milliseconds: 600));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                                    child: Row(
                                                      children: [
                                                        Text("*"),
                                                        SizedBox(width: Get.width * 0.015),
                                                        Text("View All (${categoryItem.subcategory.length})", style: TextStyle(fontSize: Get.width * 0.030, fontWeight: FontWeight.w400, color: Colors.blue)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ) : SizedBox.shrink(),
                                        crossFadeState: categoryItem.isExpanded == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                      ),
                                      Divider(color: AppColor.textfild_color, height: 1),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ) : SizedBox.shrink(),
                        ),

                        drawerIcon(icon: AppIcon.Order, text: AppString.Order),
                        drawerIcon(icon: AppIcon.Wishlist, text: AppString.Wishlist),
                        drawerIcon(icon: AppIcon.Wallet, text: AppString.Wallet),
                        drawerIcon(icon: AppIcon.Addresses, text: AppString.Addresses),
                        drawerIcon(icon: AppIcon.HelpCenter, text: AppString.HelpCenter),
                        drawerIcon(icon: AppIcon.PrivacyPolicy, text: AppString.PrivacyPolicy),
                        drawerIcon(
                            icon: AppIcon.Logout,
                            text: AppString.Logout,
                            onTap: () async {
                              Get.dialog(
                                Center(child: Lottie.asset(AppJson.loading2)),
                                barrierDismissible: false,
                              );

                              await Future.delayed(const Duration(seconds: 2)); // Show loader for 2 seconds

                              await localdatabase().logout(); // Clear app data

                              Get.back(); // Close the dialog
                              Get.off(() => Login()); // Navigate to Login screen
                            }),
                        SizedBox(height: Get.height * 0.030),
                      ],
                    );
                  });
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget drawerIcon({required String icon, required String text, void Function()? onTap, Color? color}) {
  return horizontalpadding(
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
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
          Divider(color: AppColor.textfild_color, height: 1),
        ],
      ),
    ),
  );
}
