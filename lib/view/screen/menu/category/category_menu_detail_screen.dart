// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import 'package:kohira/controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import 'package:kohira/modal/menu/category/subcategory/filtercategory.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/widget/bottomNavigation/bottomNavigation.dart';

class CategoryMenuDetailScreen extends StatelessWidget {
  final Datum categoryItem;

  CategoryMenuDetailScreen({super.key, required this.categoryItem});

  final wish = Get.put(WishlistController());
  final bottamSelect = Get.put(Bottamnavigation());

  final List<Map<String, dynamic>> metalRows = [
    {
      'name': AppString.whiteGold,
      'slug': 'white-gold',
      'type': 'white',
      'bgColor': AppColor.whiteGoldBg,
      'borderColor': AppColor.whiteGoldBorder,
      'stamps': ['9k', '14k', '18k']
    },
    {
      'name': AppString.yellowGold,
      'slug': 'yellow-gold',
      'type': 'yellow',
      'bgColor': AppColor.yellowGoldBg,
      'borderColor': AppColor.yellowGoldBorder,
      'stamps': ['9k', '14k', '18k']
    },
    {
      'name': AppString.roseGold,
      'slug': 'rose-gold',
      'type': 'rose',
      'bgColor': AppColor.roseGoldBg,
      'borderColor': AppColor.roseGoldBorder,
      'stamps': ['9k', '14k', '18k']
    },
    {
      'name': AppString.yellowGoldAndWhiteGold,
      'slug': 'yellow-gold-white-gold',
      'type': 'yellow_white',
      'bgColor': AppColor.yellowWhiteGoldBg,
      'borderColor': AppColor.yellowWhiteGoldBorder,
      'stamps': ['9k', '14k', '18k']
    },
    {
      'name': AppString.roseGoldAndWhiteGold,
      'slug': 'rose-gold-white-gold',
      'type': 'rose_white',
      'bgColor': AppColor.roseWhiteGoldBg,
      'borderColor': AppColor.roseWhiteGoldBorder,
      'stamps': ['9k', '14k', '18k']
    },
  ];

  final List<Map<String, dynamic>> priceRanges = [
    {'label': AppString.below10k, 'min': '0', 'max': '10000'},
    {'label': AppString.price10kTo20k, 'min': '10001', 'max': '20000'},
    {'label': AppString.price20kTo30k, 'min': '20001', 'max': '30000'},
    {'label': AppString.price30kTo40k, 'min': '30001', 'max': '40000'},
    {'label': AppString.price40kTo50k, 'min': '40001', 'max': '50000'},
    {'label': AppString.above50k, 'min': '50001', 'max': '999999'},
  ];

  Widget _buildMetalSwatch(String colorType) {
    switch (colorType) {
      case 'yellow':
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColor.yellowGoldBorder,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.black26, width: 0.5),
          ),
        );
      case 'rose':
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColor.roseSwatchColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.black26, width: 0.5),
          ),
        );
      case 'white':
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColor.whiteSwatchColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.black38, width: 0.8),
          ),
        );
      case 'yellow_white':
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.black26, width: 0.5),
          ),
          child: ClipOval(
            child: Row(
              children: [
                Expanded(child: Container(color: AppColor.yellowGoldBorder)),
                Expanded(child: Container(color: AppColor.whiteSwatchColor)),
              ],
            ),
          ),
        );
      case 'rose_white':
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.black26, width: 0.5),
          ),
          child: ClipOval(
            child: Row(
              children: [
                Expanded(child: Container(color: AppColor.roseSwatchColor)),
                Expanded(child: Container(color: AppColor.whiteSwatchColor)),
              ],
            ),
          ),
        );
      default:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColor.yellowGoldBorder,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subcategories = categoryItem.subcategory;

    return Scaffold(
      backgroundColor: AppColor.white_color,
      appBar: AppBar(
        backgroundColor: AppColor.white_color,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(AppIcon.left),
          onPressed: () => AppRoutes.back(),
        ),
        title: Text(
          categoryItem.name,
          style: TextStyle(
            color: AppColor.pink_color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lora',
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset(AppIcon.like, width: 22, height: 22),
                onPressed: () {
                  Bottom();
                  bottamSelect.indexTwo();
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.pink_color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "0",
                    style: TextStyle(
                        color: AppColor.white_color,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset(AppIcon.shop, width: 22, height: 22),
                onPressed: () {
                  Bottom();
                  bottamSelect.indexThree();
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.pink_color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "2",
                    style: TextStyle(
                      color: AppColor.white_color,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: AppColor.textfild_color,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Subcategory Styles Cards
            if (subcategories.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: subcategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.6,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final subItem = subcategories[index];
                  return GestureDetector(
                    onTap: () {
                      AppRoutes.toSubcategory(
                        subcategrorys: categoryItem.slug,
                        subcategory_slug: subItem.slug,
                        subcategrorysname: subItem.name,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.white_color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.cardBorderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColor.cardBgColor,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: AppColor.textfild_color),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: subItem.image.isNotEmpty
                                  ? Image.network(
                                      subItem.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Icon(Icons.image_outlined,
                                            size: 20,
                                            color: AppColor.grey_color),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(Icons.image_outlined,
                                          size: 20, color: AppColor.grey_color),
                                    ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subItem.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black_color,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
            ],

            // 2. Section: By Metals & Stamps
            Text(
              AppString.byMetalsAndStamps,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.black_color,
              ),
            ),
            SizedBox(height: 16),

            // Metal Rows List
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: metalRows.length,
              separatorBuilder: (context, index) => SizedBox(height: 14),
              itemBuilder: (context, index) {
                final row = metalRows[index];
                final String name = row['name'];
                final String colorType = row['type'];
                final List<String> stamps = row['stamps'];
                final Color chipBg = row['bgColor'];

                return Row(
                  children: [
                    // Swatch + Metal Name
                    _buildMetalSwatch(colorType),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black_color,
                          height: 1.2,
                        ),
                      ),
                    ),

                    // Vertical Separator Line
                    Container(
                      height: 32,
                      width: 1.0,
                      color: AppColor.separatorLineColor,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),

                    // Stamp Chips Row (9k, 14k, 18k)
                    Row(
                      children: stamps.map((stamp) {
                        return GestureDetector(
                          onTap: () {
                            AppRoutes.toSubcategory(
                              subcategrorys: categoryItem.slug,
                              metal_type: row['slug'],
                              subcategrorysname: "${row['name']} ($stamp)",
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 32,
                            margin: EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColor.chipBorderColor,
                                width: 0.8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                stamp,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black_color,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 28),

            // 3. Section: By Price Range
            Text(
              AppString.byPriceRange,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.black_color,
              ),
            ),
            SizedBox(height: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: priceRanges.map((price) {
                return GestureDetector(
                  onTap: () {
                    AppRoutes.toSubcategory(
                      subcategrorys: categoryItem.slug,
                      price_min: price['min'],
                      price_max: price['max'],
                      subcategrorysname: AppString.product,
                    );
                  },
                  child: Container(
                    width: Get.width * 0.45,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColor.white_color,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColor.priceChipBorderColor,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      price['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.black_color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
