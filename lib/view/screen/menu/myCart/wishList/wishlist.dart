// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import '../../../../../controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import '../../../../utils/app_json.dart';
import '../../category/showproduct.dart';

class WishlistScreen extends StatelessWidget {
  final wish = Get.put(WishlistController());
  WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.wishlist),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          if (wish.fetchwishlist.isLoading.value) {
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

          final wishlists = wish.fetchwishlist.data['wishlists'];

          if (wishlists == null || wishlists is! List || wishlists.isEmpty) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

          final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

          return Column(
            children: [
              SizedBox(height: Get.height / 50),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68),
                    itemCount: (wish.fetchwishlist.data['wishlists'] != null) ? wish.fetchwishlist.data['wishlists'].length: 0,
                    itemBuilder: (BuildContext context, int index) {
                      final wishlistItem = wish.fetchwishlist.data['wishlists'][index];
                      final fetch = wishlistItem['WishlistJewelryData'];
                      final id = wishlistItem['id'].toString();
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
                                      if (fetch != null)
                                        Image(
                                          image: NetworkImage(fetch['default']['path']),
                                          fit: BoxFit.cover, width: 150, height: 150,
                                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                        ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () async {
                                        wish.deleteItem(id).then((_) {
                                          wish.onInit();
                                          if (wish.deletWishtlist.data['success'] == true) {
                                            ToastificationSuccess.Success('${fetch['title']}, ${wish.deletWishtlist.data['message'].replaceAll('Item', '')}');
                                          }},
                                        );
                                        },
                                      child: SvgPicture.asset(AppIcon.heart, width: 25, height: 25, color: AppColor.pink_color),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Get.height / 80),
                              Flexible(
                                child: Text(
                                  fetch['title'] ?? '',
                                  style: TextStyle(fontSize: Get.width / 30),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  indianFormat.format(double.parse(priceText)),
                                  style: TextStyle(
                                      color: AppColor.pink_color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Get.width / 28),
                                ),
                              ),
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
