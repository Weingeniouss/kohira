// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../controller/API/menu/category/subcategrory/filtercategory.dart';
import '../../../../controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import '../../../../controller/API/menu/category/subcategrory/subCategrory.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_logo.dart';
import '../../../utils/widget/horizontalpading.dart';
import '../category/subcategory.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final jewellery = Get.put(Jewelleryfilter());
  final category = Get.put(JewelleryFilterCategory());
  final subcategrory = Get.put(Subcategrory());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width *0.550,
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
                    return Center(child: Text("No data available"));
                  }
                  return Column(
                    children: [
                      horizontalpadding(
                        child:ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: category.filterData.value!.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final categoryItem = category.filterData.value!.data[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => categoryItem.isExpanded = !(categoryItem.isExpanded ?? false)),
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
                                if (categoryItem.isExpanded == true && categoryItem.subcategory.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(left: Get.width * 0.08),
                                    child: Column(
                                      children: [
                                        // Show first 6 subcategories
                                        ...categoryItem.subcategory.take(6).map((subItem) {
                                          return GestureDetector(
                                            onTap: () {
                                               category.selectCategorySlug(subItem.slug);
                                               Get.to(() => Subcategorys( subcategory_slug: subItem.slug, subcategrorysname: AppString.product));
                                              },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                                              child: Row(
                                                children: [
                                                  Text("*"),
                                                  SizedBox(width: Get.width * 0.015),
                                                  SizedBox(
                                                    width: Get.width / 4,
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
                                              Get.dialog(
                                                AlertDialog(
                                                  title: Text("All ${categoryItem.name} Subcategories"),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: categoryItem.subcategory.map((subItem) {
                                                        return ListTile(
                                                          leading: Text("*"),
                                                          title: Text(subItem.name),
                                                          onTap: () {
                                                            category.selectCategorySlug(subItem.slug);
                                                            Get.back();
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(onPressed: () => Get.back(), child: Text("Close")),
                                                  ],
                                                ),
                                              );
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
                      drawerIcon(icon: AppIcon.Order, text: AppString.Order),
                      drawerIcon(icon: AppIcon.Wishlist, text: AppString.Wishlist),
                      drawerIcon(icon: AppIcon.Wallet, text: AppString.Wallet),
                      drawerIcon(icon: AppIcon.Addresses, text: AppString.Addresses),
                      drawerIcon(icon: AppIcon.HelpCenter, text: AppString.HelpCenter),
                      drawerIcon(icon: AppIcon.PrivacyPolicy, text: AppString.PrivacyPolicy),
                      drawerIcon(icon: AppIcon.Logout, text: AppString.Logout),
                      SizedBox(height: Get.height * 0.030),
                    ],
                  );
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
      onTap: () => onTap,
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
