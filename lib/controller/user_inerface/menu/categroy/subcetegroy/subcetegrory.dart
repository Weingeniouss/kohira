// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../API/menu/category/subcategrory/subCategrory.dart';

class SubcetegroryShow extends  GetxController{
  final subcategrory = Get.put(Subcategrory());
  final ScrollController scrollController = ScrollController();
  var dataLoaded = false;

  loadData({required String subcategrorys,required String subcategory_slug}){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(!dataLoaded){
        subcategrory.resetPagination();
        subcategrory.subcategroryuser(category_slug: subcategrorys,subcategory_slug: subcategory_slug);
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
    dataLoaded = false;
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}