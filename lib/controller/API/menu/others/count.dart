// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class CountController extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future counting() async {
    try {
      isLoading.value = true;
      final url = AppUrl.count;
      final responce = await ApiCall.getRequest(url, useAuth: true);
      if (responce != null) {
        data.value = jsonDecode(jsonEncode(responce));
      } else {
        throw {'Counting Error :- ${200}, $responce'};
      }
    } catch (e) {
      print("Counting Error :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
