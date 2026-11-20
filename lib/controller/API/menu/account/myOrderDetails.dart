// ignore_for_file: avoid_print, unused_local_variable, file_names, invalid_use_of_protected_member, strict_top_level_inference

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:kohira/view/utils/app_url.dart';

import 'package:kohira/api/api_call.dart';

class Myorderdetails extends GetxController {
  var isLoading = false.obs;
  var data = {}.obs;

  Future<void> myorderdatails(id) async {
    try {
      isLoading.value = true;
      final url = '${AppUrl.orderdetail}$id/myorder';
      print("Sending Request To :- $url");

      final response = await ApiCall.getRequest(url, useAuth: true);

      if (response != null) {
        data.value = jsonDecode(jsonEncode(response));
        log('My Order Details :- ${data.value}');
      } else {
        throw {'My Order Details Error this :- $response, ${200}'};
      }
    } catch (e) {
      print("My Order Details Error this :- $e");
    } finally {
      isLoading.value = false;
    }
  }
}
