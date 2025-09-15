// ignore_for_file: prefer_const_constructors, file_names, avoid_print, deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/category/subcategory.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/API/menu/category/subcategrory/filtercategory.dart';
import '../../../../controller/user_inerface/bottamNavigation/bottamNavigation.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/bottomNavigation/bottomNavigation.dart';
import '../../../utils/widget/lodingstate.dart';
import '../home/menuwidget/drawer.dart';

class Categorys extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final category = Get.put(JewelleryFilterCategory());
  Categorys({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final Bottamnavigation bottomSelectController = Get.find<Bottamnavigation>();
        Bottom();
        bottomSelectController.indexOne();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: Appbar(
          prefixicon: AppIcon.menu,
          prefixonTap: () => scaffoldKey.currentState?.openDrawer(),
          hedingname: AppString.categories,
          suffixicon_1: AppIcon.like,
          suffixicon_2: AppIcon.shop,
        ),
        drawer: Drawers(),
        body: Container(
          width: Get.width, height: Get.height,
          decoration: BoxDecoration(color: AppColor.white_color),
          child: Obx(() {
            if(category.isLoading.value) {
              horizontalpadding(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                      SizedBox(height: Get.height / 50),
                    ],
                  ),
                ),
              );
            }
            if (category.filterData.value?.data == null || category.filterData.value!.data.isEmpty) return Center(child: Lottie.asset(AppJson.noData));
            return horizontalpadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height / 50),
                  Text(AppString.categories, style: TextStyle(fontFamily: 'Zapf', fontSize: Get.width / 20)),
                  SizedBox(height: Get.height / 50),

                  // Use Expanded properly for GridView
                  Expanded(
                    child: GridView.builder(
                      itemCount: category.filterData.value!.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Get.height / 50,
                        crossAxisSpacing: Get.width / 50,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final categorieslist = category.filterData.value!.data[index];
                        return GestureDetector(
                          onTap: () {
                             categorieslist.slug;
                             categorieslist.name;
                             print("categorieslist :- ${categorieslist.slug}");
                             Get.to(() => Subcategorys(
                               subcategrorys: categorieslist.slug.toString(),
                               subcategrorysname: categorieslist.name.toString(),
                             ));
                            },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(categorieslist.image.toString()), fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height / 150),
                              Text(
                                categorieslist.name.toString(),
                                style: TextStyle(fontSize: Get.height / 65, fontFamily: 'Lora'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
