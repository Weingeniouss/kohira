// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/myCart/withoutlogin.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/horizontalpading.dart';
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
          if(wish.fetchwishlist.isLoading.value){
            return horizontalpadding(
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

          final bool isGuest = (tokans?.isEmpty ?? true);

          final wishlists = isGuest ? wish.withoutloginWish.data['wishlists'] : wish.fetchwishlist.data['wishlists'];

          if (wishlists == null || wishlists is! List || wishlists.isEmpty) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

          final int wishlistCount = isGuest
              ? (wish.withoutloginWish.data['wishlists'] != null
              ? wish.withoutloginWish.data['wishlists'].length : 0)
              : (wish.fetchwishlist.data['wishlists'] != null
              ? wish.fetchwishlist.data['wishlists'].length : 0);


          final indianFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

          return Column(
            children: [
              SizedBox(height: Get.height / 50),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68),
                  itemCount: wishlistCount,
                  itemBuilder: (BuildContext context, int index) {
                    final wishlists = isGuest
                        ? wish.withoutloginWish.data['wishlists']
                        : wish.fetchwishlist.data['wishlists'];

                    dynamic wishlistItem;
                    if (wishlists is List) {
                      wishlistItem = wishlists[index];
                    } else if (wishlists is Map) {
                      wishlistItem = wishlists[index.toString()];
                    } else {
                      print("Unexpected wishlist type: ${wishlists.runtimeType}");
                      return const SizedBox();
                    }

                    // Extract jewelry data
                    final fetch = wishlistItem['WishlistJewelryData'];
                    final id = wishlistItem['id'].toString();

                    final ringSize = wishlistItem['ringsize'];

                    String priceText = 'N/A';
                    if (fetch != null &&
                        fetch['jewelry_diamonds'] != null &&
                        fetch['jewelry_diamonds'] is List &&
                        fetch['jewelry_diamonds'].isNotEmpty) {
                      priceText = fetch['jewelry_diamonds'][0]['price'].toString();
                    }
                    if (fetch != null && fetch['jewelry_diamonds'] != null && fetch['jewelry_diamonds'] is List && fetch['jewelry_diamonds'].isNotEmpty) {
                      priceText = fetch['jewelry_diamonds'][0]['price'].toString();
                    }
                    return GestureDetector(
                      onTap: () {
                        print(fetch['slug']);
                        Get.to(() => Showproduct(slug: fetch['slug'], categoryslug: fetch['category']['slug']));
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
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
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
                                          }
                                        },
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
                                style: TextStyle(color: AppColor.pink_color, fontWeight: FontWeight.w600, fontSize: Get.width / 28),
                              ),
                            ),
                            SizedBox(height: Get.height / 150),
                            (ringSize == null || ringSize.toString().isEmpty || ringSize.toString().toLowerCase() == 'null')
                                ? const SizedBox()
                                : Row(
                              children: [
                                Text(
                                  "Ring Size :- ",
                                  style: TextStyle(fontSize: Get.width / 30, color: AppColor.grey_color),
                                ),
                                Text(
                                  ringSize.toString(),
                                  style: TextStyle(fontSize: Get.width / 30, color: AppColor.grey_color),
                                ),
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
        }),
      ),
    );
  }
}
