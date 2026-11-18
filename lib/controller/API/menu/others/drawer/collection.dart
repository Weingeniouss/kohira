// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class Collection extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> collectiondata() async {
    try {
      isLoading.value = true;
      final url = AppUrl.collection;
      print('Sending To url :- $url');
      final response = await ApiCall.getRequest(url, useAuth: false);

      if (response != null) {
        data.value = jsonDecode(jsonEncode(response));
        log('Collection data :- ${data.value}');
      } else {
        throw {'Collection Error :- ${200}, $response'};
      }
    } catch (e) {
      log('Collection Error :- $e');
    } finally {
      isLoading.value = false;
    }
  }
}
