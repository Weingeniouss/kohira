// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kohira/controller/API/menu/others/drawer/collection.dart';
import 'package:kohira/view/utils/app_color.dart';
import 'package:kohira/view/utils/app_icon.dart';
import 'package:kohira/view/utils/app_routes.dart';
import 'package:kohira/view/utils/app_string.dart';
import 'package:kohira/view/utils/widget/aapbar.dart';
import 'package:kohira/view/utils/widget/horizontalpading.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/app_json.dart';

List<dynamic> extractCollectionsList(dynamic rawData) {
  if (rawData == null) return [];
  if (rawData is List) return rawData;
  if (rawData is Map) {
    if (rawData['collections'] is List) return List<dynamic>.from(rawData['collections']);
    if (rawData['collection'] is List) return List<dynamic>.from(rawData['collection']);
    if (rawData['data'] is List) return List<dynamic>.from(rawData['data']);
    if (rawData['items'] is List) return List<dynamic>.from(rawData['items']);
    if (rawData['data'] is Map && rawData['data']['collections'] is List) {
      return List<dynamic>.from(rawData['data']['collections']);
    }
  }
  return [];
}

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  Collection get collectionController => Get.isRegistered<Collection>()
      ? Get.find<Collection>()
      : Get.put(Collection());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionController.collectiondata();
    });

    return Scaffold(
      appBar: Appbar(
        lefticon: AppIcon.left,
        hedingname_2: AppString.collection,
        suffixicon_1: AppIcon.like,
        suffixicon_2: AppIcon.shop,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: AppColor.white_color,
        child: Obx(() {
          if (collectionController.isLoading.value &&
              collectionController.data.isEmpty) {
            return _buildSkeletonLoading();
          }

          final List<dynamic> collectionsList =
              extractCollectionsList(collectionController.data);

          if (collectionsList.isEmpty && !collectionController.isLoading.value) {
            return Center(child: Lottie.asset(AppJson.noData));
          }

          return SafeArea(
            child: horizontalpadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Text(
                    AppString.collection,
                    style: TextStyle(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black_color,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Expanded(
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: collectionsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final item = collectionsList[index];
                        return _buildCollectionCard(item);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCollectionCard(dynamic item) {
    final String title = (item['name'] ??
            item['title'] ??
            item['collection_name'] ??
            item['slug'] ??
            '')
        .toString();

    final String imagePath = (item['image'] ??
            item['mobile_img'] ??
            item['image1'] ??
            item['icon'] ??
            item['default_image'] ??
            '')
        .toString();

    final String slug = (item['slug'] ?? item['id']?.toString() ?? '').toString();
    final String collectionId = (item['id']?.toString() ?? '').toString();

    return GestureDetector(
      onTap: () {
        AppRoutes.toSubcategory(
          collection_id: collectionId.isNotEmpty ? collectionId : null,
          subcategory_slug: slug.isNotEmpty ? slug : null,
          subcategrorysname: title,
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagePath.isNotEmpty
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.black_color,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Color(0xFFF7F7F7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 28,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 4),
            Text(
              "NO IMAGES",
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return horizontalpadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.02),
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: AppColor.lodingcolor,
              highlightColor: AppColor.highlightColor,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 70,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
