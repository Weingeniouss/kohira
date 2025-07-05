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

  Future<void> subcategroryuser({
    String? draw,
    String? start,
    String? length,
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
    try {
      isLoading.value = true;

      final url = Uri.parse(AppUrl.product);
      final Map<String, String?> body = {
        'draw': draw,
        'start': start,
        'length': length,
        'metal_type': metal_type,
        'metal_stamp': metal_stamp,
        'diamond_type': diamond_type,
        'setting_type': setting_type,
        'weight_min': weight_min,
        'weight_max': weight_max,
        'price_min': price_min,
        'price_max': price_max,
        'order_column': order_column,
        'sort': sort,
        'category_slug': category_slug,
        'subcategory_slug': subcategory_slug,
        'finish_status': finish_status,
        'center_stone_caret': center_stone_caret,
        'center_stone_shape': center_stone_shape,
        'collection_id': collection_id,
        'j_count': j_count,
        'userid': userid,
      };
      final filteredBody = <String, String>{};
      body.forEach((key, value) {
        if (value != null) {
          filteredBody[key] = value;
        }
      });

      final response = await http.post(
        url,
        headers: {ApiHeaders.heading: ApiHeaders.peramitters},
        body: filteredBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        data.value = jsonData['data'] ?? [];
        log('Subcategrory :- $jsonData');
      } else {
        ToastificationError.Error('Subcategrory Error this :- ${response.statusCode}, ${response.body}');
        throw {
          'Subcategrory Error this :- ${response.statusCode}, ${response.body}'
        };
      }
    } catch (e) {
      ToastificationError.Error('Subcategrory Error this :- $e');
      print('Subcategrory Error this :- $e');
    }finally{
      isLoading.value = false;
    }
  }
}
