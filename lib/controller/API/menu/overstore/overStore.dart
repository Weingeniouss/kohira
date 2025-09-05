// ignore_for_file: avoid_print, non_constant_identifier_names, file_names, invalid_use_of_protected_member, camel_case_types, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/app_constants.dart';

class Overstore_Controller extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> overStore({String? page, String? search, String? store_city_id}) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(AppUrl.store);
      print('Sending request to: $url');
      final body = {
        if (page != null)  'page': page,
        if (search != null) 'search': search,
        if (store_city_id != null) 'store_city_id': store_city_id,
      }..removeWhere((key,value) => value == null);
      print('Store body :- $body');
      final response = await http.post(
        url,
        body: body,
        headers: {ApiHeaders.heading: ApiHeaders.peramitters, ApiHeaders.authorization: tokans},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.body);
        // log('Over Store :- ${data.value}');
      }
    } catch (e) {
      print('Over Store :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
