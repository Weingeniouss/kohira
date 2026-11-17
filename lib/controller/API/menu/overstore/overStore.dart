// ignore_for_file: avoid_print, non_constant_identifier_names, file_names, invalid_use_of_protected_member, camel_case_types, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/services/api_service.dart';

class Overstore_Controller extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> overStore(
      {String? page, String? search, String? store_city_id}) async {
    try {
      isLoading.value = true;
      final url = AppUrl.store;

      final body = {
        if (page != null) 'page': page,
        if (search != null) 'search': search,
        if (store_city_id != null) 'store_city_id': store_city_id,
      };

      final response = await ApiService.postApi(url, data: body);
      data.value = response;
    } catch (e) {
      print('Over Store :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
