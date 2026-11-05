// ignore_for_file: prefer_typing_uninitialized_variables, equal_keys_in_map, unused_local_variable, file_names, non_constant_identifier_names, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Subcategrory extends GetxController {
  var isLoading = false.obs;
  var data = [].obs;
  List<dynamic> allData = [];
  var draw = 1.obs;
  var start = 0.obs;
  var length = 10.obs;
  var hasMore = true.obs;
  Timer? _searchTimer;
  var searchQuery = ''.obs;
  var isSearching = false.obs;

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
    if (isLoadMore && (!hasMore.value || isLoading.value)) return;

    if (!isLoadMore) {
      start.value = 0;
      draw.value = 1;
      hasMore.value = true;
      isLoading.value = false;
      allData.clear();
      data.clear();

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

      final url = AppUrl.product;
      print("Sending request to: $url");

      final Map<String, String> body = {
        'draw': draws ?? draw.value.toString(),
        'start': starts ?? start.value.toString(),
        'length': lengths ?? length.value.toString(),
        if (selectedMetalType != null && selectedMetalType!.isNotEmpty)
          'metal_type': selectedMetalType!,
        if (selectedMetalStamp != null && selectedMetalStamp!.isNotEmpty)
          'metal_stamp': selectedMetalStamp!,
        if (selectedCategorySlug != null && selectedCategorySlug!.isNotEmpty)
          'category_slug': selectedCategorySlug!,
        if (selectedSubcategorySlug != null &&
            selectedSubcategorySlug!.isNotEmpty)
          'subcategory_slug': selectedSubcategorySlug!,
        if (selectediamondtype != null && selectediamondtype!.isNotEmpty)
          'diamond_type': selectediamondtype!,
        if (selectedweightmin != null && selectedweightmin!.isNotEmpty)
          'weight_min': selectedweightmin!,
        if (selectedweightmax != null && selectedweightmax!.isNotEmpty)
          'weight_max': selectedweightmax!,
        if (selectedpricemin != null && selectedpricemin!.isNotEmpty)
          'price_min': selectedpricemin!,
        if (selectedpricemax != null && selectedpricemax!.isNotEmpty)
          'price_max': selectedpricemax!,
        if (order_column != null && order_column.isNotEmpty)
          'order_column': order_column,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
        if (finish_status != null && finish_status.isNotEmpty)
          'finish_status': finish_status,
        if (center_stone_caret != null && center_stone_caret.isNotEmpty)
          'center_stone_caret': center_stone_caret,
        if (selectcenterstoneshape != null &&
            selectcenterstoneshape!.isNotEmpty)
          'center_stone_shape': selectcenterstoneshape!,
        if (collection_id != null && collection_id.isNotEmpty)
          'collection_id': collection_id,
        if (j_count != null && j_count.isNotEmpty) 'j_count': j_count,
        if (userid != null && userid.isNotEmpty) 'userid': userid,
      }..removeWhere((key, value) => value == null || value.toString().isEmpty);
      print('Subcategory BODY:- $body');
      final response = await DioClient.dio.post(
        url,
        data: body,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.data.toString());
        final newItems = jsonData['data'] ?? [];
        if (newItems.isEmpty) {
          hasMore.value = false;
        } else {
          if (isLoadMore) {
            allData.addAll(newItems);
            data.addAll(newItems);
          } else {
            allData = List.from(newItems);
            data.value = List.from(newItems);
          }
          draw.value++;
          start.value += length.value;
        }
        log('Subcategrory Response: $jsonData');
      } else {
        print('Subcategrory Error: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      print('Subcategrory Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetPagination() {
    draw.value = 1;
    start.value = 0;
    hasMore.value = true;
    isLoading.value = false;
    data.clear();
    allData.clear();
  }

  void handleSearch(String query) {
    searchQuery.value = query;
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        data.value = List.from(allData);
        isSearching.value = false;
      } else if (query.length >= 2) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    isSearching.value = true;

    final localResults = allData.where((item) {
      final title = item['title']?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    data.value = localResults;
    isSearching.value = false;
  }

  void clearSearch() {
    searchQuery.value = '';
    data.value = List.from(allData);
    isSearching.value = false;
    _searchTimer?.cancel();
  }

  void filterSearch(String query) {
    if (allData.isEmpty) return;

    if (query.isEmpty) {
      data.value = allData;
    } else {
      data.value = allData
          .where((item) => item['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }
}
