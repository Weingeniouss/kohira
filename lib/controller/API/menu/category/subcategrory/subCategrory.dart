// ignore_for_file: prefer_typing_uninitialized_variables, equal_keys_in_map, unused_local_variable, file_names, non_constant_identifier_names, avoid_print

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

  Future<void> subcategroryuser({
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

    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.product);
      print("Sending request to: $url");

      final Map<String, String> body = {
        'draw': draw.value.toString(),
        'start': start.value.toString(),
        'length': length.value.toString(),
        if (metal_type != null) 'metal_type': metal_type,
        if (metal_stamp != null) 'metal_stamp': metal_stamp,
        if (diamond_type != null) 'diamond_type': diamond_type,
        if (setting_type != null) 'setting_type': setting_type,
        if (weight_min != null) 'weight_min': weight_min,
        if (weight_max != null) 'weight_max': weight_max,
        if (price_min != null) 'price_min': price_min,
        if (price_max != null) 'price_max': price_max,
        if (order_column != null) 'order_column': order_column,
        if (sort != null) 'sort': sort,
        if (category_slug != null) 'category_slug': category_slug,
        if (subcategory_slug != null) 'subcategory_slug': subcategory_slug,
        if (finish_status != null) 'finish_status': finish_status,
        if (center_stone_caret != null) 'center_stone_caret': center_stone_caret,
        if (center_stone_shape != null) 'center_stone_shape': center_stone_shape,
        if (collection_id != null) 'collection_id': collection_id,
        if (j_count != null) 'j_count': j_count,
        if (userid != null) 'userid': userid,
      };

      print('Subcategrory BODY:- $body');

      final response = await http.post(
        url,
        headers: {ApiHeaders.heading: ApiHeaders.peramitters},
        body: body,
      );

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