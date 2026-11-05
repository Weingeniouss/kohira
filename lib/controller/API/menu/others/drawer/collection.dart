// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';
import '../../../../../view/utils/API_headers.dart';

class Collection extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> collectiondata() async {
    try {
      isLoading.value = true;
      final url = AppUrl.collection;
      print('Sending To url :- $url');
      final response = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.data.toString());
        log('Collection data :- ${data.value}');
      } else {
        throw {
          'Collection Error :- ${response.statusCode}, ${response.data}'
        };
      }
    } catch (e) {
      log('Collection Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
