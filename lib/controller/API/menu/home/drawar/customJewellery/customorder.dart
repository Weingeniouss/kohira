// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/modal/menu/home/drawar/customJewellery/category_customorder.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_constants.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../../../view/utils/app_url.dart';

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
      final response = await DioClient.dio.post(
        url,
        options: Options(
          headers: {
            ApiHeaders.heading: ApiHeaders.peramitters,
            ApiHeaders.authorization: tokans,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.data.toString());
        final List<dynamic> categoriesData = responseData['data'] ?? [];
        categories.value = categoriesData
            .map((item) => Category_Customorder.fromJson(item))
            .toList();
        log('Fetched ${categories.length} categories');
      } else {
        throw Exception('${response.statusCode}, ${response.data}');
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
