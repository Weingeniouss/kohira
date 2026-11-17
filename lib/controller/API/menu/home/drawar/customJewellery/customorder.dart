// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';

import 'package:kohira/view/utils/app_constants.dart';

import '../../../../../../view/utils/app_url.dart';
import 'package:kohira/api/api_call.dart';

class Customorder extends GetxController {
  var isLoading = false.obs;
  var categories = <Category_Customorder>[].obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchCustomorder() async {
    try {
      isLoading(true);
      isError(false);
      final url = AppUrl.customorder;
      print('Sending To Url :- $url');
      final response = await ApiCall.postRequest(url, useAuth: true);
      if (response != null) {
        final responseData = jsonDecode(jsonEncode(response));
        final List<dynamic> categoriesData = responseData['data'] ?? [];
        categories.value = categoriesData
            .map((item) => Category_Customorder.fromJson(item))
            .toList();
        log('Fetched ${categories.length} categories');
      } else {
        throw Exception('${200}, ${response}');
      }
    } catch (e) {
      print('customorder Error is :- $e');
      isError(true);
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
