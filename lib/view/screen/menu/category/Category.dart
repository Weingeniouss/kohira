// ignore_for_file: prefer_const_constructors, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/view/screen/menu/category/subcategory.dart';
import 'package:kohira/view/screen/menu/menuwidget/drawer.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import '../../../../controller/API/menu/category/category.dart';
import '../../../utils/app_String.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/lodingstate.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final categrory = Get.put(CategoryCalling());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    categrory.categroryservice();
  }

  @override
  Widget build(BuildContext context) {
    ever(categrory.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading) {
          LoadingState.show(AppJson.loading2);
        } else {
          LoadingState.hide();
        }
      });
    });
    return Scaffold(
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
                    itemCount: categrory.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: Get.height / 50,
                      crossAxisSpacing: Get.width / 50,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final categorieslist = categrory.data[index];
                      return GestureDetector(
                        onTap: () {
                           categorieslist.slug;
                           categorieslist.name;
                           print("categorieslist :- ${categorieslist.slug}");
                           Get.to(() => Subcategorys(subcategrorys: categorieslist.slug.toString(), subcategrorysname: categorieslist.name.toString(),));
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
    );
  }
}
