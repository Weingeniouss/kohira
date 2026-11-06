// ignore_for_file: avoid_print, non_constant_identifier_names, file_names, invalid_use_of_protected_member, camel_case_types, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Overstore_Controller extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> overStore({String? page, String? search, String? store_city_id}) async {
    try {
      isLoading.value = true;
      final url = AppUrl.store;
      print('Sending request to: $url');
      final body = {
        if (page != null) 'page': page,
        if (search != null) 'search': search,
        if (store_city_id != null) 'store_city_id': store_city_id,
      }..removeWhere((key, value) => value == null);
      print('Store body :- $body');
      final response = await DioClient.dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.data.toString());
      }
    } catch (e) {
      print('Over Store :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
