// ignore_for_file: prefer_typing_uninitialized_variables, equal_keys_in_map, unused_local_variable, file_names, non_constant_identifier_names, avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/widget/pop.dart';

class Subcategrory extends GetxController {
  var isLoading = false.obs;
  var data = [].obs;
  List<dynamic> allData = [];
  var draw = 1.obs;
  var start = 0.obs;
  var length = 10.obs;
  var hasMore = true.obs;

  // Filters state
  String? selectedMetalType;
  String? selectedMetalStamp;
  String? selectedCategorySlug;
  String? selectedSubcategorySlug;
  String? selectediamondtype;
  String? selectedweightmin;
  String? selectedweightmax;
  String? selectedpricemin;
  String? selectedpricemax;
  String? selectcenterstoneshape;

  Future<void> subcategroryuser({
    String? draws,
    String? starts,
    String? lengths,
    bool isLoadMore = false,
    String? metal_type,
    String? metal_stamp,
    String? diamond_type,
    String? setting_type,
    String? weight_min,
    String? weight_max,
    String? price_min,
    String? price_max,
    String? order_column,
    String? sort,
    String? category_slug,
    String? subcategory_slug,
    String? finish_status,
    String? center_stone_caret,
    String? center_stone_shape,
    String? collection_id,
    String? j_count,
    String? userid,
  }) async {
    if (isLoading.value || !hasMore.value) return;

    // Save selected filters (used for next pagination)
    if (!isLoadMore) {
      start.value = 0; // reset if new filter is applied
      draw.value = 1;
      hasMore.value = true;
      allData.clear();

      selectedMetalType = metal_type;
      selectedMetalStamp = metal_stamp;
      selectedCategorySlug = category_slug;
      selectedSubcategorySlug = subcategory_slug;
      selectediamondtype = diamond_type;
      selectedweightmin = weight_min;
      selectedweightmax = weight_max;
      selectedpricemin = price_min;
      selectedpricemax = price_max;
      selectcenterstoneshape = center_stone_shape;
    }


    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.product);
      print("Sending request to: $url");

      final Map<String, String> body = {
        'draw':  draws ?? draw.value.toString(),
        'start': starts ??start.value.toString(),
        'length': lengths ?? length.value.toString(),
        if (selectedMetalType != null) 'metal_type': selectedMetalType!,
        if (selectedMetalStamp != null) 'metal_stamp': selectedMetalStamp!,
        if (selectedCategorySlug != null) 'category_slug': selectedCategorySlug!,
        if (selectedSubcategorySlug != null) 'subcategory_slug': selectedSubcategorySlug!,
        if (selectediamondtype != null) 'diamond_type' : selectediamondtype!,
        if (selectedweightmin != null) 'weight_min': selectedweightmin!,
        if (selectedweightmax != null) 'weight_max': selectedweightmax!,
        if (selectedpricemin != null) 'price_min': selectedpricemin!,
        if (selectedpricemax != null) 'price_max': selectedpricemax!,
        if (order_column != null) 'order_column': order_column,
        if (sort != null) 'sort': sort,
        if (finish_status != null) 'finish_status': finish_status,
        if (center_stone_caret != null) 'center_stone_caret': center_stone_caret,
        if (selectcenterstoneshape != null) 'center_stone_shape': selectcenterstoneshape!,
        if (collection_id != null) 'collection_id': collection_id,
        if (j_count != null) 'j_count': j_count,
        if (userid != null) 'userid': userid,
      }..removeWhere((key,value) => value == null);
      print('Subcategory BODY:- $body');
      final response = await http.post(url, headers: {ApiHeaders.heading: ApiHeaders.peramitters}, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final newItems = jsonData['data'] ?? [];
        if (newItems.isEmpty) {
          hasMore.value = false;
        } else {
          if (isLoadMore) {
            allData.addAll(newItems);
            data.addAll(newItems);
          } else {
            allData = newItems;
            data.value = newItems;
          }
          draw.value++;
          start.value += length.value;
        }
        log('Subcategrory Response: $jsonData');
      } else {
        ToastificationError.Error('Subcategrory Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      ToastificationError.Error('Subcategrory Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
  void resetPagination() {
    draw.value = 1;
    start.value = 0;
    hasMore.value = true;
    data.clear();
    allData.clear(); // ✅ Reset both
  }
  void filterSearch(String query) {
    if (query.isEmpty) {
      data.value = allData;
    } else {
      data.value = allData.where((item) => item['title'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    }
  }
}