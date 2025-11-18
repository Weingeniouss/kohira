// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print, unused_import, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, body_might_complete_normally_nullable, deprecated_member_use, non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables, strict_top_level_inference

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/filtercategory.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/jewelleryfilter.dart';
import 'package:kohira/controller/API/menu/category/subcategrory/subCategrory.dart';
import 'package:kohira/controller/API/menu/others/drawer/Jewellery_list.dart';
import 'package:kohira/controller/user_inerface/menu/categroy/subcetegroy/filter_fuction.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart' show Showproduct;
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/lodingstate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/filter.dart';
import '../../../../controller/user_inerface/menu/categroy/subcetegroy/subcetegrory.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';

// @override
// void didUpdateWidget(Subcategorys oldWidget) {
//   super.didUpdateWidget(oldWidget);
//   // Only reload if important parameters changed
//   if (widget.subcategrorys != oldWidget.subcategrorys || widget.subcategory_slug != oldWidget.subcategory_slug) {
//     show.subcategrory.resetPagination();
//     show.loadData(
//       subcategrorys: widget.subcategrorys.toString(),
//       subcategory_slug: widget.subcategory_slug.toString(),
//       collection_id: widget.collection_id.toString(),
//       metal_type: widget.metal_type,
//       price_min: widget.price_min,
//       price_max: widget.price_max,
//     );
//   }
// }

class Subcategorys extends StatelessWidget {
  String? subcategrorys;
  String? subcategory_slug;
  String? collection_id;
  String? subcategrorysname;
  String? metal_type;
  String? price_min;
  String? price_max;

  Subcategorys({
    super.key,
    this.subcategrorys,
    this.subcategory_slug,
    this.collection_id,
    this.subcategrorysname,
    this.metal_type,
    this.price_min,
    this.price_max,
  });

  @override
  Widget build(BuildContext context) {
    final subUI = Get.put(
      SubcetegroryUIController(
        subcategrorys: subcategrorys,
        subcategory_slug: subcategory_slug,
        collection_id: collection_id,
        subcategrorysname: subcategrorysname,
        metal_type: metal_type,
        price_min: price_min,
        price_max: price_max,
      ),
    );
    return Obx(() {
      return Scaffold(
        appBar: Appbar(lefticon: AppIcon.left, hedingname_2: subUI.currentSubcategoryName.value.toUpperCase()),
        bottomNavigationBar: (subUI.subcategrory.isLoading.value) ?  null : SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColor.white_color),
            height: Get.height * 0.07,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Storebay().storebay(context, subcategrorys: subcategrorys.toString(), subcategory_slug: subcategory_slug.toString()),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                        color: AppColor.white_color,
                        child: Row(
                          children: [
                            Icon(Icons.sort,color: AppColor.glodcolor),
                            SizedBox(width: Get.width / 60),
                            Text(AppString.sortbay,style: TextStyle(fontSize: Get.width / 25,color: AppColor.glodcolor)),
                          ],
                        ),
                      ),
                    ),
                    Text("|",style: TextStyle(color: AppColor.graycolor)),
                    GestureDetector(
                      onTap: () => ShowBottam().showbottam(
                        context,
                        category_slug: subcategrorys.toString(),
                        subcategrorys: subcategory_slug.toString(),
                        subcategrorysname: subcategrorysname.toString(),
                        onCategoryNameChanged: (newName) {
                          subUI.updateSubcategoryName(newName); // Add this line
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 47,vertical: 10),
                        color: AppColor.white_color,
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt_outlined,color: AppColor.glodcolor),
                            SizedBox(width: Get.width / 60),
                            Text(AppString.filter,style: TextStyle(fontSize: Get.width / 25,color: AppColor.glodcolor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: Get.height, width: Get.width, color: AppColor.white_color,
          child: Obx(() {
            if (subUI.subcategrory.isLoading.value && subUI.subcategrory.data.isEmpty) {
              return horizontalpadding(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),
                      Shimmer.fromColors(
                        baseColor: AppColor.lodingcolor,
                        highlightColor: AppColor.highlightColor,
                        child: Container(
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            color: AppColor.white_color,
                            border: Border.all(color: AppColor.textfild_color),
                            borderRadius: BorderRadiusDirectional.circular(Get.width / 50),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 50),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 8,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Get.height / 50,
                          crossAxisSpacing: Get.width / 50,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: AppColor.lodingcolor,
                            highlightColor: AppColor.highlightColor,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.white_color),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(47),
                                    decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                  ),
                                  SizedBox(height: Get.height * 0.010),
                                  Container(
                                    width: Get.width / 4,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                  ),
                                  SizedBox(height: Get.height * 0.010),
                                  Container(
                                    width: Get.width / 6,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: AppColor.white_color, borderRadius: BorderRadius.circular(12)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
            return SafeArea(
              child: horizontalpadding(
                child: RefreshIndicator(
                  strokeWidth: 3.5,
                  color: AppColor.pink_color,
                  backgroundColor: AppColor.white_color,
                  onRefresh: () async {
                    subUI.subcategrory.resetPagination();
                    await subUI.subcategrory.subcategroryuser(category_slug: subcategrorys,subcategory_slug: subcategory_slug);
                  },
                  child: Column(
                    children: [
                      SizedBox(height: Get.height / 50),

                      //Search Start
                      searchField(
                          onChanged: (value){
                            subUI.subcategrory.handleSearch(value);
                            subUI.subcategrory.update();
                          }
                      ),

                      //Search End
                      SizedBox(height: Get.height / 50),
                      (subUI.subcategrory.data.isEmpty)
                          ? Expanded(child: Center(child: Lottie.asset(AppJson.noData)))
                          : Expanded(
                        child: GridView.builder(
                          controller: subUI.scrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: Get.height / 50,
                            crossAxisSpacing: Get.width / 50,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: subUI.subcategrory.data.length + 1,
                          itemBuilder: (context, index) {
                            if (index < subUI.subcategrory.data.length) {
                              final subcategrorys = subUI.subcategrory.data[index];
                              return GestureDetector(
                                onTap: () {
                                  print('Id :- ${subcategrorys['id']}');
                                  print('Slug :- ${subcategrorys['slug']}');
                                  Get.to(() => Showproduct(slug: subcategrorys['slug'], categoryslug: subcategrorys.toString()));
                                  print('Title :- ${subcategrorys.toString()}');
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage(subcategrorys['default_image']), fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Get.height / 150),
                                    Text(
                                      subcategrorys['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      indianFormat.format(double.parse(subcategrorys['discount']?.toString() ?? '0') > 0 ? subcategrorys['offer_price'] : subcategrorys['setting_price']),
                                      style: TextStyle(
                                        fontSize: Get.height / 70,
                                        fontFamily: 'Lora', color: AppColor.pink_color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      (subUI.subcategrory.hasMore.value && subUI.subcategrory.isLoading.value)
                          ? Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            height: 30, width: 30,
                            child: CircularProgressIndicator(strokeWidth: 3.5, color: AppColor.pink_color, backgroundColor: Colors.grey.shade200),
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}