// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names, avoid_print, prefer_const_constructors, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/widget/pop.dart';

class SearchProduct extends GetxController {
  var isLoading = false.obs;
  var data = RxMap<String, dynamic>();
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (val) {
      if (val.trim().isNotEmpty) {
        SearchProduct_fuction(search: val);
      }
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> SearchProduct_fuction({
    String? search,
    String? type,
    String? metal_type,
    String? metal_stamp,
    String? diamond_type,
    String? setting_type,
    String? weight_min,
    String? weight_max,
    String? price_min,
    String? order_column,
    String? sort,
    String? finish_status,
    String? center_stone_caret,
    String? center_stone_shape,
    String? collection_id,
    String? category_slug,
    String? subcategory_slug,
    String? length,
    String? page,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.search);

      final body = {
        'search': search,
        'type': type,
        'metal_type': metal_type,
        'metal_stamp': metal_stamp,
        'diamond_type': diamond_type,
        'setting_type': setting_type,
        'weight_min': weight_min,
        'weight_max': weight_max,
        'price_min': price_min,
        'order_column': order_column,
        'sort': sort,
        'finish_status': finish_status,
        'center_stone_caret': center_stone_caret,
        'center_stone_shape': center_stone_shape,
        'collection_id': collection_id,
        'category_slug': category_slug,
        'subcategory_slug': subcategory_slug,
        'length': length,
        'page': page,
      }..removeWhere((key, value) => value == null);

      final response = await http.post(url, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        data.value = json['data'];
        ToastificationSuccess.Success(data.value['message']);
      } else {
        log("API Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Search Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

// class SearchProduct extends GetxController {
//   var isLoading = false.obs;
//   var data;
//   var searchQuery = ''.obs;
//
//  void onInit() {
//   debounce(searchQuery, (val) {
//     if (val.isNotEmpty) {
//       SearchProduct_fuction(search: val);
//     }
//   }, time: const Duration(milliseconds: 500));
// }
//
//   Future<void> SearchProduct_fuction({
//     String? search,
//     String? type,
//     String? metal_type,
//     String? metal_stamp,
//     String? diamond_type,
//     String? setting_type,
//     String? weight_min,
//     String? weight_max,
//     String? price_min,
//     String? order_column,
//     String? sort,
//     String? finish_status,
//     String? center_stone_caret,
//     String? center_stone_shape,
//     String? collection_id,
//     String? category_slug,
//     String? subcategory_slug,
//     String? length,
//     String? page,
//   }) async {
//     try {
//       isLoading.value = true;
//
//       final url = Uri.parse(AppUrl.search);
//       final rawBody = {
//         'search': search,
//         'type': type,
//         'metal_type': metal_type,
//         'metal_stamp': metal_stamp,
//         'diamond_type': diamond_type,
//         'setting_type': setting_type,
//         'weight_min': weight_min,
//         'weight_max': weight_max,
//         'price_min': price_min,
//         'order_column': order_column,
//         'sort': sort,
//         'finish_status': finish_status,
//         'center_stone_caret': center_stone_caret,
//         'center_stone_shape': center_stone_shape,
//         'collection_id': collection_id,
//         'category_slug': category_slug,
//         'subcategory_slug': subcategory_slug,
//         'length': length,
//         'page': page,
//       };
//
//       final body = <String, String>{};
//       rawBody.forEach((key, value) {
//         if (value != null) body[key] = value;
//       });
//
//       final response = await http.post(url, body: body);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         data = jsonDecode(response.body);
//         log("Search Data add Suessfully :- $data");
//         ToastificationSuccess.Success('Search Data add Suessfully :- ${response.statusCode}');
//       } else {
//         throw {
//           'Search Data Error :- ${response.statusCode}, ${response.body}',
//           ToastificationError.Error('Search Error :- ${response.statusCode}'),
//         };
//       }
//     } catch (e) {
//       print('Search Error this :- $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
