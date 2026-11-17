// ignore_for_file: dead_null_aware_expression, prefer_const_constructors, deprecated_member_use, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/user_inerface/menu/home/menuwidget/drawer.dart';
import 'package:kohira/modal/menu/category/subcategory/filtercategory.dart';
import 'package:kohira/view/screen/credentials/login.dart';
import 'package:kohira/view/screen/menu/home/menuwidget/customjewellery.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/app_string.dart';
import '../../../../utils/app_constants.dart';
import '../../account/privacy policy/privacy.dart';

class Drawers extends StatelessWidget {
  Drawers({super.key});

  final category = Get.put(JewelleryFilterCategory());
  final drawer = Get.put(DrawerInterface());

  final bool isGuest = (tokans.isEmpty ?? true);

  void _openCategoryDetail(BuildContext context, Datum cat) async {
    final scaffold = Scaffold.of(context);
    Navigator.of(context).pop();
    await AppRoutes.toCategoryDetail(categoryItem: cat);
    scaffold.openDrawer();
  }

  void _openDefaultSubcategory(
    BuildContext context,
    String slug,
    String name,
  ) async {
    final scaffold = Scaffold.of(context);
    Navigator.of(context).pop();
    await AppRoutes.toSubcategory(
      subcategrorys: slug,
      subcategrorysname: name,
    );
    scaffold.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width,
      elevation: 0,
      backgroundColor: AppColor.white_color,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Header Bar (Pink Solid Background with Profile & Close Icon)
            Container(
              color: AppColor.pink_color,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColor.white_color,
                    child: Text(
                      "G",
                      style: TextStyle(
                        color: AppColor.pink_color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // User Info
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isGuest) {
                          Navigator.of(context).pop();
                          Get.to(() => Login());
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.guestUser,
                            style: TextStyle(
                              color: AppColor.white_color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppString.tapToLogin,
                            style: TextStyle(
                              color: AppColor.white_color.withOpacity(0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Close Drawer Icon
                  IconButton(
                    icon: Icon(Icons.close,
                        color: AppColor.white_color, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 2. Drawer Body Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  if (category.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(
                          color: AppColor.pink_color,
                        ),
                      ),
                    );
                  }

                  final categories = category.menuCategories;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Category List Items (Engagement Rings, Rings, For Him, Earrings, Pendants, Necklaces, etc.)
                      if (categories.isNotEmpty)
                        ...categories.map((cat) {
                          return _buildMenuItem(
                            title: cat.name,
                            onTap: () => _openCategoryDetail(context, cat),
                          );
                        }),

                      // Fallback static category items if categories are empty
                      if (categories.isEmpty) ...[
                        _buildMenuItem(
                          title: AppString.engagementRings,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "engagement-rings",
                            AppString.engagementRings,
                          ),
                        ),
                        _buildMenuItem(
                          title: AppString.ring,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "rings",
                            AppString.ring,
                          ),
                        ),
                        _buildMenuItem(
                          title: AppString.forHim,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "for-him",
                            AppString.forHim,
                          ),
                        ),
                        _buildMenuItem(
                          title: AppString.earrings,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "earrings",
                            AppString.earrings,
                          ),
                        ),
                        _buildMenuItem(
                          title: AppString.pendant,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "pendants",
                            AppString.pendant,
                          ),
                        ),
                        _buildMenuItem(
                          title: AppString.necklace,
                          onTap: () => _openDefaultSubcategory(
                            context,
                            "necklaces",
                            AppString.necklace,
                          ),
                        ),
                      ],

                      // Additional Standard Items
                      _buildMenuItem(
                        title: AppString.allJewellery,
                        onTap: () => _openDefaultSubcategory(
                          context,
                          "all",
                          AppString.allJewellery,
                        ),
                      ),
                      _buildMenuItem(
                        title: AppString.collection,
                        onTap: () => _openDefaultSubcategory(
                            context, "collections", AppString.collection),
                      ),
                      _buildMenuItem(
                        title: AppString.custom,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(
                            () => CustomJewellery(),
                          );
                          scaffold.openDrawer();
                        },
                      ),

                      // 3. Gold Mine Promo Card
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColor.promoCardBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.pink_color),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                AppString.gold_Mine,
                                style: TextStyle(
                                  fontFamily: 'Zapf',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.pink_color,
                                ),
                              ),
                            ),
                            Text(
                              "${AppString.num} ${AppString.monthlyPlan.toUpperCase()}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black_color,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. Policy & Info Menu Items
                      _buildMenuItem(
                        title: AppString.aboutUs,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),
                      _buildMenuItem(
                        title: AppString.faqs,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),
                      _buildMenuItem(
                        title: AppString.shippingPolicy,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),
                      _buildMenuItem(
                        title: AppString.returnPolicy,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),
                      _buildMenuItem(
                        title: AppString.termsCondition,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),
                      _buildMenuItem(
                        title: AppString.PrivacyPolicy,
                        onTap: () async {
                          final scaffold = Scaffold.of(context);
                          Navigator.of(context).pop();
                          await Get.to(() => Privacy());
                          scaffold.openDrawer();
                        },
                      ),

                      // 5. Locate Our Stores Banner
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColor.storeBannerBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColor.storeBannerBorder),
                        ),
                        child: Center(
                          child: Text(
                            AppString.locateOurStores,
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.storeBannerText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  );
                }),
              ),
            ),

            // 6. Bottom Sign In Button (For Guests)
            if (isGuest)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => Login());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.pink_color,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppString.signInToExplore,
                      style: TextStyle(
                        color: AppColor.white_color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          dense: true,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black_color,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColor.black_color.withOpacity(0.54),
          ),
          onTap: onTap,
        ),
        Container(
          color: AppColor.textfild_color,
          height: 1.0,
        ),
      ],
    );
  }
}

class MyCustomContainer extends StatelessWidget {
  final Color? firstColor;
  final Color? secondColor;
  final double size;

  const MyCustomContainer(
      {this.firstColor, this.secondColor, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: firstColor),
              child: Container(
                decoration: BoxDecoration(
                  color: firstColor,
                  border: Border.all(color: AppColor.white_color, width: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: secondColor),
              child: Container(
                decoration: BoxDecoration(
                  color: secondColor,
                  border: Border.all(color: AppColor.white_color, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SinglContainer extends StatelessWidget {
  final double size;
  final Color? singlcolor;

  const SinglContainer({super.key, required this.size, this.singlcolor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(color: singlcolor),
        child: Container(
          decoration: BoxDecoration(
            color: singlcolor,
            border: Border.all(color: AppColor.white_color, width: 2),
          ),
        ),
      ),
    );
  }
}
