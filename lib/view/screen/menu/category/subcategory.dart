// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, avoid_print, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/subCategrory.dart';
import 'package:kohira/view/screen/menu/category/showproduct.dart' show Showproduct;
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:kohira/view/utils/widget/lodingstate.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_json.dart';
import '../../../utils/widget/aapbar.dart';
import '../../../utils/widget/inputField.dart';

class Subcategorys extends StatefulWidget {
  final String subcategrorys;
  final String subcategrorysname;

  const Subcategorys({
    super.key,
    required this.subcategrorys,
    required this.subcategrorysname,
  });

  @override
  State<Subcategorys> createState() => _SubcategorysState();
}

class _SubcategorysState extends State<Subcategorys> {
  final subcategrory = Get.put(Subcategrory());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    subcategrory.resetPagination();
    subcategrory.subcategroryuser(category_slug: widget.subcategrorys);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !subcategrory.isLoading.value && subcategrory.hasMore.value) {
        subcategrory.subcategroryuser(
          category_slug: widget.subcategrorys,
          isLoadMore: true,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: widget.subcategrorysname),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppColor.white_color,
        child: Obx(() => loading(
          conditiona: subcategrory.isLoading.value && subcategrory.data.isEmpty,
          widget: SafeArea(
            child: horizontalpadding(
              child: RefreshIndicator(
                strokeWidth: 3.5,
                color: AppColor.pink_color,
                backgroundColor: AppColor.white_color,
                onRefresh: () async {
                    subcategrory.resetPagination();
                    await subcategrory.subcategroryuser(category_slug: widget.subcategrorys);
                  },
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 50),
                    searchField(),
                    SizedBox(height: Get.height / 50),
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: Get.height / 50, crossAxisSpacing: Get.width / 50, childAspectRatio: 0.8),
                        itemCount: subcategrory.data.length + 1,
                        itemBuilder: (context, index) {
                          if (index < subcategrory.data.length) {
                            final subcategrorys = subcategrory.data[index];
                            return GestureDetector(
                              onTap: () {
                                print('Id :- ${subcategrorys['id']}');
                                print('Slug :- ${subcategrorys['slug']}');
                                Get.to(() => Showproduct(slug: subcategrorys['slug']));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(subcategrorys['default_image']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(12),
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
                                    "₹ ${subcategrorys['offerprice']}.00",
                                    style: TextStyle(fontSize: Get.height / 70, fontFamily: 'Lora', color: AppColor.pink_color, fontWeight: FontWeight.w700,),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    (subcategrory.hasMore.value && subcategrory.isLoading.value) ?
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: AppColor.pink_color,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
