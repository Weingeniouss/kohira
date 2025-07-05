// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subCategrory.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart' show Showproduct;
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';
import '../../../utils/widget/lodingstate.dart';

class Subcategorys extends StatefulWidget {
  final String subcategrorys;
  final String subcategrorysname;

  const Subcategorys({super.key, required this.subcategrorys, required this.subcategrorysname});

  @override
  State<Subcategorys> createState() => _SubcategorysState();
}

class _SubcategorysState extends State<Subcategorys> {
  final subcategrory = Get.put(Subcategrory());

  @override
  void initState() {
    super.initState();
    subcategrory.subcategroryuser(category_slug: widget.subcategrorys);
  }

  @override
  Widget build(BuildContext context) {
    ever(subcategrory.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading) {
          LoadingState.show(AppJson.loading2);
        } else {
          LoadingState.hide();
        }
      });
    });
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: widget.subcategrorysname),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (subcategrory.isLoading.value) {
            return Center(child: Lottie.asset(AppJson.loading2));
          } else {
            return SafeArea(
              child: horizontalpadding(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    searchField(),
                    SizedBox(height: Get.height / 50),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Get.height / 50,
                          crossAxisSpacing: Get.width / 50,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: subcategrory.data.length,
                        itemBuilder: (context, index) {
                          final subcategrorys = subcategrory.data[index];
                          return GestureDetector(
                            onTap: (){
                              print('Id :- ${subcategrorys['id']}');
                              print('slug :- ${subcategrorys['slug']}');
                              Get.to(() => Showproduct(slug: subcategrorys['slug']));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(subcategrorys['default_image']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height / 150),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  subcategrorys['title'],
                                  style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora'),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "₹ ${subcategrorys['offerprice'].toString()}",
                                  style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora', color: AppColor.pink_color),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
