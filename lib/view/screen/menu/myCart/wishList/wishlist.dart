// ignore_for_file: invalid_use_of_protected_member, dead_null_aware_expression, prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

List<dynamic> extractWishlistsList(dynamic rawData) {
  if (rawData == null) return [];
  if (rawData is List) return rawData;
  if (rawData is Map) {
    if (rawData['wishlists'] is List) return List<dynamic>.from(rawData['wishlists']);
    if (rawData['data'] != null) {
      final inner = rawData['data'];
      if (inner is List) return List<dynamic>.from(inner);
      if (inner is Map && inner['wishlists'] is List) {
        return List<dynamic>.from(inner['wishlists']);
      }
    }
    if (rawData['carts'] is List) return List<dynamic>.from(rawData['carts']);
  }
  return [];
}

dynamic extractJewelryData(dynamic wishlistItem) {
  if (wishlistItem == null || wishlistItem is! Map) return null;
  if (wishlistItem['WishlistJewelryData'] != null) return wishlistItem['WishlistJewelryData'];
  if (wishlistItem['CartJewelryData'] != null) return wishlistItem['CartJewelryData'];
  if (wishlistItem['jewelry'] != null) return wishlistItem['jewelry'];
  if (wishlistItem['jewelry_data'] != null) return wishlistItem['jewelry_data'];
  return wishlistItem;
}

String extractImageUrl(dynamic fetch, dynamic wishlistItem) {
  if (fetch is Map) {
    if (fetch['default'] != null && fetch['default'] is Map && fetch['default']['path'] != null) {
      return fetch['default']['path'].toString();
    }
    if (fetch['default_image'] != null && fetch['default_image'].toString().isNotEmpty) {
      return fetch['default_image'].toString();
    }
    if (fetch['image'] != null && fetch['image'].toString().isNotEmpty) {
      return fetch['image'].toString();
    }
    if (fetch['images'] != null && fetch['images'] is List && fetch['images'].isNotEmpty) {
      final first = fetch['images'][0];
      if (first is Map && first['path'] != null) return first['path'].toString();
      if (first is String) return first;
    }
  }
  if (wishlistItem is Map && wishlistItem['default_image'] != null) {
    return wishlistItem['default_image'].toString();
  }
  return '';
}

double extractItemPrice(dynamic fetch, dynamic wishlistItem) {
  if (fetch is Map) {
    if (fetch['offer_price'] != null) {
      final p = double.tryParse(fetch['offer_price'].toString());
      if (p != null && p > 0) return p;
    }
    if (fetch['setting_price'] != null) {
      final p = double.tryParse(fetch['setting_price'].toString());
      if (p != null && p > 0) return p;
    }
    if (fetch['price'] != null) {
      final p = double.tryParse(fetch['price'].toString());
      if (p != null && p > 0) return p;
    }
    if (fetch['jewelry_diamonds'] != null &&
        fetch['jewelry_diamonds'] is List &&
        fetch['jewelry_diamonds'].isNotEmpty) {
      final firstDia = fetch['jewelry_diamonds'][0];
      if (firstDia is Map && firstDia['price'] != null) {
        return double.tryParse(firstDia['price'].toString()) ?? 0.0;
      }
    }
  }
  if (wishlistItem is Map && wishlistItem['price'] != null) {
    return double.tryParse(wishlistItem['price'].toString()) ?? 0.0;
  }
  return 0.0;
}

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
          final bool isGuest = (!islogin || tokans.isEmpty);
          final bool isLoading = isGuest
              ? wish.withoutloginWish.isLoading.value
              : wish.fetchwishlist.isLoading.value;

          if (isLoading) {
            return _buildSkeletonLoading();
          }

          final rawData = isGuest
              ? wish.withoutloginWish.data
              : wish.fetchwishlist.data;

          final List<dynamic> wishlistItemsList = extractWishlistsList(rawData);

          if (wishlistItemsList.isEmpty) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

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
                  itemCount: wishlistItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final wishlistItem = wishlistItemsList[index];
                    final fetch = extractJewelryData(wishlistItem);
                    final id = (wishlistItem['id'] ?? wishlistItem['jewelryid'] ?? '').toString();
                    final ringSize = wishlistItem['ringsize'];
                    final imageUrl = extractImageUrl(fetch, wishlistItem);
                    final parsedPrice = extractItemPrice(fetch, wishlistItem);
                    final titleText = (fetch != null && fetch['title'] != null)
                        ? fetch['title'].toString()
                        : (wishlistItem['title']?.toString() ?? '');

                    return GestureDetector(
                      onTap: () {
                        final slug = (fetch != null && fetch['slug'] != null)
                            ? fetch['slug'].toString()
                            : (wishlistItem['slug']?.toString());
                        if (slug != null && slug.isNotEmpty) {
                          AppRoutes.toShowProduct(
                            slug: slug,
                            categoryslug: (fetch != null && fetch['category'] != null && fetch['category']['slug'] != null)
                                ? fetch['category']['slug'].toString()
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              cacheWidth: 300,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                width: 150,
                                                height: 150,
                                                color: Colors.grey.shade100,
                                                child: Icon(Icons.broken_image, color: Colors.grey),
                                              ),
                                            )
                                          : Container(
                                              width: 150,
                                              height: 150,
                                              color: Colors.grey.shade100,
                                              child: Icon(Icons.broken_image, color: Colors.grey),
                                            ),
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
                                            await localdatabase.getJewelryItemsWish();
                                        final jewelryId = (wishlistItem['jewelryid'] ?? wishlistItem['id'] ?? id).toString();
                                        currentItemswish.removeWhere(
                                            (item) => item.jewelryId == jewelryId);
                                        await localdatabase.saveJewelryItemsWish(currentItemswish);
                                        await wish.loadWishlist();
                                        ToastificationSuccess.Success('Item removed from wishlist');
                                      } else {
                                        wish.deleteItem(id).then(
                                          (_) {
                                            wish.onInit();
                                            if (wish.deletWishtlist.data['success'] == true) {
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
                                titleText,
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
                                    ringSize.toString().toLowerCase() == 'null')
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
