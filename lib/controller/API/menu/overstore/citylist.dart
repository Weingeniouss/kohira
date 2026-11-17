// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';
import 'package:kohira/services/api_service.dart';

class Citylist extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> citylist() async {
    try {
      isLoading.value = true;
      final url = AppUrl.storecity;

      final response = await ApiService.getApi(url, useAuth: false);
      data.value = response;
    } catch (e) {
      print('Citylist Data Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
