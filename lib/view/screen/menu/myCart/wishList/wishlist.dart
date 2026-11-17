// ignore_for_file: invalid_use_of_protected_member, dead_null_aware_expression, prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kohira/controller/API/menu/myCart/withoutlogin.dart';
import 'package:kohira/view/utils/app_String.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/pop.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/database/local/localstore.dart';
import '../../../../../controller/user_inerface/menu/myCart/wishlist/wishlist.dart';
import '../../../../../modal/menu/category/subcategory/addtowish.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_json.dart';
import '../../../../utils/widget/horizontalpading.dart';
import '../../category/showproduct.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({super.key});
  final wish = Get.put(WishlistController());
  final wishguest = Get.put(WishcartControllet());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(lefticon: AppIcon.left, hedingname_2: AppString.wishlist),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: AppColor.white_color),
        child: Obx(() {
          final bool isGuest = (tokans.isEmpty ?? true);
          final bool isLoading = isGuest
              ? wish.withoutloginWish.isLoading.value
              : wish.fetchwishlist.isLoading.value;

          if (isLoading) {
            return _buildSkeletonLoading();
          }

          final wishlists = isGuest
              ? wish.withoutloginWish.data['wishlists']
              : wish.fetchwishlist.data['wishlists'];

          if (wishlists == null || wishlists is! List || wishlists.isEmpty) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

          final int wishlistCount = isGuest
              ? (wish.withoutloginWish.data['wishlists'] != null
                  ? wish.withoutloginWish.data['wishlists'].length
                  : 0)
              : (wish.fetchwishlist.data['wishlists'] != null
                  ? wish.fetchwishlist.data['wishlists'].length
                  : 0);

          final indianFormat =
              NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

          return Column(
            children: [
              SizedBox(height: Get.height / 50),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: wishlistCount,
                  itemBuilder: (BuildContext context, int index) {
                    final wishlistsData = isGuest
                        ? wish.withoutloginWish.data['wishlists']
                        : wish.fetchwishlist.data['wishlists'];
                    dynamic wishlistItem;
                    if (wishlistsData is List) {
                      wishlistItem = wishlistsData[index];
                    } else if (wishlistsData is Map) {
                      wishlistItem = wishlistsData[index.toString()];
                    } else {
                      print("Unexpected wishlist type: ${wishlistsData.runtimeType}");
                      return const SizedBox();
                    }

                    // Extract jewelry data
                    final fetch = wishlistItem['WishlistJewelryData'];
                    final id = wishlistItem['id'].toString();
                    final ringSize = wishlistItem['ringsize'];

                    String priceText = '0';
                    if (fetch != null &&
                        fetch['jewelry_diamonds'] != null &&
                        fetch['jewelry_diamonds'] is List &&
                        fetch['jewelry_diamonds'].isNotEmpty) {
                      priceText =
                          fetch['jewelry_diamonds'][0]['price'].toString();
                    }

                    final double parsedPrice =
                        double.tryParse(priceText) ?? 0.0;

                    return GestureDetector(
                      onTap: () {
                        if (fetch != null && fetch['slug'] != null) {
                          print(fetch['slug']);
                          AppRoutes.toShowProduct(
                            slug: fetch['slug'],
                            categoryslug: fetch['category'] != null
                                ? fetch['category']['slug']
                                : '',
                          );
                        }
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
                                    if (fetch != null && fetch['default'] != null)
                                      Image(
                                        image: NetworkImage(
                                            fetch['default']['path']),
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                      ),
                                  ],
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (isGuest) {
                                        List<JewelryItemWish> currentItemswish =
                                            await localdatabase
                                                .getJewelryItemsWish();
                                        final jewelryId = wish
                                            .withoutloginWish
                                            .data['wishlists'][index]['jewelryid']
                                            .toString();
                                        currentItemswish.removeWhere(
                                            (item) => item.jewelryId == jewelryId);
                                        await localdatabase
                                            .saveJewelryItemsWish(currentItemswish);
                                        wish.withoutloginWish
                                            .data['wishlists']
                                            .removeWhere((item) =>
                                                item['jewelryid'].toString() ==
                                                jewelryId);
                                        wish.withoutloginWish.refresh();
                                        WithoutloginWishList()
                                            .withoutloginwishlist(currentItemswish);
                                        wish.onInit();
                                        wishguest.wishcount.value =
                                            currentItemswish.length;
                                        pref!.setString('wishcount',
                                            wishguest.wishcount.value.toString());
                                        wishCount =
                                            pref!.getString('wishcount') ?? '0';
                                        ToastificationSuccess.Success(
                                            'Item removed from wishlist');
                                        Get.forceAppUpdate();
                                      } else {
                                        wish.deleteItem(id).then(
                                          (_) {
                                            wish.onInit();
                                            if (wish.deletWishtlist
                                                    .data['success'] ==
                                                true) {
                                              ToastificationSuccess.Success(
                                                  '${fetch != null ? fetch['title'] : ''}, ${wish.deletWishtlist.data['message'].replaceAll('Item', '')}');
                                            }
                                          },
                                        );
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      AppIcon.heart,
                                      width: 25,
                                      height: 25,
                                      colorFilter: ColorFilter.mode(
                                        AppColor.pink_color,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height / 80),
                            Flexible(
                              child: Text(
                                (fetch != null ? fetch['title'] : '') ?? '',
                                style: TextStyle(fontSize: Get.width / 30),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                indianFormat.format(parsedPrice),
                                style: TextStyle(
                                  color: AppColor.pink_color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Get.width / 28,
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height / 150),
                            (ringSize == null ||
                                    ringSize.toString().isEmpty ||
                                    ringSize.toString().toLowerCase() ==
                                        'null')
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      Text("Ring Size :- ",
                                          style: TextStyle(
                                              fontSize: Get.width / 30,
                                              color: AppColor.grey_color)),
                                      Text(ringSize.toString(),
                                          style: TextStyle(
                                              fontSize: Get.width / 30,
                                              color: AppColor.grey_color)),
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

  Widget _buildSkeletonLoading() {
    return horizontalpadding(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height / 50),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Get.height / 50,
                crossAxisSpacing: Get.width / 50,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return _buildSkeletonItem();
              },
            ),
            SizedBox(height: Get.height / 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Shimmer.fromColors(
      baseColor: AppColor.lodingcolor,
      highlightColor: AppColor.highlightColor,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.white_color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white_color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: Get.height / 100),
            Container(
              width: Get.width * 0.35,
              height: 12,
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(height: 6),
            Container(
              width: Get.width * 0.22,
              height: 12,
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(height: 6),
            Container(
              width: Get.width * 0.15,
              height: 10,
              decoration: BoxDecoration(
                color: AppColor.white_color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
