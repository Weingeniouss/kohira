// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/category/wishlist.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:lottie/lottie.dart' show Lottie;
import '../../../../utils/app_json.dart';
import '../../category/showproduct.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController controller = Get.put(WishlistController());
  WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname: AppString.wishlist),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
            if (controller.fetchwishlist.isLoading.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen != true) {
                  Get.dialog(
                    Center(child: Lottie.asset(AppJson.loading2)),
                    barrierDismissible: false,
                  );
                }
              });
              return Scaffold(backgroundColor: Colors.transparent);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }
              });
            }

            return Column(
              children: [
                SizedBox(height: Get.height / 50),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: controller.fetchwishlist.data['wishlists'].length,
                    itemBuilder: (BuildContext context, int index) {
                      final wishlistItem = controller.fetchwishlist.data['wishlists'][index];
                      final fetch = wishlistItem['WishlistJewelryData'];
                      final item = controller.wishlistItems[index];
                      final id = item['id'].toString();

                      // Safely extract price
                      String priceText = 'N/A';
                      if (fetch != null && fetch['jewelry_diamonds'] != null && fetch['jewelry_diamonds'] is List && fetch['jewelry_diamonds'].isNotEmpty) {
                        priceText = fetch['jewelry_diamonds'][0]['price'].toString();
                      }

                      return GestureDetector(
                        onTap: () {
                          print(fetch['slug']);
                          Get.to(() => Showproduct(slug: fetch['slug']));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(fetch['default']['path'], width: 150, height: 150),
                                    ],
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () => controller.deleteItem(id),
                                      child: SvgPicture.asset(AppIcon.heart, width: 25, height: 25, color: AppColor.pink_color),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Get.height / 80),
                              Text(fetch['itemcode'] ?? '', style: TextStyle(fontSize: Get.width / 27)),
                              Text('₹ $priceText', style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600, fontSize: Get.width / 28)),
                              SizedBox(height: Get.height / 150),
                              (wishlistItem['ringsize'] == null)
                                  ? SizedBox()
                                  : Row(
                                children: [
                                  Text("Ring Size :- ", style: TextStyle(fontSize: Get.width / 30, color: AppColor.grey_color)),
                                  Text(wishlistItem['ringsize'].toString(), style: TextStyle(fontSize: Get.width / 30, color: AppColor.grey_color)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
