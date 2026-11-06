// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kohira/view/utils/API_headers.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/view/utils/dio_client.dart';

class Citylist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> citylist() async {
    try {
      isLoading.value = true;
      final url = AppUrl.storecity;
      final response = await DioClient.dio.get(
        url,
        options: Options(headers: {ApiHeaders.heading: ApiHeaders.peramitters}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        data.value = jsonDecode(response.data.toString());
        log("Citylist Data :-  ${data.value}");
      } else {
        throw {
          'Citylist Data Error :-  ${response.data}, ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Citylist Data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
