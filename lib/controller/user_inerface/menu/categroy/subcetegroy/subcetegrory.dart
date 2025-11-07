// ignore_for_file: non_constant_identifier_names, strict_top_level_inference

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../API/menu/category/subcategrory/subCategrory.dart';

class SubcetegroryShow extends GetxController {
  final subcategrory = Get.put(Subcategrory(), permanent: false);
  final ScrollController scrollController = ScrollController();
  bool dataLoaded = false;

  void loadData({String? subcategrorys, String? subcategory_slug, String? collection_id, String? metal_type, String? price_min, String? price_max}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!dataLoaded) {
        subcategrory.resetPagination();
        subcategrory.subcategroryuser(category_slug: subcategrorys, subcategory_slug: subcategory_slug, collection_id: collection_id, metal_type: metal_type, price_min: price_min, price_max: price_max);
        dataLoaded = true;
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !subcategrory.isLoading.value && subcategrory.hasMore.value) {
        subcategrory.subcategroryuser(category_slug: subcategrorys, isLoadMore: true);
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    Get.delete<Subcategrory>();
    dataLoaded = false;
    super.onClose();
  }
}